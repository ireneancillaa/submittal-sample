import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final obscurePassword = true.obs;

  void toggleObscure() {
    obscurePassword.value = !obscurePassword.value;
  }

  void login() {
    Get.offNamed('/dashboard');
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
