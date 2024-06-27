import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_places/model/posting_model.dart';
import 'package:flutter_places/view/view_posting_screen.dart';
import 'package:flutter_places/view/widgets/filter_screen.dart';
import 'package:flutter_places/view/widgets/posting_grid_tile_ui.dart';
import 'package:get/get.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  TextEditingController controllerSearch = TextEditingController();
  Stream<QuerySnapshot> stream = FirebaseFirestore.instance.collection('postings').snapshots();

  String selectedCity = 'All';
  String selectedType = 'All';
  int selectedMinCapacity = 0;
  int selectedMaxCapacity = 1000;
  int selectedMinPrice = 250;
  int selectedMaxPrice = 2000;

  void searchByField() {
    String searchQuery = controllerSearch.text.trim();

    if (searchQuery.isNotEmpty) {
      setState(() {
        stream = FirebaseFirestore.instance
            .collection('postings')
            .where('name', isGreaterThanOrEqualTo: searchQuery)
            .where('name', isLessThanOrEqualTo: searchQuery + '\uf8ff')
            .snapshots();
      });
    } else {
      setState(() {
        stream = FirebaseFirestore.instance.collection('postings').snapshots();
      });
    }
  }

  void applyFilter(
      String city, String type, int minCapacity, int maxCapacity, int minPrice, int maxPrice) {
    setState(() {
      selectedCity = city;
      selectedType = type;
      selectedMinCapacity = minCapacity;
      selectedMaxCapacity = maxCapacity;
      selectedMinPrice = minPrice;
      selectedMaxPrice = maxPrice;

      Query query = FirebaseFirestore.instance.collection('postings');

      if (city != 'All') {
        query = query.where('city', isEqualTo: city);
      }
      if (type != 'All') {
        query = query.where('type', isEqualTo: type);
      }

      query = query
          .where('capacity', isGreaterThanOrEqualTo: minCapacity)
          .where('capacity', isLessThanOrEqualTo: maxCapacity);

      stream = query.snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 15, 20, 0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        contentPadding: EdgeInsets.all(5.0),
                      ),
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                      controller: controllerSearch,
                      onEditingComplete: searchByField,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FilterScreen(
                            selectedCity: selectedCity,
                            selectedType: selectedType,
                            selectedMinCapacity: selectedMinCapacity,
                            selectedMaxCapacity: selectedMaxCapacity,
                            selectedMinPrice: selectedMinPrice,
                            selectedMaxPrice: selectedMaxPrice,
                            onApplyFilter: applyFilter,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: stream,
              builder: (context, dataSnapshots) {
                if (dataSnapshots.hasData) {
                  var docs = dataSnapshots.data?.docs ?? [];
                  return ListView.builder(
                    key: UniqueKey(), // Anahtar ekleyin
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot snapshot = docs[index];

                      PostingModel cPosting = PostingModel(id: snapshot.id);
                      cPosting.getPostingInfoFromSnapshot(snapshot);

                      return InkResponse(
                        onTap: () {
                          Get.to(() => ViewPostingScreen(
                                posting: cPosting,
                              ));
                        },
                        enableFeedback: true,
                        child: PostingGridTileUI(
                          key: ValueKey(cPosting.id),
                          posting: cPosting,
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
