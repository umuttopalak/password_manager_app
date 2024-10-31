import 'package:flutter/material.dart';
import 'package:password_manager_app/services/auth_service.dart';

class VerifyResetCodePage extends StatefulWidget {
  final String email;

  VerifyResetCodePage({required this.email});

  @override
  _VerifyResetCodePageState createState() => _VerifyResetCodePageState();
}

class _VerifyResetCodePageState extends State<VerifyResetCodePage> {
  final TextEditingController codeController = TextEditingController();
  bool isLoading = false;

  Future<void> _verifyCode() async {
    setState(() {
      isLoading = true;
    });

    bool success = await AuthService().verifyForgotPasswordCode(
      email: widget.email,
      code: codeController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (success) {
      Navigator.pushNamed(context, '/reset-password', arguments: {"email" : widget.email, "code" : codeController.text});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kod doğrulanamadı")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Kod Doğrulama",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 40),
                TextField(
                  controller: codeController,
                  decoration: InputDecoration(
                    labelText: "Kod",
                    labelStyle: TextStyle(color: Colors.black54),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: isLoading ? null : _verifyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isLoading
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
