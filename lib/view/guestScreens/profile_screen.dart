import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_places/global.dart';
import 'package:flutter_places/model/app_constants.dart';
import 'package:flutter_places/view/guest_home_screen.dart';
import 'package:flutter_places/view/host_home_screen.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _hostingTitle = 'Mekan Sahibi Arayüzü';

  modifyHostingMode() async {
    if (AppConstants.currentUser.isHost!) {
      if (AppConstants.currentUser.isCurrentlyHosting!) {
        AppConstants.currentUser.isCurrentlyHosting = false;

        Get.to(const GuestHomeScreen());
      } else {
        AppConstants.currentUser.isCurrentlyHosting = true;

        Get.to(const HostHomeScreen());
      }
    } else {
      await userViewModel.becomeHost(FirebaseAuth.instance.currentUser!.uid);

      AppConstants.currentUser.isCurrentlyHosting = true;

      Get.to(const HostHomeScreen());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (AppConstants.currentUser.isHost!) {
      if (AppConstants.currentUser.isCurrentlyHosting!) {
        _hostingTitle = 'Misafir Arayüzü';
      } else {
        _hostingTitle = 'Mekan Sahibi arayüzü';
      }
    } else {
      _hostingTitle = 'Mekan sahibiyim';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 50, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Center(
                child: Column(
                  children: [
                    MaterialButton(
                      onPressed: () {},
                      child: CircleAvatar(
                        backgroundColor: const Color.fromARGB(255, 140, 219, 188),
                        radius: MediaQuery.of(context).size.width / 4.5,
                        child: CircleAvatar(
                          backgroundImage: AppConstants.currentUser.displayImage,
                          radius: MediaQuery.of(context).size.width / 4.6,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppConstants.currentUser.getFullNameOfUser(),
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        Text(
                          AppConstants.currentUser.email.toString(),
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(
                  height: 10,
                ),

                //Change Hosting btn
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color.fromARGB(255, 140, 219, 188),
                  ),
                  child: MaterialButton(
                    height: MediaQuery.of(context).size.height / 9.1,
                    onPressed: () {
                      modifyHostingMode();
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0.0),
                      leading: Text(
                        _hostingTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.5,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      trailing: const Icon(
                        size: 34,
                        Icons.hotel_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                //logout btn
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color.fromARGB(255, 140, 219, 188),
                  ),
                  child: MaterialButton(
                    height: MediaQuery.of(context).size.height / 9.1,
                    onPressed: () {
                      userViewModel.logout();
                    },
                    child: const ListTile(
                      contentPadding: EdgeInsets.all(0.0),
                      leading: Text(
                        "Çıkış Yap",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.5,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      trailing: Icon(
                        size: 34,
                        Icons.login_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
