import 'package:flutter/material.dart';
import 'package:password_manager_app/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

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
                  "Giriş Yap",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 40),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "E-posta veya Kullanıcı Adı",
                    labelStyle: TextStyle(color: Colors.black54),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Şifre",
                    labelStyle: TextStyle(color: Colors.black54),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/forgot-password', arguments: emailController.text);
                    },
                    child: Text("Şifremi Unuttum",
                        style: TextStyle(color: Colors.black54)),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                          });
                          bool success = await AuthService().login(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          setState(() {
                            isLoading = false;
                          });
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Giriş başarılı!")),
                            );
                            Navigator.pushNamed(context, '/2fa',
                                arguments: emailController.text);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Giriş başarısız!")),
                            );
                          }
                        },
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
                            Text("Yükleniyor...",
                                style: TextStyle(color: Colors.white)),
                          ],
                        )
                      : Text("Giriş Yap",
                          style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.popAndPushNamed(context, '/register');
                  },
                  child: Text(
                    "Hesabın Yok Mu? Kaydol",
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
      ),
    );
  }
}
