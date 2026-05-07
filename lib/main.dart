import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'pages/dashboard_page.dart';
import 'pages/login_page.dart';
import 'controllers/history_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(HistoryController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My FAVE',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF008CFF)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: child,
        );
      },
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/dashboard', page: () => const DashboardPage()),
      ],
    );
  }
}
