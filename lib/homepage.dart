import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/bootmnavbar.dart';
import 'package:datingapp/filterpage.dart';
import 'package:datingapp/onlinecheck.dart';
import 'package:datingapp/person.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  final OnlineStatusService _onlineStatusService = OnlineStatusService();
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  Map<String, dynamic> usersStatusDetails = {}; // Change from List to Map
  String lastSeenhistory = "Last seen: N/A";
  Color statecolour = Colors.white;

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
            .collection("users")
            .doc(curentuser.email!)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userdataperson =
                snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
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
                child: Padding(
                  padding: EdgeInsets.only(
                    right: width / 20,
                    left: width / 20,
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    " Location",
                                    style: TextStyle(
                                        color: const Color(0xff7D7676),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "defaultfontsbold",
                                        fontSize: 16),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_pin,
                                        size: 25,
                                        color: Color.fromARGB(
                                            255, 121, 5, 245),
                                      ),
                                      Text(
                                        userdataperson['Address']
                                                .toString() ??
                                            "",
                                        style: TextStyle(
                                            color:
                                                const Color(0xff26150F),
                                            fontFamily:
                                                "defaultfontsbold",
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ],
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
                                      return filterpage();
                                    },
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(10),
                                      color: const Color(0xffEDEDED)),
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
                            height: height / 40,
                          ),
                          Expanded(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: 
                              FirebaseFirestore.instance
                                  .collection("users")
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text(
                                          'Error: ${snapshot.error}'));
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                
                                final data =
                                    snapshot.data!.docs.where((doc) {
                                  return doc['email'] != curentuser.email;
                                }).toList();
                
                                return ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    final user = data[index];
                                    final String userEmail =
                                        user['email'];
                
                                    bool isOnline = false;
                                    String lastSeen = "Last seen: N/A";
                                    lastSeenhistory = "Last seen: N/A";
                                    if (usersStatusDetails
                                        .containsKey(userEmail)) {
                                      final userStatus =
                                          usersStatusDetails[userEmail];
                                      isOnline = userStatus['status'] ==
                                          'online';
                                      if (isOnline) {
                                        lastSeen = "Online";
                                        lastSeenhistory = "Online";
                                        statecolour =
                                            const Color.fromARGB(
                                                255, 49, 255, 56);
                                      } else {
                                        var lastSeenDate = DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    userStatus[
                                                        'lastSeen'])
                                            .toLocal();
                                        lastSeen =
                                            "Last seen: ${DateFormat('MMM d, yyyy h:mm a').format(lastSeenDate)}";
                                        lastSeenhistory = lastSeen;
                                        statecolour = Colors.white;
                                      }
                                    }
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: height / 50),
                                      child: Container(
                                        height: height / 1.8,
                                        width: width,
                                        child: person(
                                          onlinecheck: lastSeen,
                                          statecolour: statecolour,
                                          profileimage: user[
                                                  'profile_pic'] ??
                                              "https://img.freepik.com/premium-vector/data-loading-icon-waiting-program-vector-image-file-upload_652575-219.jpg?w=740",
                                          name: user['name']
                                              .toString()
                                              .toUpperCase(),
                                          distance: 300,
                                          location: user['Address'],
                                          startLatitude: user["X"],
                                          startLongitude: user["Y"],
                                          endLatitude:
                                              userdataperson["X"],
                                          endLongitude:
                                              userdataperson["Y"],
                                          age: user['Age'],
                                          height: user['height'],
                                          labels: user['Interest'],
                                          iconss: user["Icon"],
                                          imagecollection: user['images'],
                                          ID: user.id,
                                          useremail:
                                              userdataperson['email'],
                                          languages: user['languages'],
                                          education: user['education'],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: height / 1.25),
                        child: BottomNavBar(
                          selectedIndex2: 0,
                        ),
                      ),
                    ],
                  ),
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
