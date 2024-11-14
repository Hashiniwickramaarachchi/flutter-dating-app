import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/ambassdor/bottombar.dart';
import 'package:datingapp/ambassdor/olduser/ambasterusers.dart';
import 'package:datingapp/ambassdor/onlinecheck.dart';
import 'package:datingapp/ambassdor/person.dart';
import 'package:datingapp/ambassdor/settingpage.dart/setting&activitypage.dart';
import 'package:datingapp/bootmnavbar.dart';
import 'package:datingapp/settingpage.dart/setting&activitypage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ambassdorshowchat extends StatefulWidget {
String useremail;
   ambassdorshowchat({
    
    required this.useremail,
    super.key});

  @override
  State<ambassdorshowchat> createState() => _ambassdorshowchatState();
}

class _ambassdorshowchatState extends State<ambassdorshowchat> {
  XFile? _image;
  List<Map<String, dynamic>> usersData = []; // List to store user data
 final A_OnlineStatusService _onlineStatusService = A_OnlineStatusService();
 final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
 Map<String, dynamic> usersStatusDetails = {}; // Change from List to Map
  String lastSeenhistory = "Last seen: N/A";
  double rating = 0.0;

 Color statecolour = Colors.white;
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

  Future<void> fetchUsersData() async {
    final ambassadorSnapshot = await FirebaseFirestore.instance
        .collection("Ambassdor")
        .doc(widget.useremail)
        .get();

    if (ambassadorSnapshot.exists) {
      final data = ambassadorSnapshot.data() as Map<String, dynamic>;
      final List<dynamic> addedUsersEmails = data['addedusers'] ?? [];
print(addedUsersEmails.length);
      // Fetch data for each user in 'addedusers'
      for (var email in addedUsersEmails) {
        final userSnapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(email)
            .get();

        if (userSnapshot.exists) {
          usersData.add(userSnapshot.data() as Map<String, dynamic>);
        }
      }

      setState(() {}); // Update the UI after fetching user data
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Ambassdor")
            .doc(widget.useremail)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userdataperson =
                snapshot.data!.data() as Map<String, dynamic>;
double initialRating = 0.0;
if (userdataperson['rating'] is List && userdataperson['rating'].isNotEmpty) {
  final ratings = userdataperson['rating'] as List;
  initialRating = ratings.reduce((a, b) => a + b) / ratings.length;
}

            return Scaffold(
                                                        appBar: AppBar(
            toolbarHeight:height/400,
            foregroundColor: const Color.fromARGB(255, 255, 255, 255),
            automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          surfaceTintColor:const Color.fromARGB(255, 255, 255, 255),
          ),
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              body: Container(
                height: height,
                width: width,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: height / 60,
                          right: width / 20,
                          left: width / 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: height / 10,
                                width: width / 10,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 1, color: Colors.black)),
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color: Color.fromARGB(255, 121, 5, 245),
                                    )),
                              ),
                              Expanded(
                                child: Center(
                                    child: Text(
                                  "Profile",
                                  style: TextStyle(
                                      color:
                                          const Color.fromARGB(255, 0, 0, 0),
                                      fontFamily: "defaultfontsbold",
                                      fontSize: 20),
                                )),
                              ),
                              SizedBox(width: width/15,)
                              // GestureDetector(
                                  // onTap: () {
                                    // Navigator.of(context)
                                        // .push(MaterialPageRoute(
                                      // builder: (context) {
                                        // return A_settingactivity();
                                      // },
                                    // ));
                                  // },
                                  // child: Image(
                                      // image: AssetImage(
                                          // "images/heroicons-outline_menu-alt-2.png")))
                            ],
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: height / 30),
                              child: Container(
                                height: height / 5,
                                width: width / 2.5,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                          Color.fromARGB(255, 121, 5, 245)),
                                  shape: BoxShape.circle,
                                  color: const Color.fromARGB(
                                      255, 206, 206, 206),
                                ),
                                child: _image == userdataperson['profile_pic']
                                    ? Icon(
                                        Icons.person,
                                        color: const Color.fromARGB(
                                            255, 66, 66, 66),
                                        size: height / 15,
                                      )
                                    : Container(
                                        height: height / 6,
                                        width: width / 3,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  userdataperson[
                                                      "profile_pic"]),fit: BoxFit.cover),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height / 50,
                          ),
                          Center(
                              child: Text(
                            userdataperson['name'],
                            style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontFamily: "defaultfontsbold",
                                fontSize: 20),
                          )),
                          SizedBox(height: height/90,),
            
                                        RatingBar.builder(
                          initialRating: initialRating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: height / 30,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (newRating) {
                            setState(() {
                              rating = newRating;
                            });
                            saveRating(newRating);
                          },
                        ),
                          SizedBox(height: height/50,),
                          Expanded(
                            child: GridView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: usersData.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: width * 0.02,
                                mainAxisSpacing: height * 0.02,
                                childAspectRatio: 0.7,
                              ),
                              itemBuilder: (context, index) {
                                final user = usersData[index];
                                                      final String userEmail = user['email'];
            
                                       bool isOnline = false;
                   String lastSeen = "Last seen: N/A";
                   lastSeenhistory = "Last seen: N/A";
                   if (usersStatusDetails.containsKey(userEmail)) {
                     final userStatus = usersStatusDetails[userEmail];
                     isOnline = userStatus['status'] == 'online';
                     if (isOnline) {
                       lastSeen = "Online";
                       lastSeenhistory = "Online";
                       statecolour = const Color.fromARGB(255, 49, 255, 56);
                     } else {
                       var lastSeenDate = DateTime.fromMillisecondsSinceEpoch(
                 userStatus['lastSeen'])
             .toLocal();
                       lastSeen =
             "Last seen: ${DateFormat('MMM d, yyyy h:mm a').format(lastSeenDate)}";
                       lastSeenhistory = lastSeen;
                       statecolour = Colors.white;
                     }
                   }
                                return A_users(
            onlinecheck: lastSeen,
            statecolour: statecolour,
            profileimage: user['profile_pic'] ??
            "https://img.freepik.com/premium-vector/data-loading-icon-waiting-program-vector-image-file-upload_652575-219.jpg?w=740",
            name: user['name'].toString().toUpperCase(),
            distance: 300,
            location: user['Address'],
            startLatitude: user["X"],
            startLongitude: user["Y"],
            endLatitude: userdataperson["X"],
            endLongitude: userdataperson["Y"],
            age: user['Age'],
            height: user['height'],
            labels: user['Interest'],
            iconss: user["Icon"],
            imagecollection: user['images'],
            ID: user['email'],
            useremail: userdataperson['email'], languages:user['languages'], education: user['education'], description: user['description'],
                        );
                              },
                            ),
                          ),
                        ],
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
            return CircularProgressIndicator();
          }
        });
  }
  Future<void> saveRating(double rating) async {
  final ambassadorRef = FirebaseFirestore.instance.collection("Ambassdor").doc(widget.useremail);

  await ambassadorRef.update({
    "rating": FieldValue.arrayUnion([rating])  // Adds rating to an array
  });
}

}
