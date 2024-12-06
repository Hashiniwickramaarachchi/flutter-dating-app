import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/ambassdor/A_Mainscree.dart';
import 'package:datingapp/ambassdor/bottombar.dart';
import 'package:datingapp/ambassdor/filterpage.dart';
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

class A_homepage extends StatefulWidget {
  const A_homepage({super.key});

  @override
  State<A_homepage> createState() => _A_homepageState();
}

class _A_homepageState extends State<A_homepage> {
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
    final curentuser = FirebaseAuth.instance.currentUser!;

    return Container(
      height: height,
      width: width,
      color: const Color.fromARGB(255, 255, 255, 255),
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Ambassdor")
            .doc(curentuser.email!)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                toolbarHeight: height / 400,
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
                    Padding(
                      padding:  EdgeInsets.only(
left: width/20,
right: width/20
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                           children: [
                             Expanded(
                               child: Container(
                                 height: height /
                                     18, // Set height as needed
                                 decoration: BoxDecoration(
                                   color: Colors.transparent,
                                   borderRadius:
                                       BorderRadius.circular(10.0),
                                 ),
                                 child: TextField(
                                   controller: _searchController,
                                   style: Theme.of(context)
                                       .textTheme
                                       .headlineSmall,
                                   decoration: InputDecoration(
                                       contentPadding:
                                           EdgeInsets.symmetric(
                                               horizontal: width / 20,
                                               vertical: height /
                                                   60 // Adjust padding as needed
                                               ),
                                       hintText: "Search",
                                       border: InputBorder.none,
                                       focusedBorder:
                                           OutlineInputBorder(
                                         borderSide: BorderSide(
                                             color: Color(0xff8F9DA6)),
                                         borderRadius:
                                             BorderRadius.circular(
                                                 10.0),
                                       ),
                                       enabledBorder:
                                           OutlineInputBorder(
                                               borderRadius:
                                                   BorderRadius
                                                       .circular(10.0),
                                               borderSide: BorderSide(
                                                   color: Color(
                                                       0xff8F9DA6)))),
                                 ),
                               ),
                             ),
                             SizedBox(
                               width: width / 30,
                             ),
                             GestureDetector(
                               onTap: () {
                           
                           
                                     showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(50),
                                                      topRight: Radius.circular(50),
                                                    ),
                                                  ),
                                                  backgroundColor: Colors.amber,
                                                  context: context,
                                                  builder: (context) {
                                                    return A_filterpage();
                                                  },
                                                );
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           
                               },
                               child: Container(
                                 decoration: BoxDecoration(
                                   borderRadius:
                                       BorderRadius.circular(10),
                                   color: const Color(0xffEDEDED),
                                 ),
                                 child: Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Icon(
                                     Icons.tune,
                                     color: Color.fromARGB(
                                         255, 121, 5, 245),
                                     size: height / 30,
                                   ),
                                 ),
                               ),
                             ),
                           ],
                                                        ),
                          SizedBox(
                            height: height / 30,
                          ),
                          Container(
                            height: height / 1.5,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      "Ready to start making\nconnections?",
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 121, 5, 245),
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
                                      "assetss/Mask group.png",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height / 60,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: width / 20,
                                      left: width / 20,
                                    ),
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Introduce a Couple to the Platform",
                                            style: TextStyle(
                                                color:
                                                    const Color.fromARGB(
                                                        255, 0, 0, 0),
                                                fontFamily:
                                                    "defaultfontsbold",
                                                fontWeight:
                                                    FontWeight.bold,
                                                fontSize: height / 50),
                                          ),
                                          SizedBox(
                                            height: height / 60,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child:
                                                    LinearProgressIndicator(
                                                  value:
                                                      0.0, // Shows progress from 0.0 to 1.0
                                                  minHeight:
                                                      8.0, // Adjust height of progress bar
                                                  color: const Color
                                                      .fromARGB(
                                                      255, 121, 5, 245),
                                                  borderRadius:
                                                      BorderRadius
                                                          .circular(10),
                                                ),
                                              ),
                                              SizedBox(
                                                width: width / 20,
                                              ),
                                              Text(
                                                "0%",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        height / 50),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: height / 60,
                                          ),
                                          Text(
                                            "Track Your First Match",
                                            style: TextStyle(
                                                color:
                                                    const Color.fromARGB(
                                                        255, 0, 0, 0),
                                                fontFamily:
                                                    "defaultfontsbold",
                                                fontWeight:
                                                    FontWeight.bold,
                                                fontSize: height / 50),
                                          ),
                                          SizedBox(
                                            height: height / 60,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child:
                                                    LinearProgressIndicator(
                                                  value:
                                                      0.0, // Shows progress from 0.0 to 1.0
                                                  minHeight:
                                                      8.0, // Adjust height of progress bar
                                                  color: const Color
                                                      .fromARGB(
                                                      255, 121, 5, 245),
                                                  borderRadius:
                                                      BorderRadius
                                                          .circular(10),
                                                ),
                                              ),
                                              SizedBox(
                                                width: width / 20,
                                              ),
                                              Text(
                                                "0%",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        height / 50),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height / 10,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Positioned(
                    // 
                        // bottom: height / 60,
                        // right: width / 20,
                        // left: width / 20,
                      // 
                      // child: A_BottomNavBar(
                        // selectedIndex2: 0, check: 'new',
                      // ),
                    // ),
                
                                      Positioned(
                                          left: 30,
                  right: 30,
                         bottom: MediaQuery.of(context).size.height/40,
                          child: A_BottomNavBar(
                            selectedIndex2: 0, onItemTapped: (int index) { 
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
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else {
            return Center(
                child: Container(
                    height: height / 50,
                    width: width / 50,
                    child: CircularProgressIndicator(
                      color: Color(
                        0xff7905F5,
                      ),
                    )));
          }
        },
      ),
    );
  }
}
