import 'package:flutter/material.dart';
import 'package:password_manager_app/services/auth_service.dart';

class TwoFactorAuthPage extends StatefulWidget {
  final String email; // Kullanıcının e-postasını almak için
  TwoFactorAuthPage({required this.email});

  @override
  _TwoFactorAuthPageState createState() => _TwoFactorAuthPageState();
}

class _TwoFactorAuthPageState extends State<TwoFactorAuthPage> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final AuthService _authService = AuthService();

  // Kodu birleştirip doğrulama işlevini çağır
  void _verifyOtp() async {
    String otpCode =
        _otpControllers.map((controller) => controller.text).join();

    if (otpCode.length == 6) {
      bool isVerified = await _authService.verifyTwoFactorCode(
        email: widget.email,
        code: otpCode,
      );

      if (isVerified) {
        // Doğrulama başarılı, kullanıcıyı ana sayfaya yönlendirin veya bilgi gösterin
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Hata mesajı göster
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Doğrulama başarısız. Lütfen tekrar deneyin.")),
        );
      }
    } else {
      // Kodu eksik girdiğinde uyarı ver
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lütfen 6 haneli kodu girin")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("2 Adımlı Doğrulama",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Text("Telefonunuza gönderilen kodu girin.",
                  textAlign: TextAlign.center),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) => _buildOtpBox(index)),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyOtp,
                child: Text("Doğrula"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Kod tekrar gönderme işlevi
                },
                child: Text("Kod Gönderilmedi mi? Tekrar Gönder"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _otpControllers[index],
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(counterText: ""),
        onChanged: (value) {
          if (value.length == 1 && index < 5) {
            FocusScope.of(context).nextFocus(); // Bir sonraki kutuya geç
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus(); // Bir önceki kutuya dön
          }
        },
      ),
    );
  }
}
