import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/ambassdor/settingpage.dart/setting&activitypage.dart';
import 'package:datingapp/ambassdor/olduser/ambasterusers.dart';
import 'package:datingapp/ambassdor/onlinecheck.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class A_profile extends StatefulWidget {
  const A_profile({Key? key}) : super(key: key);

  @override
  State<A_profile> createState() => _A_profileState();
}

class _A_profileState extends State<A_profile> {
  List<Map<String, dynamic>> usersData = []; // List to store user data
  final A_OnlineStatusService _onlineStatusService = A_OnlineStatusService();
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  Map<String, dynamic> usersStatusDetails = {};
  String lastSeenHistory = "Last seen: N/A";
  Color stateColor = Colors.white;

  @override
  void initState() {
    super.initState();
    fetchUsersData();
    fetchUsersStatus();
  }

  Future<void> fetchUsersStatus() async {
    DatabaseReference usersStatusRef = _databaseRef.child('status');
    usersStatusRef.once().then((DatabaseEvent event) {
      Map<dynamic, dynamic>? usersStatus =
          event.snapshot.value as Map<dynamic, dynamic>?;
      if (usersStatus != null) {
        Map<String, dynamic> statusMap = {};
        usersStatus.forEach((key, value) {
          String email = key.replaceAll(',', '.'); // Reverse sanitization
          statusMap[email] = value;
        });
        setState(() {
          usersStatusDetails = statusMap;
        });
      }
    });
  }

  Future<void> fetchUsersData() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final ambassadorSnapshot = await FirebaseFirestore.instance
        .collection("Ambassdor")
        .doc(currentUser.email)
        .get();

    if (ambassadorSnapshot.exists) {
      final data = ambassadorSnapshot.data() as Map<String, dynamic>;
      final List<dynamic> addedUsersEmails = data['addedusers'] ?? [];
      for (var email in addedUsersEmails) {
        final userSnapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(email)
            .get();
        if (userSnapshot.exists) {
          usersData.add(userSnapshot.data() as Map<String, dynamic>);
        }
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final currentUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Ambassdor")
          .doc(currentUser.email)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userdataperson = snapshot.data?.data() as Map<String, dynamic>?;
          if (userdataperson == null) {
            return Center(
              child: Text("Ambassador data not found."),
            );
          }

          final ratings = userdataperson['rating'] as List<dynamic>? ?? [];
          double averageRating = ratings.isEmpty
              ? 0
              : ratings.reduce((a, b) => a + b) / ratings.length;

          return Scaffold(
            appBar: AppBar(
              toolbarHeight: height / 400,
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            backgroundColor: Colors.white,
            body: Container(
              height: height,
              width: width,
              padding: EdgeInsets.symmetric(horizontal: width / 20),
              child: Column(
                children: [
                  // Profile Section
                  Center(
                    child: Column(
                      children: [
                                              Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            SizedBox(
            width: width / 20,
          ),
                          Expanded(
                            child: Center(
                                child: Text(
                              "Profile",
                              style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 0, 0, 0),
                                  fontFamily: "defaultfontsbold",
                                  fontSize:20),
                            )),
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                  builder: (context) {
                                    return A_settingactivity();
                                  },
                                ));
                              },
                              child: Image(
                                  image: AssetImage(
                                      "images/heroicons-outline_menu-alt-2.png")))
                        ],
                      ),
                        SizedBox(height: height / 30),
                        CircleAvatar(
                          radius: height / 10,
                          backgroundImage: NetworkImage(
                            userdataperson['profile_pic'] ??
                                "https://img.freepik.com/premium-vector/data-loading-icon-waiting-program-vector-image-file-upload_652575-219.jpg?w=740",
                          ),
                        ),
                        SizedBox(height: height / 50),
                        Text(
                          userdataperson['name'] ?? "UNKNOWN",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        SizedBox(height: height / 60),
                        RatingBarIndicator(
                          rating: averageRating,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: height / 30,
                        ),
                        SizedBox(height: height / 40),
                      ],
                    ),
                  ),

                  // Grid Section
                  Expanded(
                    child: GridView.builder(
                      itemCount: usersData.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: width * 0.02,
                        mainAxisSpacing: height * 0.02,
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (context, index) {
                        final user = usersData[index];
                        final userEmail = user['email'] ?? "Unknown Email";

                        bool isOnline = false;
                        String lastSeen = "Last seen: N/A";
                        if (usersStatusDetails.containsKey(userEmail)) {
                          final userStatus = usersStatusDetails[userEmail];
                          isOnline = userStatus['status'] == 'online';
                          lastSeen = isOnline
                              ? "Online"
                              : "Last seen: ${DateFormat('MMM d, yyyy h:mm a').format(DateTime.fromMillisecondsSinceEpoch(userStatus['lastSeen']).toLocal())}";
                          stateColor =
                              isOnline ? Colors.green : Colors.white;
                        }

                        return A_users(
                          onlinecheck: lastSeen,
                          statecolour: stateColor,
                          profileimage: user['profile_pic'] ??
                              "https://img.freepik.com/premium-vector/data-loading-icon-waiting-program-vector-image-file-upload_652575-219.jpg?w=740",
                          name: user['name']?.toUpperCase() ?? "UNKNOWN",
                          distance: 300,
                          location: user['Address'] ?? "Unknown Location",
                          startLatitude: user["X"] ?? 0.0,
                          startLongitude: user["Y"] ?? 0.0,
                          endLatitude: userdataperson["X"] ?? 0.0,
                          endLongitude: userdataperson["Y"] ?? 0.0,
                          age: user['Age'] ?? "N/A",
                          height: user['height'] ?? "N/A",
                          labels: user['Interest'] ?? [],
                          iconss: user["Icon"] ?? "",
                          imagecollection: user['images'] ?? [],
                          ID: userEmail,
                          useremail: userdataperson['email'] ?? "unknown_email",
                          languages: user['languages'] ?? [],
                          education: user['education'] ?? "Unknown",
                          description: user['description'] ?? "No description provided",
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
