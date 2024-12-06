import 'dart:ffi';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/ambassdor/matching.dart';
import 'package:datingapp/ambassdor/matchingfilter.dart';
import 'package:datingapp/ambassdor/olduser/userprofile.dart';
import 'package:datingapp/ambassdor/viewpage.dart';
import 'package:datingapp/userchatpage.dart';
import 'package:datingapp/viewpage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class blockeduserss extends StatefulWidget {
  String ID;
  String gender;
  
  String profileimage;
  String name;
  String location;
  double distance;
  double startLatitude;
  double startLongitude;
  double endLatitude;
  double endLongitude;
  List filteredUsers;
  int age;
  final String onlinecheck;
  final Color statecolour;
String description;

  String height;
  List<dynamic> iconss;
  List<dynamic> labels;
    List<dynamic> languages;

  List<dynamic> imagecollection;
      String education;

  String useremail;


  blockeduserss(
      {required this.ID,
      required this.filteredUsers,
      required this.education,
      required this.gender,
      required this.onlinecheck,
      required this.languages,
      required this.statecolour,
      required this.profileimage,
      required this.name,
      required this.location,
      required this.description,
      required this.distance,
      required this.startLongitude,
      required this.startLatitude,
      required this.endLongitude,
      required this.endLatitude,
      required this.age,
      required this.height,
      required this.iconss,
      required this.labels,
      required this.imagecollection,
      required this.useremail,

      super.key});

  @override
  State<blockeduserss> createState() => _blockeduserssState();
}

class _blockeduserssState extends State<blockeduserss> {
  bool fav = false;
  int _selectedgender = 2;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return A_viewpage(
                          image: widget.profileimage,
                          name: widget.name,
                          address: widget.location,
                          distance: calculateDistance(
                                  widget.startLatitude,
                                  widget.startLongitude,
                                  widget.endLatitude,
                                  widget.endLongitude)
                              .toInt(),
                          age: widget.age,
                          height: widget.height,
                          labels: widget.labels,
                          iconss: widget.iconss,
                          imagecollection: widget.imagecollection,
                          fav: fav,
                          ID: widget.ID,
                          useremail: widget.useremail,
                          onlinecheck: widget.onlinecheck,
                              statecolour: widget.statecolour, languaes: widget.languages, education: widget.education, description: widget.description,
                        );
                      
                      },
                    )
                    
                    );
            },
            child: Container(
              color: Colors.transparent,
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                GestureDetector(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    // builder: (context) {
                    // return
                    //
                    //  A_viewpage(
                    // image: widget.profileimage,
                    // name: widget.name,
                    // address: widget.location,
                    // distance: calculateDistance(
                    // widget.startLatitude,
                    // widget.startLongitude,
                    // widget.endLatitude,
                    // widget.endLongitude)
                    // .toInt(),
                    // age: widget.age,
                    // height: widget.height,
                    // labels: widget.labels,
                    // iconss: widget.iconss,
                    // imagecollection: widget.imagecollection,
                    // fav: fav,
                    // ID: widget.ID,
                    // useremail: widget.useremail,
                    // onlinecheck: widget.onlinecheck,
                    // statecolour: widget.statecolour,
                    // );
                    // },
                    // ));
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: height / 10,
                        width: width / 5,
                        color: Colors.transparent,
                        child: Stack(
                          children: [
                            Container(
                              height: height / 15,
                              width: width / 6,
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xff7905F5)),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(widget.profileimage),
                                      fit: BoxFit.cover)),
                            ),
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: width/40,),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: const Color(0xff565656),
                            fontFamily: "defaultfontsbold",
                            fontWeight: FontWeight.w900,
                            fontSize: 16),
                      maxLines: 1, // Display only one line
                       overflow: TextOverflow.ellipsis, // Truncate and show '...'
                       
                      ),
                      Text(
                        widget.location,
                        style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontFamily: "defaultfonts",
                            fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
          Padding(
            padding:  EdgeInsets.only(top: height/150,bottom: height/150),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: width / 40,
                ),
ElevatedButton(
  style: ElevatedButton.styleFrom(
    shape:RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10)
    ),
    backgroundColor: Color(0xff7905F5)
  ),
  onPressed:() {
  unblockUser(widget.ID);
}, child: Text("Unblock",style: TextStyle(color: Colors.white,fontSize: 15)))

              ],
            ),
          )
        ],
      ),
    );
  }

  double calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    double distanceInMeters = Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );

    // Convert meters to kilometers
    double distanceInKilometers = distanceInMeters / 1000;

    return distanceInKilometers;
  }
     void checkInterestMatch() async {
    try {
      // Get logged-in user's email

      // Fetch interests from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.useremail)
          .get();
      final targetDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.ID)
          .get();

      // Extract interests
      List<dynamic> userInterests = userDoc.data()?['Interest'] ?? [];
      List<dynamic> targetInterests = targetDoc.data()?['Interest'] ?? [];

      // Calculate match percentage
      if (userInterests.isNotEmpty && targetInterests.isNotEmpty) {
        final commonInterests = userInterests
            .where((interest) => targetInterests.contains(interest))
            .toList();
        final matchPercentage =
            (commonInterests.length / targetInterests.length) * 100;

        // Navigate or show message
        if (matchPercentage >= 60) {
      
            Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return ChatPage(
            chatPartnerEmail: widget.ID,
            chatPartnername: widget.name,
            chatPartnerimage: widget.profileimage,
            onlinecheck: widget.onlinecheck,
            statecolour: widget.statecolour,
            who: 'user',
          );
        },
      ));
      
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Your interests match ${matchPercentage.toStringAsFixed(1)}% with ${widget.ID}. Please try again later!'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No interests found to compare.')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to check match. Try again.')),
      );
    }
  }
Future<void> unblockUser(String blockerEmail) async {
  try {
    // Access the document using the blockerEmail as the document ID
    final documentRef = FirebaseFirestore.instance
        .collection('Blocked USers')
        .doc(blockerEmail);

    // Fetch the document
    final docSnapshot = await documentRef.get();

    if (docSnapshot.exists) {
      // Extract the 'This Id blocked Users' field as a list of strings
      List<dynamic> blockedUsersDynamic = docSnapshot.data()?['This Id blocked Users'] ?? [];
      List<String> blockedUsers = List<String>.from(blockedUsersDynamic);

      // Check if the current user email exists in the blocked users list
      if (blockedUsers.contains(widget.useremail)) {
        // Remove the logged user from the blocked users list
        blockedUsers.remove(widget.useremail);

        // Update the Firestore document
        await documentRef.update({
          'This Id blocked Users': blockedUsers,
        });

        // Update the UI state
        setState(() {
          widget.filteredUsers.removeWhere((user) => user['email'] == widget.useremail);
        });

        print('Unblocked user: ${widget.useremail} from blocker: $blockerEmail');
      } else {
        print('User not found in the blocked list.');
      }
    } else {
      print('No document found for blocker: $blockerEmail');
    }
  } catch (e) {
    print('Error unblocking user: $e');
  }
}




}
