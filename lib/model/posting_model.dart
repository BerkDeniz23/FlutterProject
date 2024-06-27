import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_places/model/booking_model.dart';
import 'package:flutter_places/model/contact_model.dart';
import 'package:flutter_places/model/review_model.dart';

class PostingModel {
  String? id;
  String? name;
  String? type;
  int? capacity;
  String? description;
  String? address;
  String? city;
  double? rating;
  int? price;

  ContactModel? host;

  List<String>? imageNames;
  List<MemoryImage>? displayImages;
  List<String>? amenities;

  List<BookingModel>? bookings;
  List<ReviewModel>? reviews;

  PostingModel(
      {this.id = "",
      this.name = "",
      this.type = "",
      this.capacity = 0,
      this.price = 0,
      this.description = "",
      this.address = "",
      this.city = "",
      this.host}) {
    displayImages = [];
    amenities = [];

    rating = 0;

    bookings = [];
    reviews = [];
  }

  setImagesNames() {
    imageNames = [];

    for (int i = 0; i < displayImages!.length; i++) {
      imageNames!.add("image${i}.png");
    }
  }

  getPostingInfoFromFirestore() async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('postings').doc(id).get();

    getPostingInfoFromSnapshot(snapshot);
  }

  getPostingInfoFromSnapshot(DocumentSnapshot snapshot) {
    address = snapshot['address'] ?? "";
    amenities = List<String>.from(snapshot['amenities']) ?? [];
    city = snapshot['city'] ?? "";
    description = snapshot['description'] ?? "";

    String hostID = snapshot['hostID'] ?? "";
    host = ContactModel(id: hostID);

    imageNames = List<String>.from(snapshot['imageNames']) ?? [];
    name = snapshot['name'] ?? "";
    capacity = snapshot['capacity'] ?? 0;
    price = snapshot['price'] ?? 0;
    rating = snapshot['rating'].toDouble() ?? 2.5;
    type = snapshot['type'] ?? "";
  }

  getAllImagesFromStorage() async {
    displayImages = [];

    for (int i = 0; i < imageNames!.length; i++) {
      final imageData = await FirebaseStorage.instance
          .ref()
          .child("postingImages")
          .child(id!)
          .child(imageNames![i])
          .getData(1024 * 1024);

      displayImages!.add(MemoryImage(imageData!));
    }

    return displayImages;
  }

  getFirstImageFromStorage() async {
    if (displayImages!.isNotEmpty) {
      return displayImages!.first;
    }

    final imageData = await FirebaseStorage.instance
        .ref()
        .child("postingImages")
        .child(id!)
        .child(imageNames!.first)
        .getData(1024 * 1024);

    displayImages!.add(MemoryImage(imageData!));

    return displayImages!.first;
  }

  getAmenititesString() {
    if (amenities!.isEmpty) {
      return "";
    }

    String amenitiesString = amenities.toString();

    return amenitiesString.substring(1, amenitiesString.length - 1);
  }

  double getCurrentRating() {
    if (reviews!.length == 0) {
      return 4;
    }

    double rating = 0;

    reviews!.forEach((review) {
      rating += review.rating!;
    });

    rating /= reviews!.length;

    return rating;
  }

  getHostFromFirestore() async {
    await host!.getContactInfoFromFirestore();
    await host!.getImageFromStorage();
  }

  String getFullAddress() {
    return address!;
  }
}
