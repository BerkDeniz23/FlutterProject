import 'package:flutter/material.dart';
import 'package:flutter_places/view/guestScreens/inbox_screen.dart';
import 'package:flutter_places/view/guestScreens/profile_screen.dart';
import 'package:flutter_places/view/hostScreens/my_postings_screen.dart';

class HostHomeScreen extends StatefulWidget {
  const HostHomeScreen({super.key});

  @override
  State<HostHomeScreen> createState() => _HostHomeScreenState();
}

class _HostHomeScreenState extends State<HostHomeScreen> {
  int selectedIndex = 0;

  final List<String> screenTitles = [
    'Mekanlarım',
    'Mesajlar',
    'Profil',
  ];

  final List<Widget> screens = [
    MyPostingsScreen(),
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
        leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            }),
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
        items: <BottomNavigationBarItem>[
          customNavigationBarItem(0, Icons.home, screenTitles[0]),
          customNavigationBarItem(1, Icons.message, screenTitles[1]),
          customNavigationBarItem(2, Icons.person_outline, screenTitles[2]),
        ],
      ),
    );
  }
}
