import 'package:flutter/material.dart';
import 'package:password_manager_app/pages/LoginPage.dart';
import 'package:password_manager_app/pages/RegisterPage.dart';
import 'package:password_manager_app/pages/TwoFactorAuthPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Şifre Yöneticisi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/2fa': (context) => TwoFactorAuthPage(email: ModalRoute.of(context)!.settings.arguments as String),
      },
    );
  }
}
