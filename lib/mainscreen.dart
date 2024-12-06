import 'package:datingapp/deactivepage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:datingapp/Usermanegement/profile.dart';
import 'package:datingapp/allusermap.dart';
import 'package:datingapp/chatpage.dart';
import 'package:datingapp/fav.dart';
import 'package:datingapp/homepage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:datingapp/Usermanegement/profile.dart';
import 'package:datingapp/allusermap.dart';
import 'package:datingapp/chatpage.dart';
import 'package:datingapp/fav.dart';
import 'package:datingapp/homepage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MainScreen extends StatefulWidget {
  final int initialIndex;

  MainScreen({this.initialIndex = 0}); // Default to Explore page

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _selectedIndex); // Proper initialization
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose controller to avoid memory leaks
    super.dispose();
  }

  Future<void> _onItemTapped(int index) async {

    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index); // Navigate to the selected page
    });
  }

  @override
  Widget build(BuildContext context) {
    final curentuser = FirebaseAuth.instance.currentUser;
    if (curentuser == null) {
      return Center(child: Text('No user is logged in.'));
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(curentuser.email)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
       final userdataperson =
           snapshot.data!.data() as Map<String, dynamic>?;
       if (userdataperson == null) {
         return Center(
           child: Text("User data not found."),
         );
       }



          return Scaffold(
            body: Stack(
              children: [
                PageView(
                    physics: NeverScrollableScrollPhysics(), // Disable swipe

                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  children: [
                    homepage(),
                    KeepAliveWidget(
                      child: allusermap(
                        userLatitude: userdataperson['X'],
                        userLongitude: userdataperson['Y'],
                        useremail: userdataperson['email'],
                      ),
                    ),
                    fav(),
                    Chatscreen(),
                    profile(),
                  ],
                ),
                Positioned(
                  left: 30,
                  right: 30,
                  bottom: MediaQuery.of(context).size.height/40,
                  child: BottomNavBar(
                    selectedIndex2: _selectedIndex,
                    onItemTapped: _onItemTapped,
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final int selectedIndex2;
  final Function(int index) onItemTapped;

  BottomNavBar({
    required this.selectedIndex2,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 10),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Color(0xFF7B1FA2), // Purple color
        unselectedItemColor: Colors.white,
        elevation: 0,
        currentIndex: selectedIndex2,
        onTap: onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), label: 'Favorites'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline), label: 'Messages'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
class KeepAliveWidget extends StatefulWidget {
  final Widget child;

  const KeepAliveWidget({Key? key, required this.child}) : super(key: key);

  @override
  _KeepAliveWidgetState createState() => _KeepAliveWidgetState();
}

class _KeepAliveWidgetState extends State<KeepAliveWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
