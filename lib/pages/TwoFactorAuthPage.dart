import 'package:flutter/material.dart';
import 'package:password_manager_app/services/auth_service.dart';

class TwoFactorAuthPage extends StatefulWidget {
  final String email;
  TwoFactorAuthPage({required this.email});

  @override
  _TwoFactorAuthPageState createState() => _TwoFactorAuthPageState();
}

class _TwoFactorAuthPageState extends State<TwoFactorAuthPage> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final AuthService _authService = AuthService();
  bool isVerifying = false;
  bool isResending = false;

  // Kodu birleştirip doğrulama işlevini çağır
  void _verifyOtp() async {
    String otpCode =
        _otpControllers.map((controller) => controller.text).join();

    if (otpCode.length == 6) {
      setState(() {
        isVerifying = true;
      });

      bool isVerified = await _authService.verifyTwoFactorCode(
        email: widget.email,
        code: otpCode,
      );

      setState(() {
        isVerifying = false;
      });

      if (isVerified) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Doğrulama başarısız. Lütfen tekrar deneyin.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lütfen 6 haneli kodu girin")),
      );
    }
  }

  Future<void> _resendCode() async {
    setState(() {
      isResending = true;
    });

    bool success = await AuthService().resendVerifyCode(email: widget.email);

    setState(() {
      isResending = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "${widget.email} adresine doğrulama kodu tekrar yollandı")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("2FA Kodu tekrar yollanırken hata oluştu!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "2 Adımlı Doğrulama",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                "Telefonunuza gönderilen kodu girin.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) => _buildOtpBox(index)),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: isVerifying ? null : _verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isVerifying
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.hourglass_empty, color: Colors.white),
                          SizedBox(width: 10),
                          Text("Doğrulanıyor...",
                              style: TextStyle(color: Colors.white)),
                        ],
                      )
                    : Text("Doğrula", style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 15),
              TextButton(
                onPressed: isResending ? null : _resendCode,
                child: isResending
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.hourglass_empty, color: Colors.black87),
                          SizedBox(width: 10),
                          Text("Tekrar Gönderiliyor...",
                              style: TextStyle(color: Colors.black87)),
                        ],
                      )
                    : Text(
                        "Kod Gönderilmedi mi? Tekrar Gönder",
                        style: TextStyle(
                          color: Colors.black87,
                          decoration: TextDecoration.underline,
                        ),
                      ),
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
      height: 50,
      alignment: Alignment.center,
      child: TextField(
        controller: _otpControllers[index],
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          counterText: "",
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black12),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black54),
          ),
        ),
        onChanged: (value) {
          if (value.length == 1 && index < 5) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }
}
