import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/bootmnavbar.dart';
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
    final currentUser = FirebaseAuth.instance.currentUser!;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: height * 0.4,
              width: width,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 121, 5, 245),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    top: height / 50, left: width / 25, right: width / 25),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: height / 10,
                          width: width / 10,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                size: 20,
                                Icons.arrow_back,
                                color: Color.fromARGB(255, 121, 5, 245),
                              )),
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
                                        fontSize: height / 32),
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
                            onPressed: isSearching ? stopSearch : startSearch,
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
                    Container(
                      height: height / 7,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          final data = snapshot.data!.docs.where((doc) {
                            return doc['email'] != currentUser.email &&
                                (searchQuery.isEmpty ||
                                    doc['name']
                                        .toLowerCase()
                                        .contains(searchQuery));
                          }).toList();
                          return ListView.builder(
                            itemCount: data.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final user = data[index];
                              final String userEmail = user['email'];

                              // Fetch the status for this specific user
                              bool isOnline = false;
                              String lastSeen = "Last seen: N/A";
                              lastSeenhistory = "Last seen: N/A";

                              if (usersStatusDetails.containsKey(userEmail)) {
                                final userStatus =
                                    usersStatusDetails[userEmail];
                                isOnline = userStatus['status'] == 'online';

                                if (isOnline) {
                                  lastSeen = "Online";
                                  lastSeenhistory = "Online";
                                  statecolour =
                                      const Color.fromARGB(255, 49, 255, 56);
                                } else {
                                  var lastSeenDate =
                                      DateTime.fromMillisecondsSinceEpoch(
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                        chatPartnerEmail: user['email'],
                                        chatPartnername: user['name'],
                                        chatPartnerimage: user['profile_pic'],
                                        onlinecheck: lastSeen,
                                        statecolour: statecolour, who: 'user',
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(right: width / 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Stack(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                user['profile_pic']),
                                            radius: 26,
                                          ),
                                          if (isOnline) // Conditionally show the green dot
                                            Positioned(
                                              right: 0,
                                              bottom: 0,
                                              child: Container(
                                                height: 12,
                                                width: 12,
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors
                                                        .transparent, // Add a white border to match the profile pic edge
                                                    width: 1.5,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height / 150,
                                      ),
                                      Text(
                                        capitalizeFirstLetter(user['name']),
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontFamily: "defaultfonts",
                                            fontWeight: FontWeight.w500,
                                            fontSize: height / 55),
                                      ),
                                    ],
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
                  padding:
                      EdgeInsets.only(top: height / 30, bottom: height / 50),
                  child: ChatHistoryPage(who: 'user',),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 8, right: 8, bottom: 15, top: height / 1.25),
              child: BottomNavBar(
                selectedIndex2: 3,
              ),
            )
          ],
        ),
      ),
    );
  }
}
