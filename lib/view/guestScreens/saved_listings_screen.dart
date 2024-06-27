import 'package:flutter/material.dart';
import 'package:flutter_places/model/app_constants.dart';
import 'package:flutter_places/model/posting_model.dart';
import 'package:flutter_places/view/view_posting_screen.dart';
import 'package:flutter_places/view/widgets/posting_grid_tile_ui.dart';
import 'package:get/get.dart';

class SavedListingsScreen extends StatefulWidget {
  const SavedListingsScreen({Key? key}) : super(key: key);

  @override
  State<SavedListingsScreen> createState() => _SavedListingsScreenState();
}

class _SavedListingsScreenState extends State<SavedListingsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Kullanıcı verilerini yükleyin
    AppConstants.currentUser.loadUserInfoFromFirestore().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
            child: ListView.builder(
              itemCount: AppConstants.currentUser.savedPostings!.length,
              itemBuilder: (context, index) {
                PostingModel currentPosting = AppConstants.currentUser.savedPostings![index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(ViewPostingScreen(
                        posting: currentPosting,
                      ));
                    },
                    child: Stack(
                      children: [
                        PostingGridTileUI(posting: currentPosting),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                AppConstants.currentUser.removeSavedPosting(currentPosting);
                              });
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.clear,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }
}
