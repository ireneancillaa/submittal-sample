import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class ApiService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> login(String username, String password) async {
    try {
      // 1. Ambil Base URL dari Firebase
      debugPrint('🔍 ApiService: Mengambil base URL dari Firestore...');
      DocumentSnapshot urlDoc = await _firestore
          .collection('url')
          .doc('login')
          .get();
      if (!urlDoc.exists) {
        throw "❌ Konfigurasi URL tidak ditemukan di Firebase. Periksa koleksi 'url' dengan dokumen 'login'";
      }

      String baseUrl = urlDoc.get('url');
      debugPrint('✅ ApiService: Base URL ditemukan: $baseUrl');

      if (baseUrl.endsWith('/'))
        baseUrl = baseUrl.substring(0, baseUrl.length - 1);

      // 2. Gabungkan dengan routes /login
      final String fullUrl = "$baseUrl/login";
      debugPrint('🔗 ApiService: Full URL: $fullUrl');

      // 3. Request ke API
      debugPrint(
        '📤 ApiService: Mengirim request login untuk username: $username',
      );
      final response = await http
          .post(
            Uri.parse(fullUrl),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({'username': username, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      debugPrint('📥 ApiService: Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        debugPrint('✅ ApiService: Login berhasil');
        debugPrint('📋 ApiService: User data - $userData');
        return UserModel.fromJson(userData);
      } else {
        debugPrint('❌ ApiService: Server Error ${response.statusCode}');
        debugPrint('📋 ApiService: Response body: ${response.body}');
        throw "Server Error: ${response.statusCode}";
      }
    } catch (e) {
      debugPrint('❌ ApiService: Error Login - $e');
      rethrow;
    }
  }

  // Fungsi untuk ambil data tambahan berdasarkan email
  Future<DocumentSnapshot?> getUserProfileByEmail(String email) async {
    try {
      debugPrint(
        '🔍 ApiService: Query Firestore - collection: user-myfave, email: $email',
      );

      // Coba query dengan email eksak dulu
      QuerySnapshot query = await _firestore
          .collection('user-myfave')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final doc = query.docs.first;
        debugPrint('✅ ApiService: Dokumen ditemukan (exact match) - ${doc.id}');
        debugPrint('📋 ApiService: Data dokumen - ${doc.data()}');
        return doc;
      }

      // Jika tidak ketemu, coba dengan menambahkan domain default (@cp.co.id)
      if (!email.contains('@')) {
        final emailWithDomain = '$email@cp.co.id';
        debugPrint(
          '🔄 ApiService: Exact match tidak ketemu, coba dengan domain: $emailWithDomain',
        );

        QuerySnapshot queryWithDomain = await _firestore
            .collection('user-myfave')
            .where('email', isEqualTo: emailWithDomain)
            .limit(1)
            .get();

        if (queryWithDomain.docs.isNotEmpty) {
          final doc = queryWithDomain.docs.first;
          debugPrint(
            '✅ ApiService: Dokumen ditemukan (dengan domain) - ${doc.id}',
          );
          debugPrint('📋 ApiService: Data dokumen - ${doc.data()}');
          return doc;
        }
      }

      debugPrint(
        '⚠️ ApiService: Tidak ada dokumen yang cocok untuk email: $email',
      );
      debugPrint('💡 ApiService: Tips untuk fix:');
      debugPrint(
        '   1. Pastikan field email di Firestore match dengan format email API',
      );
      debugPrint('   2. Atau gunakan field lain seperti LDAP ID untuk query');
      return null;
    } catch (e) {
      debugPrint('❌ ApiService: Error Firebase Firestore - $e');
      debugPrint('🔧 ApiService: Kemungkinan penyebab:');
      debugPrint('   - Permission denied (check Firestore security rules)');
      debugPrint('   - Koleksi tidak ada di Firestore');
      debugPrint('   - Email tidak ditemukan di Firebase');
      rethrow;
    }
  }

  /// Fallback login - validasi credentials dari Firestore
  /// Digunakan ketika API down/tidak bisa diakses
  Future<UserModel> loginWithFirestore(String username, String password) async {
    try {
      debugPrint('🔄 ApiService: Fallback - Validasi login via Firestore...');
      debugPrint('👤 ApiService: Username: $username');

      // 1. Konversi username ke email format
      String email = username;
      if (!email.contains('@')) {
        email = '$email@cp.co.id';
      }

      debugPrint('📧 ApiService: Fallback - Query email: $email');

      // 2. Query user di collection 'user-myfave' berdasarkan email
      QuerySnapshot query = await _firestore
          .collection('user-myfave')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        debugPrint(
          '❌ ApiService: Fallback - User tidak ditemukan untuk email: $email',
        );
        throw 'Username atau email tidak ditemukan';
      }

      final userDoc = query.docs.first;
      debugPrint('✅ ApiService: Fallback - User ditemukan');

      // 3. Validasi password
      final storedPassword = userDoc.get('password');
      if (storedPassword != password) {
        debugPrint('❌ ApiService: Fallback - Password salah');
        throw 'Password salah';
      }

      debugPrint('✅ ApiService: Fallback - Password valid');

      // 4. Buat UserModel dari Firestore data
      return UserModel(
        status: 0, // 0 = sukses
        message: 'Login Firestore fallback berhasil',
        email: userDoc.get('email'),
        name: userDoc.get('name') ?? userDoc.get('email'),
        apikey: userDoc.id,
        ldapid: userDoc.get('ldapid'),
      );
    } catch (e) {
      debugPrint('❌ ApiService: Fallback Login Error - $e');
      rethrow;
    }
  }
}
