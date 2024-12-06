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

class premiumperson extends StatefulWidget {
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

  premiumperson(
      {required this.ID,
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
  State<premiumperson> createState() => _premiumpersonState();
}

class _premiumpersonState extends State<premiumperson> {
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
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                            border: Border.all(color: Colors.purple),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(widget.profileimage),
                                  fit: BoxFit.cover)),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            height: height / 30,
                            width: width / 20,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage(
                                "assetss/Vector.png",
                              ),
                            )),
                          ),
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
          Padding(
            padding:  EdgeInsets.only(top: height/150,bottom: height/150),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff7905F5),
                  ),
                  child: IconButton(
                      onPressed: () async {
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
                        ));
                      },
                      icon: Icon(
                        Icons.person_2_outlined,
                        color: Colors.white,
                        size: height / 35,
                      )),
                ),
                SizedBox(
                  width: width / 40,
                ),
                GestureDetector(
                  onTap: () {

return checkInterestMatch();

                    // Navigator.of(context).push(MaterialPageRoute(
                      // builder: (context) {
                        // return ChatPage(
                          // chatPartnerEmail: widget.ID,
                          // chatPartnername: widget.name,
                          // chatPartnerimage: widget.profileimage,
                          // onlinecheck: widget.onlinecheck,
                          // statecolour: widget.statecolour,
                          // who: 'user',
                        // );
                      // },
                    // ));
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff7905F5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ClipRRect(
                          child: Image.asset(
                            "images/Vector.png",
                            height: height / 35,
                          ),
                        ),
                      )),
                ),
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
}
