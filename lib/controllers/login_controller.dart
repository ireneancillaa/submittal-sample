import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';

class LoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final obscurePassword = true.obs;
  final isLoading = false.obs;

  // Data User untuk Profile
  var userModel = Rxn<UserModel>();
  var division = "-".obs;
  var role = "-".obs;
  var firebaseEmail = "-".obs;

  final ApiService _apiService = ApiService();

  void toggleObscure() => obscurePassword.value = !obscurePassword.value;

  Future<void> login() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      _showSnackbar(
        "Error",
        "Username dan password tidak boleh kosong",
        Colors.red,
      );
      return;
    }

    try {
      isLoading.value = true;
      bool useApiLogin = true;
      UserModel? result;
      String? userEmail;

      // =====================================================
      // 1. COBA LOGIN VIA API (PRIMARY)
      // =====================================================
      try {
        debugPrint('🔐 Login: Mencoba login via API...');
        result = await _apiService.login(
          usernameController.text,
          passwordController.text,
        );

        if (result.status == 0) {
          useApiLogin = true;
          userEmail = result.email;
          debugPrint('✅ Login: API login berhasil');
        } else {
          throw result.message;
        }
      } catch (apiError) {
        debugPrint('❌ Login: API login gagal - $apiError');
        debugPrint('🔄 Login: Mencoba fallback ke Firestore...');

        try {
          result = await _apiService.loginWithFirestore(
            usernameController.text,
            passwordController.text,
          );

          useApiLogin = false;
          userEmail = result.email;
          debugPrint('✅ Login: Firestore fallback login berhasil');

          _showSnackbar(
            "⚠️ Informasi",
            "Menggunakan mode offline (API sedang tidak tersedia)",
            Colors.orange,
          );
        } catch (firebaseError) {
          debugPrint('❌ Login: Firestore fallback juga gagal - $firebaseError');
          _showSnackbar("Gagal", "Login gagal: $firebaseError", Colors.red);
          return;
        }
      }

      // =====================================================
      // 2. AMBIL PROFIL & ROLE DARI FIREBASE
      // =====================================================
      if (userEmail != null && userEmail.isNotEmpty) {
        debugPrint('🔍 Login: Mencari profil Firebase untuk email: $userEmail');
        try {
          final profileDoc = await _apiService.getUserProfileByEmail(userEmail);

          if (profileDoc != null) {
            final firebaseRole = profileDoc.get('role');
            final firebaseDivision = profileDoc.get('division');

            // ✅ VALIDASI ROLE - HARUS NOT NULL
            if (firebaseRole == null ||
                firebaseRole.toString().isEmpty ||
                firebaseRole.toString().toLowerCase() == 'null') {
              debugPrint('⛔ Login: Role NULL - Login ditolak');
              _showSnackbar(
                "Akses Ditolak",
                "Role belum dikonfigurasi. Hubungi administrator.",
                Colors.red,
              );
              return;
            }

            division.value = firebaseDivision ?? "-";
            role.value = firebaseRole;
            firebaseEmail.value = profileDoc.get('email') ?? "-";

            debugPrint(
              '✅ Login: Profil Firebase ditemukan - Division: ${division.value}, Role: ${role.value}',
            );
          } else {
            debugPrint(
              '⚠️ Login: Profil Firebase tidak ditemukan untuk email: $userEmail',
            );
            _showSnackbar(
              "Perhatian",
              "Profil pengguna tidak ditemukan di sistem",
              Colors.orange,
            );
            return;
          }
        } catch (firebaseError) {
          debugPrint('❌ Login: Error Firebase - $firebaseError');
          _showSnackbar(
            "Error Firebase",
            "Gagal memuat data profile: $firebaseError",
            Colors.red,
          );
          return;
        }
      } else {
        debugPrint('⚠️ Login: Email kosong atau null');
        _showSnackbar(
          "Perhatian",
          "Email tidak ditemukan dari server",
          Colors.orange,
        );
        return;
      }

      // =====================================================
      // 3. LOGIN SUKSES
      // =====================================================
      userModel.value = result;

      final loginMethod = useApiLogin ? 'API' : 'Firestore Fallback';
      _showSnackbar(
        "Sukses",
        "Selamat datang, ${result.name}\n(via $loginMethod)",
        Colors.green,
      );

      Get.offAllNamed('/dashboard');
    } catch (e) {
      debugPrint('❌ Login: Error - $e');
      _showSnackbar("Error", e.toString(), Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  void _showSnackbar(String title, String message, Color color) {
    Get.snackbar(
      title,
      message,
      backgroundColor: color,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
