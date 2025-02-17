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

class signinperson extends StatefulWidget {
  String ID;
  String gender;
  String profileimage;
  String name;
  String location;
  String education;

  double distance;
  double startLatitude;
  double startLongitude;
  double endLatitude;
  double endLongitude;
  int age;
  final String onlinecheck;
  final Color statecolour;

  String height;
  List<dynamic> iconss;
  List<dynamic> labels;
  List<dynamic> languages;
  String description;

  List<dynamic> imagecollection;
  String useremail;

  signinperson(
      {required this.ID,
      required this.education,
      required this.languages,
      required this.gender,
      required this.onlinecheck,
      required this.statecolour,
      required this.profileimage,
      required this.name,
      required this.description,
      required this.location,
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
  State<signinperson> createState() => _signinpersonState();
}

class _signinpersonState extends State<signinperson> {
  bool fav = false;
  int _selectedgender = 2;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color.fromARGB(255, 245, 236, 255)),
      child: Padding(
        padding: EdgeInsets.only(
            left: width / 30,
            right: width / 30,
            top: height / 60,
            bottom: height / 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 5,
                child: GestureDetector(
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
                          statecolour: widget.statecolour,
                          languaes: widget.languages,
                          education: widget.education,
                          description: widget.description,
                        );
                      },
                    ));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      child: Image.network(
                        widget.profileimage,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                'images/placeholder.png', // Path to your placeholder image
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: height / 60,
                                        left: width / 50,
                                        right: width / 3),
                                    child: Container(
                                      height: height / 16,
                                      width: width,
                                      decoration: BoxDecoration(
                                        color: Color(0xff7905F5),
                                        borderRadius:
                                            BorderRadius.circular(height / 10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "${calculateDistance(widget.startLatitude, widget.startLongitude, widget.endLatitude, widget.endLongitude).toInt()}Km far away",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: height / 8,
                                    width: width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15)),
                                      color: Colors.white.withOpacity(
                                          0.2), // Optional for color overlay
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 4.0, sigmaY: 4.0),
                                        child: Container(
                                          child: Container(
                                            color: const Color.fromARGB(
                                                    255, 124, 124, 124)
                                                .withOpacity(0.2),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  widget.name,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: const Color
                                                          .fromARGB(
                                                          255, 255, 255, 255),
                                                      fontFamily:
                                                          "defaultfontsbold",
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 24),
                                                  maxLines:
                                                      1, // Limit to one line
                                                  overflow: TextOverflow
                                                      .ellipsis, // Adds "..." if the text is too long
                                                ),
                                                Text(
                                                  widget.location,
                                                  style: TextStyle(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255),
                                                      fontFamily:
                                                          "defaultfonts",
                                                      fontSize: 20),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image_not_supported,
                            size: 80,
                            color: Color.fromARGB(213, 158, 158, 158),
                          );
                        },
                      ),
                    ),
                  ),
                )),
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                                      statecolour: widget.statecolour,
                                      languaes: widget.languages,
                                      education: widget.education,
                                      description: widget.description,
                                    );
                                  },
                                ));
                              },
                              icon: Icon(
                                Icons.person_2_outlined,
                                color: Colors.white,
                                size: height / 30,
                              )),
                        ),
                        SizedBox(
                          width: width / 40,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return ChatPage(
                                  chatPartnerEmail: widget.ID,
                                  chatPartnername: widget.name,
                                  chatPartnerimage: widget.profileimage,
                                  onlinecheck: widget.onlinecheck,
                                  statecolour: widget.statecolour,
                                  who: 'Ambassdor',
                                );
                              },
                            ));
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
                                    height: height / 30,
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Color(0xff7905F5),
                        ),
                        onPressed: () {
                          if (widget.gender == "Male") {
                            _selectedgender = 0;
                          } else if (widget.gender == "Female") {
                            _selectedgender = 1;
                          } else if (widget.gender == "Other") {
                            _selectedgender = 3;
                          }
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return matchingfilter(
                                selectedGender: _selectedgender,
                                selectedInterests:
                                    widget.labels.cast<String>().toSet(),
                                ageRange: RangeValues(
                                    double.tryParse(widget.age.toString()) ??
                                        0.0,
                                    double.tryParse(widget.age.toString()) ??
                                        0.0),
                                distanceRange: RangeValues(0, 100),
                                userLatitude: widget.startLatitude,
                                userLongitude: widget.startLongitude,
                                useremail: widget.ID,
                                Gender: widget.gender,
                              );
                            },
                          ));
                        },
                        child: Text(
                          "Find Match",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "defaultfonts",
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        )),
                  ],
                ))
          ],
        ),
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
}
