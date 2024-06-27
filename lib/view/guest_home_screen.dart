import 'package:flutter/material.dart';
import 'package:flutter_places/view/guestScreens/explore_screen.dart';
import 'package:flutter_places/view/guestScreens/inbox_screen.dart';
import 'package:flutter_places/view/guestScreens/profile_screen.dart';
import 'package:flutter_places/view/guestScreens/saved_listings_screen.dart';

class GuestHomeScreen extends StatefulWidget {
  const GuestHomeScreen({super.key});

  @override
  State<GuestHomeScreen> createState() => _GuestHomeScreenState();
}

class _GuestHomeScreenState extends State<GuestHomeScreen> {
  int selectedIndex = 0;

  final List<String> screenTitles = [
    'Ana Sayfa',
    'Favoriler',
    'Mesajlar',
    'Profil',
  ];

  final List<Widget> screens = [
    ExploreScreen(),
    SavedListingsScreen(),
    InboxScreen(),
    ProfileScreen(),
  ];

  BottomNavigationBarItem customNavigationBarItem(int index, IconData iconData, String title) {
    return BottomNavigationBarItem(
      icon: Icon(
        iconData,
        color: Colors.black,
      ),
      activeIcon: Icon(
        iconData,
        color: Color.fromARGB(255, 140, 219, 188),
      ),
      label: title,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 140, 219, 188),
        title: Text(
          screenTitles[selectedIndex],
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (i) {
          setState(() {
            selectedIndex = i;
          });
        },
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color.fromARGB(255, 140, 219, 188),
        unselectedItemColor: Colors.black,
        items: <BottomNavigationBarItem>[
          customNavigationBarItem(0, Icons.search, screenTitles[0]),
          customNavigationBarItem(1, Icons.favorite_border, screenTitles[1]),
          customNavigationBarItem(2, Icons.message, screenTitles[2]),
          customNavigationBarItem(3, Icons.person_outline, screenTitles[3]),
        ],
      ),
    );
  }
}
