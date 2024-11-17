import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/ambassdor/A_Mainscree.dart';
import 'package:datingapp/ambassdor/addcouple.dart';
import 'package:datingapp/ambassdor/bottombar.dart';
import 'package:datingapp/ambassdor/filterpage.dart';
import 'package:datingapp/ambassdor/matching.dart';
import 'package:datingapp/ambassdor/onlinecheck.dart';
import 'package:datingapp/bootmnavbar.dart';
import 'package:datingapp/filterpage.dart';
import 'package:datingapp/onlinecheck.dart';
import 'package:datingapp/person.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class A_dashbordnew extends StatefulWidget {
  const A_dashbordnew({super.key});

  @override
  State<A_dashbordnew> createState() => _A_dashbordnewState();
}

class _A_dashbordnewState extends State<A_dashbordnew> {
  final A_OnlineStatusService _onlineStatusService = A_OnlineStatusService();
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  Map<String, dynamic> usersStatusDetails = {}; // Change from List to Map
  String lastSeenhistory = "Last seen: N/A";
  Color statecolour = Colors.white;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUsersStatus();
    // Call this when the app starts or the user logs in
    _onlineStatusService.updateUserStatus();
  }

  @override
  void dispose() {
    // Call this when the app is closed
    _onlineStatusService.setUserOffline();
    super.dispose();
  }

  Future<void> fetchUsersStatus() async {
    DatabaseReference usersStatusRef = _databaseRef.child('status');

    usersStatusRef.once().then((DatabaseEvent event) {
      Map<dynamic, dynamic>? usersStatus =
          event.snapshot.value as Map<dynamic, dynamic>?;

      if (usersStatus != null) {
        Map<String, dynamic> statusMap = {};
        usersStatus.forEach((key, value) {
          // Revert sanitized email (replace ',' back with '.')
          String email = key.replaceAll(',', '.');
          statusMap[email] = value;
        });

        setState(() {
          usersStatusDetails = statusMap; // Store status based on email
        });
      }
    });
  }

  String capitalizeFirstLetter(String name) {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
          height: height,
          width: width,
          color: const Color.fromARGB(255, 255, 255, 255),
          child: Scaffold(
                              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                                                  appBar: AppBar(
              toolbarHeight:height/400,
              foregroundColor: const Color.fromARGB(255, 255, 255, 255),
              automaticallyImplyLeading: false,
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            surfaceTintColor:const Color.fromARGB(255, 255, 255, 255),
            ),
    body: Container(
      color: Color.fromARGB(255, 255, 255, 255),
      height: height,
      width: width,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(
                    right: width / 20,
                    left: width / 20,
                  ),
                  child: Container(
                    child: Image.asset(
                      "assetss/logo.png",
                      height: height / 15,
                      fit: BoxFit.fill,
                    ),
                  )),
              SizedBox(
                height: height / 30,
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: width / 20,
                  left: width / 20,
                ),
                child: Container(
                  height: height / 1.5,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Your first couple match is just a step away!",
                            style: TextStyle(
                                color: const Color.fromARGB(
                                    255, 0, 0, 0),
                                fontSize: height / 32,
                                fontWeight: FontWeight.w400,
                                fontFamily: "defaultfontsbold"),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: height / 60,
                        ),
                        Center(
                          child: Image.asset(
                            "assetss/Group 911.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          height: height / 15,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(
                                                    height / 10)),
                                        backgroundColor:
                                            Color(0xffF5ECFF),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) {
                                            return CoupleAddingPage();
                                          },
                                        ));
                                      },
                                      child: Text(
                                        "Add New",
                                        style: TextStyle(
                                            color: Color(0xff7905F5),
                                            fontFamily:
                                                "defaultfonts",
                                            fontWeight:
                                                FontWeight.w500,
                                            fontSize: height / 45),
                                      ))),
                              SizedBox(
                                width: width / 70,
                              ),
                              Expanded(
                                child:
                                 ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color(0xff7905F5),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) {
                                          return CoupleMatchingPage();
                                        },
                                      ));
                                    },
                                    child: Text(
                                      "Match Couple",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "defaultfonts",
                                          fontWeight: FontWeight.w500,
                                          fontSize: height / 45),
                                    )),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 10,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Positioned(
            // 
              // bottom: height / 60,
              // right: width / 20,
              // left: width / 20,
            // 
            // child: A_BottomNavBar(
              // selectedIndex2: 1, check: 'already',
            // ),
          // ),
                   Positioned(
           left: 30,
           right: 30,
                  bottom: MediaQuery.of(context).size.height/40,
           child: A_BottomNavBar(
             selectedIndex2: 1, onItemTapped: (int index) { 
               if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => A_MainScreen(initialIndex: 1,)),
          );
        }          else if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => A_MainScreen(initialIndex: 0,)),
          );
        } 
       else if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => A_MainScreen(initialIndex: 2,)),
          );
        } 
       else if (index == 3) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => A_MainScreen(initialIndex: 3,)),
          );
        } 
      else  if (index == 4) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => A_MainScreen(initialIndex: 4,)),
          );
        } 
              },
           ),
         )
        ],
      ),
    ),
          ),
        );
  }
}
