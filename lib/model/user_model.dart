import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_places/model/booking_model.dart';
import 'package:flutter_places/model/contact_model.dart';
import 'package:flutter_places/model/conversation_model.dart';
import 'package:flutter_places/model/posting_model.dart';
import 'package:flutter_places/model/review_model.dart';
import 'package:get/get.dart';

class UserModel extends ContactModel {
  String? email;
  String? password;
  String? bio;
  String? city;
  String? country;
  String? phoneNumber;
  bool? isHost;
  bool? isCurrentlyHosting;
  DocumentSnapshot? snapshot;

  List<PostingModel>? savedPostings;
  List<PostingModel>? myPostings;

  UserModel({
    String id = "",
    String firstName = "",
    String lastName = "",
    MemoryImage? displayImage,
    this.email = "",
    this.phoneNumber = "",
    this.bio = "",
    this.city = "",
    this.country = "",
  }) : super(id: id, firstName: firstName, lastName: lastName, displayImage: displayImage) {
    isHost = false;
    isCurrentlyHosting = false;

    savedPostings = [];
    myPostings = [];
  }

  createContactFromUser() {
    return ContactModel(
      id: id,
      firstName: firstName,
      lastName: lastName,
      displayImage: displayImage,
    );
  }

  addPostingToMyPostings(PostingModel posting) async {
    myPostings!.add(posting);

    List<String> myPostingIDsList = [];

    myPostings!.forEach((element) {
      myPostingIDsList.add(element.id!);
    });

    await FirebaseFirestore.instance.collection("users").doc(id).update({
      'myPostingIDs': myPostingIDsList,
    });
  }

  getMyPostingsFromFirestore() async {
    List<String> myPostingIDs = List<String>.from(snapshot!["myPostingIDs"]) ?? [];

    for (String postingID in myPostingIDs) {
      PostingModel posting = PostingModel(id: postingID);
      await posting.getPostingInfoFromFirestore();

      await posting.getAllImagesFromStorage();

      myPostings!.add(posting);
    }
  }

  addSavedPosting(PostingModel posting) async {
    for (var savedPosting in savedPostings!) {
      if (savedPosting.id == posting.id) {
        return;
      }
    }

    savedPostings!.add(posting);

    List<String> savedPostingIDs = [];

    savedPostings!.forEach((savedPosting) {
      savedPostingIDs.add(savedPosting.id!);
    });

    await FirebaseFirestore.instance.collection("users").doc(id).update({
      'savedPostingIDs': savedPostingIDs,
    });

    Get.snackbar("Favorilerinize kaydedildi", "Listenize bakabilirsiniz",
        duration: const Duration(seconds: 2));
  }

  removeSavedPosting(PostingModel posting) async {
    for (int i = 0; i < savedPostings!.length; i++) {
      if (savedPostings![i].id == posting.id) {
        savedPostings!.removeAt(i);
        break;
      }
    }

    List<String> savedPostingIDs = [];

    savedPostings!.forEach((savedPosting) {
      savedPostingIDs.add(savedPosting.id!);
    });

    await FirebaseFirestore.instance.collection("users").doc(id).update({
      'savedPostingIDs': savedPostingIDs,
    });

    Get.snackbar("Favorilerden çıkarıldı", "Listenizden kaldırıldı.");
  }

  addConversation(PostingModel posting) async {
    ConversationModel conversation = ConversationModel();
    conversation.addConversationToFirestore(posting.host!);
    String textMessage = "Merhaba, mekan hakkında bilgi almak istiyorum.";
    await conversation.addMessageToFirestore(textMessage);
  }

  Future<void> loadUserInfoFromFirestore() async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    snapshot = userSnapshot;

    List<String> savedPostingIDs = List<String>.from(userSnapshot['savedPostingIDs'] ?? []);
    savedPostings = [];
    for (String postingID in savedPostingIDs) {
      PostingModel posting = PostingModel(id: postingID);
      await posting.getPostingInfoFromFirestore();
      savedPostings!.add(posting);
    }
  }
}
