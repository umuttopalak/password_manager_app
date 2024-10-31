import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  bool isLoggedIn = false;
  String? authToken;

  final String baseUrl =
      'https://wasteful-amelie-topalak-f4ba58c0.koyeb.app/api/authentication';

  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'name': fullName,
        }),
      );
      if (response.statusCode == 201) {
        debugPrint("Kayıt başarılı!");
        return true;
      } else {
        debugPrint("Kayıt başarısız: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Kayıt hatası: $e");
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint("2FA kodu e-postaya gönderildi.");
        return true;
      } else {
        debugPrint("Giriş başarısız: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Giriş hatası: $e");
      return false;
    }
  }

  Future<bool> verifyTwoFactorCode({
    required String email,
    required String code,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify-2fa'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'code': code,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        authToken = responseData['data']['token'];
        isLoggedIn = true;
        debugPrint("2FA doğrulaması başarılı!");
        return true;
      } else {
        debugPrint("2FA doğrulama hatası: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("2FA doğrulama hatası: $e");
      return false;
    }
  }

  Future<bool> resendVerifyCode({
    required String email,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/resend-2fa'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        debugPrint("2FA yeniden gönderme başarılı!");
        return true;
      } else {
        debugPrint("2FA yeniden gönderme hatası: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("2FA yeniden gönderilirken hata aldı: $e");
      return false;
    }
  }

  Future<bool> sendForgotPasswordCode({
    required String email,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        debugPrint("Şifre sıfırlama kodu gönderildi.");
        return true;
      } else {
        debugPrint("Şifre sıfırlama kodu gönderme hatası: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Şifre sıfırlama kodu gönderme hatası: $e");
      return false;
    }
  }

  Future<bool> verifyForgotPasswordCode({
    required String email,
    required String code,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify-forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'code': code,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint("Şifre sıfırlama kodu doğrulandı.");
        return true;
      } else {
        debugPrint("Şifre sıfırlama kodu doğrulama hatası: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Şifre sıfırlama kodu doğrulama hatası: $e");
      return false;
    }
  }

  Future<bool> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'code': code,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint("Şifre sıfırlama başarılı.");
        return true;
      } else {
        debugPrint("Şifre sıfırlama hatası: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Şifre sıfırlama hatası: $e");
      return false;
    }
  }

  Future<void> logout() async {
    isLoggedIn = false;
    authToken = null;
    debugPrint("Çıkış başarılı.");
  }
}
