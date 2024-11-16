// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:datingapp/Usermanegement/profile.dart';
// import 'package:datingapp/allusermap.dart';
// import 'package:datingapp/chatpage.dart';
// import 'package:datingapp/fav.dart';
// import 'package:datingapp/homepage.dart';
// import 'package:datingapp/onlinusers.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class BottomNavBar extends StatefulWidget {
// int selectedIndex2;

//  BottomNavBar({
  
//   required this.selectedIndex2,
  
//   super.key});

//   @override
//   _BottomNavBarState createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<BottomNavBar> {

//   void _onItemTapped(int index,double x,double y ,String email) {
//     setState(() {
//       widget.selectedIndex2 = index;

//       if (index==0) {

//              Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context) {
//        return homepage();
//      },));
        
//       }
//       else if(index==1){
//                     Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context) {
//     return allusermap
//     (userLatitude: 
//     x, 
//     userLongitude: y, useremail:email,);
//   },));
//       } else if(index==2){
//               Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context) {
//         return fav();
//       },));
//  } else if(index==3){
//     Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context) {
//    return Chatscreen();
//  },));
//  } else if(index==4){
//               Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context) {
//               return profile();
//             },));
//  }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
// final curentuser = FirebaseAuth.instance.currentUser;
// if (curentuser == null) {
//   return Center(child: Text('No user is logged in.'));
// }
//     return Container(
//       color: Colors.transparent,
//       child: 
      
//       StreamBuilder<DocumentSnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection("users")
//             .doc(curentuser.email)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final userdataperson =
//                 snapshot.data!.data() as Map<String, dynamic>;
   
   
//           return Container(
            
//               decoration: BoxDecoration(
//                 color: Colors.black,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(30),
//                   topRight: Radius.circular(30),
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30)
//                 ),
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
//                 onTap:(value) {
//                   _onItemTapped(value,userdataperson['X'],userdataperson["Y"],userdataperson["email"]);
//                 } ,
//                 items: [
//                   BottomNavigationBarItem(
//                     icon:
//                      GestureDetector(
//                       onTap: () {
//                         Navigator.of(context).push(MaterialPageRoute(builder:(context) {
//                           return homepage();
//                         },));
//                       },
//                       child: Icon(Icons.home)),
//                     label: 'Home',
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.explore),
//                     label: 'Explore',
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.favorite_border),
//                     label: 'Favorites',
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.chat_bubble_outline),
//                     label: 'Messages',
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.person_outline),
//                     label: 'Profile',
//                   ),
//                 ],
//               ),
//             );
//         }    else if (snapshot.hasError) {
//      return Center(
//        child: Text("Error: ${snapshot.error}"),
//      );
//    } else {
//      return CircularProgressIndicator();
//    }
//   })
//     );
    
//   }
// }