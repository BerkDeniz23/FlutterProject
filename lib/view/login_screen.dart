import 'package:flutter/material.dart';
import 'package:flutter_places/global.dart';
import 'package:flutter_places/view/signup_screen.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 120, 50, 30),
              child: Image.asset("images/trakyamekan2.png"),
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Giriş Yapın",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Color.fromARGB(255, 140, 219, 188),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 26.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Email",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(15),
                          ),
                          style: const TextStyle(
                            fontSize: 24,
                          ),
                          controller: _emailTextEditingController,
                          validator: (valueEmail) {
                            if (!valueEmail!.contains("@")) {
                              return "Lütfen geçerli bir email giriniz";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 21.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Şifre",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(15),
                          ),
                          style: const TextStyle(
                            fontSize: 24,
                          ),
                          controller: _passwordTextEditingController,
                          obscureText: true,
                          validator: (valuePassword) {
                            if (valuePassword!.length < 5) {
                              return "Şifreniz 5 karakterden uzun olmalıdır.";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 26.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              await userViewModel.login(_emailTextEditingController.text.trim(),
                                  _passwordTextEditingController.text.trim());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 140, 219, 188),
                            padding: const EdgeInsets.symmetric(horizontal: 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text(
                            "Giriş Yap",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(const SignupScreen());
                      },
                      child: const Text(
                        "Hesabınız yok mu? Kayıt olun",
                        style: TextStyle(
                          color: Color.fromARGB(255, 140, 219, 188),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
