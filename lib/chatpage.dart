import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/accoundelete.dart';
import 'package:datingapp/accountdelectionpage.dart';
import 'package:datingapp/block.dart';
import 'package:datingapp/bootmnavbar.dart';
import 'package:datingapp/deactivepage.dart';
import 'package:datingapp/history.dart';
import 'package:datingapp/userchatpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'chatpage.dart';
import 'package:intl/intl.dart';

class Chatscreen extends StatefulWidget {
  const Chatscreen({Key? key}) : super(key: key);

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic> usersStatusDetails = {}; // Change from List to Map
  String lastSeenhistory = "Last seen: N/A";
  Color statecolour = Colors.white;
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    fetchUsersStatus();
  }

  // Fetch users status from Firebase Realtime Database
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

  void startSearch() {
    setState(() {
      isSearching = true;
    });
  }

  void stopSearch() {
    setState(() {
      isSearching = false;
      searchQuery = "";
      searchController.clear();
    });
  }

  Widget buildSearchField() {
    return TextField(
      controller: searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Search users...",
        contentPadding: EdgeInsets.only(left: 30),
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) {
        setState(() {
          searchQuery = query.toLowerCase();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      // Handle unauthenticated user state (e.g., redirect to login page or sh
      return Center(child: Text('No user is logged in.'));
    }
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser.email!)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userdataperson =
                snapshot.data!.data() as Map<String, dynamic>?;
            if (userdataperson?['statusType'] == 'deactive') {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                if (mounted) {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => deactivepage()),
                    (Route<dynamic> route) => false,
                  );
                }
              });
            }
            if (userdataperson?['statusType'] == 'block') {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                if (mounted) {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => block()),
                    (Route<dynamic> route) => false,
                  );
                }
              });
            }

            if (userdataperson?['statusType'] == 'delete') {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                if (mounted) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) {
                      return DeleteAccountPage(
                        initiateDelete: true,
                        who: 'users',
                      );
                    },
                  ));
                }
              });
            }

            if (userdataperson == null) {
              return Center(
                child: Text("User data not found."),
              );
            }
            return Scaffold(
              backgroundColor: Color.fromARGB(255, 121, 5, 245),
              appBar: AppBar(
                toolbarHeight: height / 400,
                foregroundColor: Color.fromARGB(255, 121, 5, 245),
                automaticallyImplyLeading: false,
                backgroundColor: Color.fromARGB(255, 121, 5, 245),
                surfaceTintColor: Color.fromARGB(255, 121, 5, 245),
              ),
              body: Stack(
                children: [
                  Container(
                    height: height * 0.4,
                    width: width,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 121, 5, 245),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: width / 20, right: width / 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(userdataperson['profile_pic']),
                                radius: 22,
                              ),
                              Expanded(
                                child: isSearching
                                    ? buildSearchField()
                                    : Center(
                                        child: Text(
                                          "Chat",
                                          style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontFamily: "defaultfonts",
                                              fontSize: 20),
                                        ),
                                      ),
                              ),
                              Container(
                                height: height / 10,
                                width: width / 10,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: IconButton(
                                  onPressed:
                                      isSearching ? stopSearch : startSearch,
                                  icon: Icon(
                                    isSearching ? Icons.clear : Icons.search,
                                    color: Color.fromARGB(255, 121, 5, 245),
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: height / 70),
                          // Container(
                          // height: height / 7,
                          // child: StreamBuilder<QuerySnapshot>(
                          // stream: FirebaseFirestore.instance
                          // .collection("users")
                          // .snapshots(),
                          // builder: (context, snapshot) {
                          // if (snapshot.hasError) {
                          // return Center(
                          // child:
                          // Text('Error: ${snapshot.error}'));
                          // }
                          // if (snapshot.connectionState ==
                          // ConnectionState.waiting) {
                          // return const Center(
                          // child: CircularProgressIndicator());
                          // }
                          // final data = snapshot.data!.docs.where((doc) {
                          // return doc['email'] != currentUser.email &&
                          // (searchQuery.isEmpty ||
                          // doc['name']
                          // .toLowerCase()
                          // .contains(searchQuery));
                          // }).toList();
                          // return ListView.builder(
                          // itemCount: data.length,
                          // scrollDirection: Axis.horizontal,
                          // itemBuilder: (context, index) {
                          // final user = data[index];
                          // final String userEmail = user['email'];

                          // bool isOnline = false;
                          // String lastSeen = "Last seen: N/A";
                          // lastSeenhistory = "Last seen: N/A";

                          // if (usersStatusDetails
                          // .containsKey(userEmail)) {
                          // final userStatus =
                          // usersStatusDetails[userEmail];
                          // isOnline =
                          // userStatus['status'] == 'online';

                          // if (isOnline) {
                          // lastSeen = "Online";
                          // lastSeenhistory = "Online";
                          // statecolour = const Color.fromARGB(
                          // 255, 49, 255, 56);
                          // } else {
                          // var lastSeenDate = DateTime
                          // .fromMillisecondsSinceEpoch(
                          // userStatus['lastSeen'])
                          // .toLocal();
                          // lastSeen =
                          // "Last seen: ${DateFormat('MMM d, yyyy h:mm a').format(lastSeenDate)}";
                          // lastSeenhistory = lastSeen;
                          // statecolour = Colors.white;
                          // }
                          // }

                          // return GestureDetector(
                          // onTap: () {
                          // Navigator.push(
                          // context,
                          // MaterialPageRoute(
                          // builder: (context) => ChatPage(
                          // chatPartnerEmail: user['email'],
                          // chatPartnername: user['name'],
                          // chatPartnerimage:
                          // user['profile_pic'],
                          // onlinecheck: lastSeen,
                          // statecolour: statecolour,
                          // who: 'user',
                          // ),
                          // ),
                          // );
                          // },
                          // child: Padding(
                          // padding: EdgeInsets.only(
                          // right: width / 15),
                          // child: Column(
                          // crossAxisAlignment:
                          // CrossAxisAlignment.center,
                          // children: [
                          // Stack(
                          // children: [
                          // CircleAvatar(
                          // backgroundImage:
                          // NetworkImage(user[
                          // 'profile_pic']),
                          // radius: 26,
                          // ),
                          // if (isOnline) // Conditionally show the green dot
                          // Positioned(
                          // right: 0,
                          // bottom: 0,
                          // child: Container(
                          // height: 12,
                          // width: 12,
                          // decoration:
                          // BoxDecoration(
                          // color: Colors.green,
                          // shape:
                          // BoxShape.circle,
                          // border: Border.all(
                          // color: Colors
                          // .transparent, // Add a white border to match the profile pic edge
                          // width: 1.5,
                          // ),
                          // ),
                          // ),
                          // ),
                          // ],
                          // ),
                          // SizedBox(
                          // height: height / 150,
                          // ),
                          // Text(
                          // capitalizeFirstLetter(
                          // user['name']),
                          // style: TextStyle(
                          // color: const Color.fromARGB(
                          // 255, 255, 255, 255),
                          // fontFamily: "defaultfonts",
                          // fontWeight: FontWeight.w500,
                          // fontSize: 11),
                          // ),
                          // ],
                          // ),
                          // ),
                          // );
                          // },
                          // );
                          // },
                          // ),
                          // ),
                          // Container(
                          // height: height / 7,
                          // child: StreamBuilder<QuerySnapshot>(
                          // stream: FirebaseFirestore.instance
                          // .collection("users")
                          // .snapshots(),
                          // builder: (context, snapshot) {
                          // if (snapshot.hasError) {
                          // return Center(
                          // child: Text('Error: ${snapshot.error}'));
                          // }
                          // if (snapshot.connectionState ==
                          // ConnectionState.waiting) {
                          // return const Center(
                          // child: CircularProgressIndicator());
                          // }
                          // final data = snapshot.data!.docs.where((doc) {
                          // return doc['email'] != currentUser.email &&
                          // (searchQuery.isEmpty ||
                          // doc['name']
                          // .toLowerCase()
                          // .contains(searchQuery));
                          // }).toList();

                          // data.sort((a, b) {
                          // final aStatus = usersStatusDetails[a['email']]
                          // ?['status'] ??
                          // 'offline';
                          // final bStatus = usersStatusDetails[b['email']]
                          // ?['status'] ??
                          // 'offline';
                          // return bStatus.compareTo(
                          // aStatus); // 'online' comes before 'offline'
                          // });

                          // return ListView.builder(
                          // itemCount: data.length,
                          // scrollDirection: Axis.horizontal,
                          // itemBuilder: (context, index) {
                          // final user = data[index];
                          // final String userEmail = user['email'];

                          // bool isOnline = false;
                          // String lastSeen = "Last seen: N/A";
                          // lastSeenhistory = "Last seen: N/A";

                          // if (usersStatusDetails
                          // .containsKey(userEmail)) {
                          // final userStatus =
                          // usersStatusDetails[userEmail];
                          // isOnline =
                          // userStatus['status'] == 'online';
                          // if (isOnline) {
                          // lastSeen = "Online";
                          // lastSeenhistory = "Online";
                          // statecolour = const Color.fromARGB(
                          // 255, 49, 255, 56);
                          // } else {
                          // var lastSeenDate =
                          // DateTime.fromMillisecondsSinceEpoch(
                          // userStatus['lastSeen'])
                          // .toLocal();
                          // lastSeen =
                          // "Last seen: ${DateFormat('MMM d, yyyy h:mm a').format(lastSeenDate)}";
                          // lastSeenhistory = lastSeen;
                          // statecolour = Colors.white;
                          // }
                          // }

                          // return GestureDetector(
                          // onTap: () {
                          // Navigator.push(
                          // context,
                          // MaterialPageRoute(
                          // builder: (context) => ChatPage(
                          // chatPartnerEmail: user['email'],
                          // chatPartnername: user['name'],
                          // chatPartnerimage:
                          // user['profile_pic'],
                          // onlinecheck: lastSeen,
                          // statecolour: statecolour,
                          // who: 'user',
                          // ),
                          // ),
                          // );
                          // },
                          // child: Padding(
                          // padding:
                          // EdgeInsets.only(right: width / 15),
                          // child: Column(
                          // crossAxisAlignment:
                          // CrossAxisAlignment.center,
                          // children: [
                          // Stack(
                          // children: [
                          // CircleAvatar(
                          // backgroundImage: NetworkImage(
                          // user['profile_pic']),
                          // radius: 26,
                          // ),
                          // if (isOnline) // Conditionally show the green dot
                          // Positioned(
                          // right: 0,
                          // bottom: 0,
                          // child: Container(
                          // height: 12,
                          // width: 12,
                          // decoration: BoxDecoration(
                          // color: Colors.green,
                          // shape: BoxShape.circle,
                          // border: Border.all(
                          // color: Colors
                          // .transparent,
                          // width: 1.5,
                          // ),
                          // ),
                          // ),
                          // ),
                          // ],
                          // ),
                          // SizedBox(height: height / 150),
                          // Text(
                          // capitalizeFirstLetter(
                          // user['name']),
                          // style: TextStyle(
                          // color: const Color.fromARGB(
                          // 255, 255, 255, 255),
                          // fontFamily: "defaultfonts",
                          // fontWeight: FontWeight.w500,
                          // fontSize: 11),
                          // ),
                          // ],
                          // ),
                          // ),
                          // );
                          // },
                          // );
                          // },
                          // ),
                          // ),

                          Container(
                            height: height / 7,
                            child: FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection("Blocked USers")
                                  .doc(currentUser.email)
                                  .get(),
                              builder: (context, blockedSnapshot) {
                                if (blockedSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }

                                if (blockedSnapshot.hasError) {
                                  return Center(
                                      child: Text(
                                          'Error: ${blockedSnapshot.error}'));
                                }

                                // Get blocked users array
                                List<String> blockedEmails = [];
                                if (blockedSnapshot.hasData &&
                                    blockedSnapshot.data!.exists) {
                                  final blockedData = blockedSnapshot.data!
                                      .data() as Map<String, dynamic>?;
                                  if (blockedData != null &&
                                      blockedData["This Id blocked Users"] !=
                                          null) {
                                    blockedEmails = List<String>.from(
                                        blockedData["This Id blocked Users"]);
                                  }
                                }

                                // StreamBuilder for all users
                                return StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection("users")
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }

                                    // Filter users to exclude the current user and blocked users
                                    final data =
                                        snapshot.data!.docs.where((doc) {
                                      final userEmail = doc['email'];
                                      return userEmail != currentUser.email &&
                                          !blockedEmails.contains(userEmail) &&
                                          (searchQuery.isEmpty ||
                                              doc['name']
                                                  .toLowerCase()
                                                  .contains(searchQuery
                                                      .toLowerCase()));
                                    }).toList();

                                    // Sort the data to show online users first

                                    data.sort((a, b) {
                                      final aStatus =
                                          usersStatusDetails[a['email']]
                                                  ?['status'] ??
                                              'offline';
                                      final bStatus =
                                          usersStatusDetails[b['email']]
                                                  ?['status'] ??
                                              'offline';
                                      return bStatus.compareTo(
                                          aStatus); // 'online' comes before 'offline'
                                    });

                                    if (data.isEmpty) {
                                      return Center(
                                          child: Text("No users available"));
                                    }

                                    return ListView.builder(
                                      itemCount: data.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final user = data[index];
                                        final String userEmail = user['email'];
                                        bool isOnline = false;
                                        String lastSeen = "Last seen: N/A";
                                        Color stateColour = Colors.white;

                                        lastSeenhistory = "Last seen: N/A";
                                        if (usersStatusDetails
                                            .containsKey(userEmail)) {
                                          final userStatus =
                                              usersStatusDetails[userEmail];
                                          isOnline =
                                              userStatus['status'] == 'online';
                                          if (isOnline) {
                                            lastSeen = "Online";
                                            lastSeenhistory = "Online";
                                            statecolour = const Color.fromARGB(
                                                255, 49, 255, 56);
                                          } else {
                                            var lastSeenDate = DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        userStatus['lastSeen'])
                                                .toLocal();
                                            lastSeen =
                                                "Last seen: ${DateFormat('MMM d, yyyy h:mm a').format(lastSeenDate)}";
                                            lastSeenhistory = lastSeen;
                                            statecolour = Colors.white;
                                          }
                                        }

                                        return GestureDetector(
                                          onTap: () {
                                            return checkInterestMatch(
                                                userdataperson['email'],
                                                userEmail,
                                                user['profile_pic'],
                                                user['name'],
                                                lastSeen,
                                                stateColour);

                                            // Navigator.push(
                                            // context,
                                            // MaterialPageRoute(
                                            // builder: (context) => ChatPage(
                                            // chatPartnerEmail: userEmail,
                                            // chatPartnername: user['name'],
                                            // chatPartnerimage: user['profile_pic'],
                                            // onlinecheck: lastSeen,
                                            // statecolour: stateColour,
                                            // who: 'user',
                                            // ),
                                            // ),
                                            // );
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: width / 15),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Stack(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(user[
                                                              'profile_pic']),
                                                      radius: 26,
                                                    ),
                                                    if (isOnline)
                                                      Positioned(
                                                        right: 0,
                                                        bottom: 0,
                                                        child: Container(
                                                          height: 12,
                                                          width: 12,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.green,
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                              color: Colors
                                                                  .transparent,
                                                              width: 1.5,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                SizedBox(height: height / 150),
                                                Text(
                                                  capitalizeFirstLetter(
                                                      user['name']),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "defaultfonts",
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height / 4),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: height / 30, bottom: height / 10),
                        child: ChatHistoryPage(
                          who: 'user',
                        ),
                      ),
                    ),
                  ),
                  // Positioned(
                  //  left: width/20,
                  //  right: width/20,
                  //  bottom: height/60,
                  // child: BottomNavBar(
                  // selectedIndex2: 3,
                  // ),
                  // )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  void checkInterestMatch(
    String currentuser,
    String useremail,
    String image,
    String name,
    String lastseen,
    Color stateColor,
  ) async {
    try {
      // Get logged-in user's email

      // Fetch interests from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentuser)
          .get();
      final targetDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(useremail)
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                chatPartnerEmail: useremail,
                chatPartnername: name,
                chatPartnerimage: image,
                onlinecheck: lastseen,
                statecolour: stateColor,
                who: 'user',
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Your interests match ${matchPercentage.toStringAsFixed(1)}% with ${useremail}. Please try again later!'),
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
