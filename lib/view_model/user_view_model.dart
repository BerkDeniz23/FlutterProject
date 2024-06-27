import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_places/model/app_constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_places/model/user_model.dart';
import 'package:flutter_places/view/guest_home_screen.dart';
import 'package:flutter_places/view/login_screen.dart';
import 'package:get/get.dart';

class UserViewModel {
  UserModel userModel = UserModel();

  signUp(email, password, firstName, lastName, city, bio, phoneNumber, imageFileOfUser) async {
    Get.snackbar("Lütfen bekleyin", "Hesabınızı oluşturuyoruz.");
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then(
        (result) async {
          String currentUserID = result.user!.uid;

          AppConstants.currentUser.id = currentUserID;
          AppConstants.currentUser.email = email;
          AppConstants.currentUser.password = password;
          AppConstants.currentUser.firstName = firstName;
          AppConstants.currentUser.lastName = lastName;
          AppConstants.currentUser.city = city;
          AppConstants.currentUser.bio = bio;
          AppConstants.currentUser.phoneNumber = phoneNumber;

          await saveUserToFirestore(
                  bio, city, email, firstName, lastName, currentUserID, phoneNumber)
              .whenComplete(() async {
            await addImageToFirebaseStorage(imageFileOfUser, currentUserID);
          });

          Get.to(GuestHomeScreen());
          Get.snackbar("Tebrikler", "Başarıyla kayıt oldunuz!");
        },
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> saveUserToFirestore(bio, city, email, firstName, lastName, id, phoneNumber) async {
    Map<String, dynamic> dataMap = {
      "bio": bio,
      "email": email,
      "phoneNumber": phoneNumber,
      "city": city,
      "firstName": firstName,
      "lastName": lastName,
      "isHost": false,
      "myPostingIDs": [],
      "savedPostingIDs": []
    };

    await FirebaseFirestore.instance.collection("users").doc(id).set(dataMap);
  }

  addImageToFirebaseStorage(File imageFileOfUser, currentUserID) async {
    Reference referenceStorage = FirebaseStorage.instance
        .ref()
        .child("userImages")
        .child(currentUserID)
        .child(currentUserID + ".png");

    await referenceStorage.putFile(imageFileOfUser).whenComplete(() {});
    AppConstants.currentUser.displayImage = MemoryImage(imageFileOfUser.readAsBytesSync());
  }

  login(email, password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((result) async {
        String currentUserID = result.user!.uid;
        AppConstants.currentUser.id = currentUserID;
        await getUserInfoFromFirestore(currentUserID);
        await getImageFromStorage(currentUserID);
        await AppConstants.currentUser.getMyPostingsFromFirestore();

        Get.to(GuestHomeScreen());
      });
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'wrong-password') {
          Get.snackbar("Error", "Yanlış şifre girdiniz. Lütfen tekrar deneyin.");
        } else if (e.code == 'user-not-found') {
          Get.snackbar("Error", "Böyle bir kullanıcı bulunamadı. Lütfen tekrar deneyin.");
        } else {
          Get.snackbar("Error", e.message ?? "Bilinmeyen bir hata oluştu.");
        }
      } else {
        Get.snackbar("Error", "Bilinmeyen bir hata oluştu.");
      }
    }
  }

  getUserInfoFromFirestore(userID) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();

    AppConstants.currentUser.snapshot = snapshot;
    AppConstants.currentUser.firstName = snapshot["firstName"] ?? "";
    AppConstants.currentUser.lastName = snapshot["lastName"] ?? "";
    AppConstants.currentUser.city = snapshot["city"] ?? "";
    AppConstants.currentUser.email = snapshot["email"] ?? "";
    AppConstants.currentUser.bio = snapshot["bio"] ?? "";
    AppConstants.currentUser.isHost = snapshot["isHost"] ?? false;
  }

  getImageFromStorage(userID) async {
    if (AppConstants.currentUser.displayImage != null) {
      return AppConstants.currentUser.displayImage;
    }
    final imageDataInBytes = await FirebaseStorage.instance
        .ref()
        .child("userImages")
        .child(userID)
        .child(userID + ".png")
        .getData(1024 * 1024);

    AppConstants.currentUser.displayImage = MemoryImage(imageDataInBytes!);
    return AppConstants.currentUser.displayImage;
  }

  becomeHost(String userID) async {
    userModel.isHost = true;

    Map<String, dynamic> dataMap = {
      "isHost": true,
    };
    await FirebaseFirestore.instance.collection("users").doc(userID).update(dataMap);
  }

  modifyCurrentlyHosting(bool isHosting) {
    userModel.isCurrentlyHosting = isHosting;
  }

  logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      AppConstants.currentUser = UserModel();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
