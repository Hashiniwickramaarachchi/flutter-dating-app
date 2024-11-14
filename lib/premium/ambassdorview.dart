import 'dart:ffi';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/ambassdor/A_profile.dart';
import 'package:datingapp/ambassdor/matching.dart';
import 'package:datingapp/ambassdor/matchingfilter.dart';
import 'package:datingapp/ambassdor/olduser/ambassdorshowchat.dart';
import 'package:datingapp/ambassdor/olduser/userprofile.dart';
import 'package:datingapp/ambassdor/viewpage.dart';
import 'package:datingapp/userchatpage.dart';
import 'package:datingapp/viewpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';

class ambbasdorview extends StatefulWidget {
  String ID;
  double averageRating;
  String gender;
  String profileimage;
  String name;
  String location;
  double startLatitude;
  double startLongitude;
  int age;
  final String onlinecheck;
  final Color statecolour;

  String height;
  List<dynamic> iconss;
  List<dynamic> labels;
  List<dynamic> imagecollection;
  String useremail;

  ambbasdorview(
      {required this.ID,
      required this.averageRating,
      required this.gender,
      required this.onlinecheck,
      required this.statecolour,
      required this.profileimage,
      required this.name,
      required this.location,
      required this.startLongitude,
      required this.startLatitude,
      required this.age,
      required this.height,
      required this.iconss,
      required this.labels,
      required this.imagecollection,
      required this.useremail,
      super.key});

  @override
  State<ambbasdorview> createState() => _ambbasdorviewState();
}

class _ambbasdorviewState extends State<ambbasdorview> {
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
                        return ambassdorshowchat(useremail: widget.ID);
                      },
                    ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                            image: NetworkImage(widget.profileimage),
                            fit: BoxFit.cover)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Color(0xff7905F5),
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: width / 15,
                                right: width / 15,
                                top: height / 80,
                                bottom: height / 80),
                            child: RatingBarIndicator(
                              rating: widget.averageRating,
                              itemBuilder: (context, index) => Icon(
                                index < widget.averageRating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: index < widget.averageRating
                                    ? Colors.amber
                                    : Colors.white,
                              ),
                              itemCount: 5,
                              itemSize: height / 36,
                              unratedColor: Colors.white,
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
                            color: Colors.white
                                .withOpacity(0.2), // Optional for color overlay
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                              child: Container(
                                child: Container(
                                  color:
                                      const Color.fromARGB(255, 124, 124, 124)
                                          .withOpacity(0.2),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: width,
                                        child: Expanded(
                                          child: Text(
                                            widget.name,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontFamily: "defaultfontsbold",
                                                fontWeight: FontWeight.w900,
                                                fontSize: 24),
                                            softWrap: true,
                                            overflow: TextOverflow
                                                .visible, // You can also use TextOverflow.ellipsis if you want to truncate
                                          ),
                                        ),
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
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return ambassdorshowchat(
                                      useremail: widget.ID);
                                }));
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
                    // ElevatedButton(
                    // style: ElevatedButton.styleFrom(
                    // shape: RoundedRectangleBorder(
                    // borderRadius: BorderRadius.circular(10)),
                    // backgroundColor: Color(0xff7905F5),
                    // ),
                    // onPressed: () {
                    // if (widget.gender == "Male") {
                    // _selectedgender = 0;
                    // } else if (widget.gender == "Female") {
                    // _selectedgender = 1;
                    // } else if (widget.gender == "Other") {
                    // _selectedgender = 3;
                    // }
                    // Navigator.of(context).push(MaterialPageRoute(
                    // builder: (context) {
                    // return matchingfilter(
                    // selectedGender: _selectedgender,
                    // selectedInterests:
                    // widget.labels.cast<String>().toSet(),
                    // ageRange: RangeValues(
                    // double.tryParse(widget.age.toString()) ??
                    // 0.0,
                    // double.tryParse(widget.age.toString()) ??
                    // 0.0),
                    // distanceRange: RangeValues(0, 100),
                    // userLatitude: widget.startLatitude,
                    // userLongitude: widget.startLongitude,
                    // useremail: widget.ID, Gender:widget.gender,
                    // );
                    // },
                    // ));
                    // },
                    // child: Text(
                    // "Find Match",
                    // style: TextStyle(
                    // color: Colors.white,
                    // fontFamily: "defaultfonts",
                    // fontWeight: FontWeight.w500,
                    // fontSize: height / 45),
                    // )),
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
