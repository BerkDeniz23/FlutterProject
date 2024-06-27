import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_places/global.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _emailTextEditingController = TextEditingController();
  TextEditingController _passwordTextEditingController = TextEditingController();
  TextEditingController _firstNameTextEditingController = TextEditingController();
  TextEditingController _lastNameTextEditingController = TextEditingController();
  TextEditingController _cityTextEditingController = TextEditingController();
  TextEditingController _bioTextEditingController = TextEditingController();
  TextEditingController _phoneNumberTextEditingController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  File? imageFileOfUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 140, 219, 188),
        title: const Text(
          'Yeni Hesap Oluşturun',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: "Email"),
                        style: const TextStyle(
                          fontSize: 25,
                        ),
                        controller: _emailTextEditingController,
                        validator: (text) {
                          if (text!.isEmpty) {
                            return "Lütfen bir email giriniz.";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: "Şifre"),
                        style: const TextStyle(
                          fontSize: 25,
                        ),
                        controller: _passwordTextEditingController,
                        obscureText: true,
                        validator: (valuePassword) {
                          if (valuePassword!.length < 5) {
                            return "5 karakterden uzun bir şifre giriniz.";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: "İsim"),
                        style: const TextStyle(
                          fontSize: 25,
                        ),
                        controller: _firstNameTextEditingController,
                        validator: (text) {
                          if (text!.isEmpty) {
                            return "Lütfen isminizi giriniz.";
                          }
                          return null;
                        },
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: "Soyad"),
                        style: const TextStyle(
                          fontSize: 25,
                        ),
                        controller: _lastNameTextEditingController,
                        validator: (text) {
                          if (text!.isEmpty) {
                            return "Lütfen Soyadınızı giriniz.";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: "Şehir"),
                        style: const TextStyle(
                          fontSize: 25,
                        ),
                        controller: _cityTextEditingController,
                        validator: (text) {
                          if (text!.isEmpty) {
                            return "Lütfen Şehrinizi giriniz.";
                          }
                          return null;
                        },
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: "Bio"),
                        style: const TextStyle(
                          fontSize: 25,
                        ),
                        controller: _bioTextEditingController,
                        maxLines: 4,
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: "Telefon Numarası"),
                        style: const TextStyle(
                          fontSize: 25,
                        ),
                        controller: _phoneNumberTextEditingController,
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 38.0),
              child: MaterialButton(
                onPressed: () async {
                  var imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (imageFile != null) {
                    imageFileOfUser = File(imageFile.path);

                    setState(() {
                      imageFileOfUser;
                    });
                  }
                },
                child: imageFileOfUser == null
                    ? const Icon(Icons.add_a_photo)
                    : CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 140, 219, 188),
                        radius: MediaQuery.of(context).size.width / 5.0,
                        child: CircleAvatar(
                          backgroundImage: FileImage(imageFileOfUser!),
                          radius: MediaQuery.of(context).size.width / 5.2,
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 50.0, top: 26.0),
              child: ElevatedButton(
                onPressed: () {
                  if (!_formkey.currentState!.validate() || imageFileOfUser == null) {
                    Get.snackbar("Eksik Alan", "Lütfen tüm formu doldurunuz!");
                    return;
                  }
                  if (_emailTextEditingController.text.isEmpty &&
                      _passwordTextEditingController.text.isEmpty) {
                    Get.snackbar("Eksik Alan", "Lütfen tüm formu doldurunuz!");
                    return;
                  }

                  userViewModel.signUp(
                    _emailTextEditingController.text.trim(),
                    _passwordTextEditingController.text.trim(),
                    _firstNameTextEditingController.text.trim(),
                    _lastNameTextEditingController.text.trim(),
                    _cityTextEditingController.text.trim(),
                    _bioTextEditingController.text.trim(),
                    _phoneNumberTextEditingController.text.trim(),
                    imageFileOfUser,
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 140, 219, 188),
                    padding: const EdgeInsets.symmetric(horizontal: 60)),
                child: const Text(
                  "Kayıt ol",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}
