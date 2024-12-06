import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/favcontainer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OnlineUsersPage extends StatefulWidget {
  @override
  _OnlineUsersPageState createState() => _OnlineUsersPageState();
}

class _OnlineUsersPageState extends State<OnlineUsersPage> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> onlineUsersDetails = [];
  final curentuser = FirebaseAuth.instance.currentUser!;
  Map<String, dynamic> usersStatusDetails = {};
  String lastSeenhistory = "Last seen: N/A";
  Color statecolour = Colors.white;
      final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    fetchOnlineUsers();
  }

  @override
  void dispose() {
    // Perform any cleanup if necessary before the widget is removed from the tree
    super.dispose();
  }

  // Fetch online users from Firebase Realtime Database
  Future<void> fetchOnlineUsers() async {
    DatabaseReference onlineUsersRef = _databaseRef.child('status');
    
    // Fetch online users from Realtime Database
    onlineUsersRef.once().then((DatabaseEvent event) {
      Map<dynamic, dynamic>? onlineUsers = event.snapshot.value as Map<dynamic, dynamic>?;

      if (onlineUsers != null) {
        List<String> onlineUserEmails = [];
                Map<String, dynamic> statusMap = {};

        // Iterate over online users to filter those with status 'online'
        onlineUsers.forEach((key, value) {
          if (value['status'] == 'online') {
            // Revert the sanitized email (replace ',' back with '.')
            String email = key.replaceAll(',', '.');
            onlineUserEmails.add(email);
          statusMap[email] = value;

          }
        });
     setState(() {
       usersStatusDetails = statusMap; 
     });
        // Once we have the emails of online users, fetch their details from Firestore
        fetchUserDetailsFromFirestore(onlineUserEmails);
      }
    });
  }

  // Fetch user details from Firestore based on the email addresses
  Future<void> fetchUserDetailsFromFirestore(List<String> onlineUserEmails) async {
    List<Map<String, dynamic>> userDetails = [];

    for (String email in onlineUserEmails) {
      // Fetch user details from Firestore using the email
      DocumentSnapshot<Map<String, dynamic>> userSnapshot = await _firestore.collection('Favourite').doc(curentuser.email!).collection('fav1').doc(email).get();
      if (userSnapshot.exists) {
        userDetails.add(userSnapshot.data()!);
      }
    }

    // Check if the widget is still mounted before calling setState
    if (mounted) {
      setState(() {
        onlineUsersDetails = userDetails;
      });
    }
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
      child:StreamBuilder<DocumentSnapshot>(
  stream: FirebaseFirestore.instance.collection("users").doc(curentuser.email!).snapshots(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      final userdataperson = snapshot.data!.data() as Map<String, dynamic>;

      return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('Blocked Users')
            .doc(curentuser.email!)
            .get(),
        builder: (context, blockedSnapshot) {
          if (blockedSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<String> blockedEmails = [];
          if (blockedSnapshot.hasData && blockedSnapshot.data!.exists) {
            final blockedData = blockedSnapshot.data!.data() as Map<String, dynamic>?;
            if (blockedData != null &&
                blockedData['This Id blocked Users'] != null) {
              blockedEmails = List<String>.from(blockedData['This Id blocked Users']);
            }
          }

          // Filter onlineUsersDetails based on blocked users
          final filteredUsers = onlineUsersDetails.where((user) {
            return !blockedEmails.contains(user['email']);
          }).toList();

          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            body: filteredUsers.isEmpty
                ? Center(child: Text("No Favourite User Available in Online"))
                : Padding(
                    padding: EdgeInsets.only(
                      left: width / 40,
                      right: width / 40,
                      top: height / 20,
                    ),
                    child: GridView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filteredUsers.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: width * 0.02,
                        mainAxisSpacing: height * 0.02,
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        final String userEmail = user['email'];

                        bool isOnline = false;
                        String lastSeen = "Last seen: N/A";
                        if (usersStatusDetails.containsKey(userEmail)) {
                          final userStatus = usersStatusDetails[userEmail];
                          isOnline = userStatus['status'] == 'online';
                          if (isOnline) {
                            lastSeen = "Online";
                            statecolour = const Color.fromARGB(255, 49, 255, 56);
                          } else {
                            var lastSeenDate = DateTime.fromMillisecondsSinceEpoch(
                                    userStatus['lastSeen'])
                                .toLocal();
                            lastSeen = "Last seen: ${DateFormat('MMM d, yyyy h:mm a').format(lastSeenDate)}";
                            statecolour = Colors.white;
                          }
                        }

                        return Container(
                          child: favcontainer(
                            profileimage: user['profile_pic'] ??
                                "https://img.freepik.com/premium-vector/data-loading-icon-waiting-program-vector-image-file-upload_652575-219.jpg?w=740",
                            name: user['name'],
                            distance: 300,
                            location: user['Address'],
                            startLatitude: user["X"],
                            startLongitude: user["Y"],
                            endLatitude: userdataperson["X"],
                            endLongitude: userdataperson["Y"],
                            age: user['Age'],
                            height: user['height'] ?? "",
                            labels: user['Interest'],
                            iconss: user["Icon"],
                            imagecollection: user['images'],
                            ID: user['email'],
                            useremail: userdataperson['email'],
                            onlinecheck: lastSeen,
                            statecolour: statecolour,
                            education: user['education'],
                            languages: user["languages"],
                            description: user['description'],
                          ),
                        );
                      },
                    ),
                  ),
          );
        },
      );
    } else if (snapshot.hasError) {
      return Center(
        child: Text("Error: ${snapshot.error}"),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  },
)

    );
  }
}
