import 'package:flutter_places/model/contact_model.dart';
import 'package:flutter_places/model/posting_model.dart';

class BookingModel {
  String id = "";
  PostingModel? posting;
  ContactModel? contact;
  List<DateTime>? dates;

  BookingModel();
}
