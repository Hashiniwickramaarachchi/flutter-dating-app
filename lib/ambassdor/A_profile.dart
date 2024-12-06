import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/accountdelectionpage.dart';
import 'package:datingapp/ambassdor/settingpage.dart/setting&activitypage.dart';
import 'package:datingapp/ambassdor/olduser/ambasterusers.dart';
import 'package:datingapp/ambassdor/onlinecheck.dart';
import 'package:datingapp/block.dart';
import 'package:datingapp/deactivepage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
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
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _pickImage(String email) async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        await _uploadImage(email);
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> _uploadImage(String email) async {
    if (_image == null) return;

    final storageRef = _storage.ref().child('profile_pics/${email}');
    try {
      // Upload image to Firebase Storage
      final uploadTask = await storageRef.putFile(_image!);
      final imageUrl = await uploadTask.ref.getDownloadURL();

      // Update Firestore
      await _firestore
          .collection('Ambassdor')
          .doc(email)
          .update({'profile_pic': imageUrl});

      print("Profile picture updated successfully!");
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

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
            .collection("Partner")
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
        final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      // Handle unauthenticated user state (e.g., redirect to login page or s
      return Center(child: Text('No user is logged in.'));
    }
       return StreamBuilder<DocumentSnapshot>(
       stream: FirebaseFirestore.instance
           .collection("Ambassdor")
           .doc(currentUser.email)
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
                       who: 'Ambassdor',
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
          final profilePic = userdataperson['profile_pic'] ?? '';

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
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontFamily: "defaultfontsbold",
                                    fontSize: 20),
                              )),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
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
                        Center(
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _pickImage(userdataperson['email']);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height /
                                          30),
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.height / 5,
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color:
                                              Color.fromARGB(255, 121, 5, 245),
                                          width: 2),
                                      shape: BoxShape.circle,
                                      color: const Color.fromARGB(
                                          255, 206, 206, 206),
                                    ),
                                    child: profilePic.isEmpty
                                        ? Icon(
                                            Icons.person,
                                            color: const Color.fromARGB(
                                                255, 66, 66, 66),
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                15,
                                          )
                                        : ClipOval(
                                            child: Image.network(
                                              profilePic,
                                              fit: BoxFit.cover,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.5,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  5,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: width / 3,
                                top: height / 6,
                                child: Container(
                                  height: height / 20,
                                  width: width / 20,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              AssetImage("assetss/red.png"))),
                                ),
                              ),
                            ],
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
                          stateColor = isOnline ? Colors.green : Colors.white;
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
                          description:
                              user['description'] ?? "No description provided",
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
