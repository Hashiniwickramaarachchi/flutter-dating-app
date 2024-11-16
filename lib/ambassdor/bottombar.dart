// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:datingapp/Usermanegement/profile.dart';
// import 'package:datingapp/allusermap.dart';
// import 'package:datingapp/ambassdor/A_profile.dart';
// import 'package:datingapp/ambassdor/chatpage.dart';
// import 'package:datingapp/ambassdor/newuser/add.dart';
// import 'package:datingapp/ambassdor/newuser/dashbordnew.dart';
// import 'package:datingapp/ambassdor/newuser/homepage.dart';
// import 'package:datingapp/ambassdor/olduser/dashbortlogged.dart';
// import 'package:datingapp/ambassdor/olduser/showresultsignin.dart';
// import 'package:datingapp/chatpage.dart';
// import 'package:datingapp/fav.dart';
// import 'package:datingapp/homepage.dart';
// import 'package:datingapp/onlinusers.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';

// class A_BottomNavBar extends StatefulWidget {
//   String check;
//   int selectedIndex2;

//   A_BottomNavBar(
//       {required this.check, required this.selectedIndex2, super.key});

//   @override
//   _A_BottomNavBarState createState() => _A_BottomNavBarState();
// }

// class _A_BottomNavBarState extends State<A_BottomNavBar> {
//   void _onItemTapped(int index,String email) async{
//        Position position =
//        await Geolocator.getCurrentPosition(
//            desiredAccuracy:
//                LocationAccuracy.high);
//    double latitude = position.latitude;
//    double longitude = position.longitude;
//     setState(()  {
//       widget.selectedIndex2 = index;

//       if (index==0) {

//            if (widget.check == 'already') {
//              Navigator.of(context)
//                  .pushReplacement(MaterialPageRoute(
//                builder: (context) {
//                  return showsigninresult(
//                      userLatitude: latitude,
//                      userLongitude: longitude,
//                      useremail:
//                          email);
//                },
//              ));
//            } else {
//              Navigator.of(context)
//                  .pushReplacement(MaterialPageRoute(
//                builder: (context) {
//                  return A_homepage();
//                },
//              ));
//            }

//       }
//       else if(index==1){
//                         if (widget.check == 'already') {
//                           Navigator.of(context)
//                               .pushReplacement(MaterialPageRoute(
//                             builder: (context) {
//                               return DashboardScreen();
//                             },
//                           ));
//                         } else {
//                           Navigator.of(context)
//                               .pushReplacement(MaterialPageRoute(
//                             builder: (context) {
//                               return A_dashbordnew();
//                             },
//                           ));
//                         }

//       } else if(index==2){
//           Navigator.of(context)
//           .pushReplacement(MaterialPageRoute(
//         builder: (context) {
//           return addpage();
//         },
//       ));
    
    
//  } else if(index==3){
//     Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context) {
//    return A_Chatscreen();
//  },));
//  } else if(index==4){
//               Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context) {
//               return A_profile();
//             },));
//  }
//     });
//   }



//   @override
//   Widget build(BuildContext context) {
//     final curentuser = FirebaseAuth.instance.currentUser;
//     if (curentuser == null) {
//       return Center(child: Text('No user is logged in.'));
//     }
//     return Container(
//         color: Colors.transparent,
//         child: StreamBuilder<DocumentSnapshot>(
//             stream: FirebaseFirestore.instance
//                 .collection("Ambassdor")
//                 .doc(curentuser.email)
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 final userdataperson =
//                     snapshot.data!.data() as Map<String, dynamic>;
//                 return Stack(
//                   alignment: AlignmentDirectional.topStart,
//                   children: [
//                     Container(
//                       height: 70,
//                       decoration: BoxDecoration(
//                           color: Colors.black, shape: BoxShape.circle),
//                     ),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Container(
//                           height: 20,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             color: Colors.transparent,
//                           ),
//                         ),
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.black,
//                             borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(30),
//                                 topRight: Radius.circular(30),
//                                 bottomLeft: Radius.circular(30),
//                                 bottomRight: Radius.circular(30)),
//                             boxShadow: [
//                               BoxShadow(
//                                   color: Colors.black26,
//                                   spreadRadius: 0,
//                                   blurRadius: 10),
//                             ],
//                           ),
//                           child: BottomNavigationBar(
//                             backgroundColor: Colors.transparent,
//                             type: BottomNavigationBarType.fixed,
//                             showSelectedLabels: false,
//                             showUnselectedLabels: false,
//                             selectedItemColor:
//                                 Color(0xff7905F5), // Purple color
//                             unselectedItemColor: Colors.white,
//                             elevation: 0,
//                             currentIndex: widget.selectedIndex2,
//                             onTap:(value) {
//                               _onItemTapped(value, userdataperson['email']);
//                             },
//                             items: [
//                               BottomNavigationBarItem(
//                                 icon: Icon(Icons.home),
//                                 label: 'Home',
//                               ),
//                               BottomNavigationBarItem(
//                                 icon: Icon(Icons.bar_chart_sharp),
//                                 label: 'Explore',
//                               ),
//                               BottomNavigationBarItem(
//                                 icon: 
//                                Container(
//                                     decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: widget.selectedIndex2 == 2
//                                             ? Color(0xff7905F5)
//                                             : Colors.white),
//                                     child: Icon(Icons.add,
//                                         color: widget.selectedIndex2 == 2
//                                             ? Colors.white
//                                             : Color(0xff7905F5))),
//                                 label: 'Add',
//                               ),
//                               BottomNavigationBarItem(
//                                 icon: Icon(Icons.chat_bubble_outline),
//                                 label: 'Messages',
//                               ),
//                               BottomNavigationBarItem(
//                                 icon: Icon(Icons.person_outline),
//                                 label: 'Profile',
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 );
//               } else if (snapshot.hasError) {
//                 return Center(
//                   child: Text("Error: ${snapshot.error}"),
//                 );
//               } else {
//                 return CircularProgressIndicator();
//               }
//             }));
//   }
// }
