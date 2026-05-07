import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Pastikan LoginController sudah terdaftar
    final LoginController controller = Get.isRegistered<LoginController>()
        ? Get.find<LoginController>()
        : Get.put(LoginController());

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            SizedBox.expand(
              child: Image.asset(
                'assets/img/background.jpeg',
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final double radius = (constraints.maxWidth * 0.15)
                              .clamp(32.0, 72.0);
                          return CircleAvatar(
                            radius: radius,
                            backgroundColor: Colors.blue[50],
                            child: Image.asset(
                              'assets/img/logo.png',
                              width: radius * 1.6,
                              height: radius * 1.6,
                              fit: BoxFit.contain,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'My FAVE',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF002A56),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'PT SHS International',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 32),
                      _LoginTextField(
                        icon: Icons.person_outline,
                        hint: 'Username',
                        controller: controller.usernameController,
                        obscure: false,
                      ),
                      const SizedBox(height: 16),
                      Obx(
                        () => _LoginTextField(
                          icon: Icons.lock_outline,
                          hint: 'Password',
                          controller: controller.passwordController,
                          obscure: controller.obscurePassword.value,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.obscurePassword.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: controller.toggleObscure,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF008CFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: controller.login,
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginTextField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final Widget? suffixIcon;

  const _LoginTextField({
    required this.icon,
    required this.hint,
    required this.controller,
    required this.obscure,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blue[700]),
        suffixIcon: suffixIcon,
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFB3E0FF),
            width: 1.2,
          ), // biru muda
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF008CFF), width: 2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
      ),
    );
  }
}
