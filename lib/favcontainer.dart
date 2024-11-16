import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/viewpage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class favcontainer extends StatefulWidget {
  String ID;
  String profileimage;
  String name;
  String location;
  double distance;
  double startLatitude;
  double startLongitude;
  double endLatitude;
  double endLongitude;
  String education;
  String description;
  final String onlinecheck;
  final Color statecolour;
  List<dynamic> languages;

  int age;
  String height;
  List<dynamic> iconss;
  List<dynamic> labels;
  List<dynamic> imagecollection;
  String useremail;

  favcontainer({
    required this.education,
    required this.languages,
    required this.ID,
    required this.description,
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
    super.key,
  });

  @override
  State<favcontainer> createState() => _favcontainerState();
}

class _favcontainerState extends State<favcontainer> {
  bool fav = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 5,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return viewpage(
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
                    fav: true,
                    ID: widget.ID,
                    useremail: widget.useremail,
                    onlinecheck: widget.onlinecheck,
                    statecolour: widget.statecolour,
                    languages: widget.languages,
                    education: widget.education, description: widget.description,
                  );
                },
              ));
            },
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(widget.profileimage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: height / 60,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: height / 25,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              color: Color.fromARGB(67, 0, 0, 0),
                              borderRadius: BorderRadius.circular(height / 10),
                            ),
                            child: Center(
                              child: Text(
                                "   ${calculateDistance(widget.startLatitude, widget.startLongitude, widget.endLatitude, widget.endLongitude).toInt()}Km far away   ",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontFamily: "defaultfonts",
                                    fontSize: 10),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  fav = !fav; // Toggle the state
                                });
                                // Update Firestore collection
                                if (fav) {
                                  FirebaseFirestore.instance
                                      .collection('Favourite')
                                      .doc(widget.useremail)
                                      .collection("fav1")
                                      .doc(widget.ID)
                                      .delete();
                                }
                              },
                              icon: Icon(
                                fav
                                    ? Icons.favorite_border_outlined
                                    : Icons.favorite_rounded,
                                color: Color(0xff7905F5),
                              ))
                        ],
                      ),
                    ),
                    Container(
                      height: height / 8,
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        color: const Color.fromARGB(64, 158, 158, 158)
                            .withOpacity(0.3),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                          child: Container(
                            color: const Color.fromARGB(123, 0, 0, 0).withOpacity(0.2),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  
                                  widget.name.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      fontFamily: "defaultfontsbold",
                                      fontSize: 20),
                                             maxLines: 1, // Limit to one line
   overflow: TextOverflow.ellipsis, // Adds "..." if the text is too long
                                ),
                                Text(
                                  widget.location,
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      fontFamily: "defaultfontsbold",
                                      fontSize: 15),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
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
