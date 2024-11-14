// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:datingapp/Usermanegement/profile.dart';
// import 'package:datingapp/allusermap.dart';
// import 'package:datingapp/chatpage.dart';
// import 'package:datingapp/fav.dart';
// import 'package:datingapp/homepage.dart';

// class MainScreen extends StatefulWidget {
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;
//   final PageController _pageController = PageController();

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;

//       if (index == 0) { // Check if the Explore icon is selected
//         // Add a slight delay before navigating to allusermap
//         Future.delayed(Duration(milliseconds: 200), () {
//           _pageController.jumpToPage(index);
//         });
//       } else {
//         _pageController.jumpToPage(index);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final curentuser = FirebaseAuth.instance.currentUser;
//     if (curentuser == null) {
//       return Center(child: Text('No user is logged in.'));
//     }

//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection("users")
//           .doc(curentuser.email)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           final userdataperson = snapshot.data!.data() as Map<String, dynamic>;

//           return Scaffold(
//             body: Stack(
//               children: [
//                 // PageView to manage different pages
//                 PageView(
//                   controller: _pageController,
//                   onPageChanged: (index) {
//                     setState(() {
//                       _selectedIndex = index;
//                     });
//                   },
//                   children: [
//                     homepage(),
//                     allusermap(
//                         userLatitude: userdataperson['X'],
//                         userLongitude: userdataperson["Y"],
//                         useremail: userdataperson['email']),
//                     fav(),
//                     Chatscreen(),
//                     profile(),
//                   ],
//                 ),
//                 // Positioned Bottom Navigation Bar
//                 Positioned(
//                   left: 30,
//                   right: 30,
//                   bottom: 30,
//                   child: BottomNavBar(
//                     selectedIndex2: _selectedIndex,
//                     onItemTapped: _onItemTapped,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         } else if (snapshot.hasError) {
//           return Center(
//             child: Text("Error: ${snapshot.error}"),
//           );
//         } else {
//           return CircularProgressIndicator();
//         }
//       },
//     );
//   }
// }

// class BottomNavBar extends StatefulWidget {
//   final int selectedIndex2;
//   final Function(int index) onItemTapped;

//   BottomNavBar({
//     required this.selectedIndex2,
//     required this.onItemTapped,
//     super.key,
//   });

//   @override
//   _BottomNavBarState createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<BottomNavBar> {
//   @override
//   Widget build(BuildContext context) {
//     final curentuser = FirebaseAuth.instance.currentUser;
//     if (curentuser == null) {
//       return Center(child: Text('No user is logged in.'));
//     }

//     return Container(
//       color: Colors.transparent,
//       child: StreamBuilder<DocumentSnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection("users")
//             .doc(curentuser.email)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return Container(
//               decoration: BoxDecoration(
//                 color: Colors.black,
//                 borderRadius: BorderRadius.circular(30),
//                 boxShadow: [
//                   BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 10),
//                 ],
//               ),
//               child: BottomNavigationBar(
//                 backgroundColor: Colors.transparent,
//                 type: BottomNavigationBarType.fixed,
//                 showSelectedLabels: false,
//                 showUnselectedLabels: false,
//                 selectedItemColor: Color(0xFF7B1FA2), // Purple color
//                 unselectedItemColor: Colors.white,
//                 elevation: 0,
//                 currentIndex: widget.selectedIndex2,
//                 onTap: widget.onItemTapped,
//                 items: [
//                   BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//                   BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
//                   BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorites'),
//                   BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Messages'),
//                   BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
//                 ],
//               ),
//             );
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else {
//             return CircularProgressIndicator();
//           }
//         },
//       ),
//     );
//   }
// }
