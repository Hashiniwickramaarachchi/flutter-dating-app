import 'dart:ffi';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/ambassdor/olduser/userprofile.dart';
import 'package:datingapp/ambassdor/viewpage.dart';
import 'package:datingapp/userchatpage.dart';
import 'package:datingapp/viewpage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class A_users extends StatefulWidget {
  String ID;
  String profileimage;
  String name;
  String location;
      String education;
String description;

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
    List<dynamic> languages;

  List<dynamic> labels;
  List<dynamic> imagecollection;
  String useremail;

  A_users(
      {required this.ID,
      required this.languages,
      required this.description,
      required this.education,
      required this.onlinecheck,
      required this.statecolour,
      required this.profileimage,
      required this.name,
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
  State<A_users> createState() => _A_usersState();
}

class _A_usersState extends State<A_users> {
  bool fav = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color.fromARGB(255, 245, 236, 255)),
      child: Padding(
        padding: EdgeInsets.only(
            left: width / 40,
            right: width / 40,
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
                          statecolour: widget.statecolour, languaes: widget.languages, education: widget.education, description: widget.description,
                        );
                      },
                    ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                            image: NetworkImage(widget.profileimage),
                            fit: BoxFit.cover)),
                  ),
                )),
            SizedBox(
              height: height / 70,
            ),
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff7905F5),
                      ),
                      child: Center(
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
                              size: height / 40,
                            )),
                      ),
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
                              who: 'ambassdor',
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
                            padding: const EdgeInsets.all(12.0),
                            child: ClipRRect(
                              child: Image.asset(
                                "images/Vector.png",
                                height: height / 50,
                              ),
                            ),
                          )),
                    )
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
