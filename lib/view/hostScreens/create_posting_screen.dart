// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:flutter_places/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_places/model/app_constants.dart';
import 'package:flutter_places/model/posting_model.dart';
import 'package:flutter_places/view/host_home_screen.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostingScreen extends StatefulWidget {
  PostingModel? posting;

  CreatePostingScreen({
    super.key,
    this.posting,
  });

  @override
  State<CreatePostingScreen> createState() => _CreatePostingScreenState();
}

class _CreatePostingScreenState extends State<CreatePostingScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _nameTextEditingController = TextEditingController();
  TextEditingController _capacityTextEditingController = TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _descriptionTextEditingController = TextEditingController();
  TextEditingController _addressTextEditingController = TextEditingController();
  TextEditingController _amenitiesTextEditingController = TextEditingController();

  final List<String> category = [
    'Düğün Salonu',
    'Kır Düğünü Mekanı',
    'Otel',
    'Davet Alanları',
    'Sosyal Tesis',
  ];
  String categorySelected = "";
  String citySelected = "";

  List<MemoryImage>? _imagesList;

  _selectImageFromGallery(int index) async {
    var imageFilePickedFromGallery = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (imageFilePickedFromGallery != null) {
      MemoryImage imageFileInBytesForm =
          MemoryImage((File(imageFilePickedFromGallery.path)).readAsBytesSync());

      if (index < 0) {
        _imagesList!.add(imageFileInBytesForm);
      } else {
        _imagesList![index] = imageFileInBytesForm;
      }

      setState(() {});
    }
  }

  initializeValues() {
    if (widget.posting == null) {
      _nameTextEditingController = TextEditingController(text: "");
      _capacityTextEditingController = TextEditingController(text: "");
      _priceTextEditingController = TextEditingController(text: "");
      _descriptionTextEditingController = TextEditingController(text: "");
      _addressTextEditingController = TextEditingController(text: "");
      _addressTextEditingController = TextEditingController(text: "");
      categorySelected = category.first;
      citySelected = AppConstants().cities.first;

      _imagesList = [];
    } else {
      _nameTextEditingController = TextEditingController(text: widget.posting!.name);
      _capacityTextEditingController =
          TextEditingController(text: widget.posting!.capacity.toString());
      _priceTextEditingController = TextEditingController(text: widget.posting!.price.toString());
      _descriptionTextEditingController = TextEditingController(text: widget.posting!.description);
      _addressTextEditingController = TextEditingController(text: widget.posting!.address);
      _amenitiesTextEditingController =
          TextEditingController(text: widget.posting!.getAmenititesString());
      _imagesList = widget.posting!.displayImages;
      categorySelected = widget.posting!.type!;
      citySelected = widget.posting!.city!;
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    initializeValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 140, 219, 188),
        title: const Text(
          "Mekan Ekle",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) {
                return;
              }

              if (categorySelected == "") {
                return;
              }

              if (citySelected == "") {
                return;
              }

              if (_imagesList!.isEmpty) {
                return;
              }

              postingModel.name = _nameTextEditingController.text;
              postingModel.capacity = int.parse(_capacityTextEditingController.text);
              postingModel.price = int.parse(_priceTextEditingController.text);
              postingModel.description = _descriptionTextEditingController.text;
              postingModel.address = _addressTextEditingController.text;
              postingModel.city = citySelected;
              postingModel.amenities = _amenitiesTextEditingController.text.split(",");
              postingModel.type = categorySelected;
              postingModel.displayImages = _imagesList;

              postingModel.host = AppConstants.currentUser.createUserFromContact();

              postingModel.setImagesNames();

              if (widget.posting == null) {
                postingModel.rating = 3.5;
                postingModel.bookings = [];
                postingModel.reviews = [];

                await postingViewModel.addListingInfoToFirestore();

                await postingViewModel.addImagesToFirebaseStorage();

                Get.snackbar("Yeni Listeleme", "Mekanınız başarıyla oluşturuldu.");
              } else {
                postingModel.rating = widget.posting!.rating;
                postingModel.bookings = widget.posting!.bookings;
                postingModel.reviews = widget.posting!.reviews;
                postingModel.id = widget.posting!.id;

                for (int i = 0; i < AppConstants.currentUser.myPostings!.length; i++) {
                  if (AppConstants.currentUser.myPostings![i].id == postingModel.id) {
                    AppConstants.currentUser.myPostings![i] = postingModel;
                    break;
                  }
                }

                await postingViewModel.updatePostingInfoToFirestore();

                Get.snackbar("Listelemeyi Güncelle", "Listelemeniz başarıyla güncellenmiştir.");
              }

              postingModel = PostingModel();

              Get.to(() => const HostHomeScreen());
            },
            icon: const Icon(
              Icons.upload,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(26, 26, 26, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0),
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: "Mekan ismi"),
                          style: const TextStyle(
                            fontSize: 25.0,
                          ),
                          controller: _nameTextEditingController,
                          validator: (textInput) {
                            if (textInput!.isEmpty) {
                              return "Lütfen mekanınızın ismini giriniz";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 28.0),
                        child: DropdownButton(
                          items: category.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (valueItem) {
                            setState(() {
                              categorySelected = valueItem.toString();
                            });
                          },
                          isExpanded: true,
                          value: categorySelected,
                          hint: const Text(
                            "Mekan tipi",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 28.0),
                        child: DropdownButton(
                          items: AppConstants().cities.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (valueItem) {
                            setState(() {
                              citySelected = valueItem.toString();
                            });
                          },
                          isExpanded: true,
                          value: citySelected,
                          hint: const Text(
                            "Şehir",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 21.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 30),
                                child: TextFormField(
                                  decoration: const InputDecoration(labelText: "Kapasite"),
                                  style: const TextStyle(
                                    fontSize: 25.0,
                                  ),
                                  keyboardType: TextInputType.number,
                                  controller: _capacityTextEditingController,
                                  validator: (text) {
                                    if (text!.isEmpty) {
                                      return "Lütfen kişi sayısını belirtin.";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 10.0, bottom: 10.0),
                              child: Text(
                                "Kişi",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 21.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 30),
                                child: TextFormField(
                                  decoration:
                                      const InputDecoration(labelText: "Kişi Başı Min Fiyat"),
                                  style: const TextStyle(
                                    fontSize: 25.0,
                                  ),
                                  keyboardType: TextInputType.number,
                                  controller: _priceTextEditingController,
                                  validator: (text) {
                                    if (text!.isEmpty) {
                                      return "Lütfen fiyatı giriniz.";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 21.0),
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: "Açıklama"),
                          style: const TextStyle(
                            fontSize: 25.0,
                          ),
                          controller: _descriptionTextEditingController,
                          maxLines: 3,
                          minLines: 1,
                          validator: (text) {
                            if (text!.isEmpty) {
                              return "Lütfen açıklama kısmını boş bırakmayınız.";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: "Adres"),
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 25.0,
                          ),
                          controller: _addressTextEditingController,
                          validator: (text) {
                            if (text!.isEmpty) {
                              return "Lütfen geçerli bir adres giriniz.";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 21.0),
                        child: TextFormField(
                          decoration:
                              const InputDecoration(labelText: "Özellikler (virgülle ayırın)"),
                          style: const TextStyle(
                            fontSize: 25.0,
                          ),
                          controller: _amenitiesTextEditingController,
                          validator: (text) {
                            if (text!.isEmpty) {
                              return "Lütfen Özellik giriniz (virgülle ayırın)";
                            }
                            return null;
                          },
                          maxLines: 3,
                          minLines: 1,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text(
                          'Fotoğraflar',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 25.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: _imagesList!.length + 1,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 25,
                            crossAxisSpacing: 25,
                            childAspectRatio: 3 / 2,
                          ),
                          itemBuilder: (context, index) {
                            if (index == _imagesList!.length) {
                              return IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  _selectImageFromGallery(-1);
                                },
                              );
                            }
                            return MaterialButton(
                              onPressed: () {},
                              child: Image(
                                image: _imagesList![index],
                                fit: BoxFit.fill,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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
