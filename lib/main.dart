import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:password_manager_app/pages/ForgotPasswordPage.dart';
import 'package:password_manager_app/pages/LoginPage.dart';
import 'package:password_manager_app/pages/RegisterPage.dart';
import 'package:password_manager_app/pages/ResetPasswordPage.dart';
import 'package:password_manager_app/pages/TwoFactorAuthPage.dart';
import 'package:password_manager_app/pages/VerifyResetCodePage.dart';

Future<void> main() async {
  // Firebase başlatmadan önce widgetları bağlayın
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase başlatma
  await Firebase.initializeApp();

  // Crashlytics ayarları
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Analytics: Ana sayfa giriş gibi olayları kaydetmek için örneklendirme
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  analytics.logAppOpen();

  // Uygulama başlatma
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
        '/2fa': (context) => TwoFactorAuthPage(
            email: ModalRoute.of(context)!.settings.arguments as String),
        '/forgot-password': (context) => ForgotPasswordPage(
            email: ModalRoute.of(context)!.settings.arguments as String),
        '/verify-reset-code': (context) {
          final email = ModalRoute.of(context)!.settings.arguments as String?;
          return VerifyResetCodePage(email: email ?? "");
        },
        '/reset-password': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          final email = args['email']!;
          final code = args['code']!;
          return ResetPasswordPage(email: email, code: code);
        },
      },
    );
  }
}
