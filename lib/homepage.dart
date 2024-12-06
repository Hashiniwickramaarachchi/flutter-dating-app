import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/accountdelectionpage.dart';
import 'package:datingapp/block.dart';
import 'package:datingapp/bootmnavbar.dart';
import 'package:datingapp/deactivepage.dart';
import 'package:datingapp/filterpage.dart';
import 'package:datingapp/mainscreen.dart';
import 'package:datingapp/onlinecheck.dart';
import 'package:datingapp/person.dart'; // Make sure this import is added
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
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
  final curentuser = FirebaseAuth.instance.currentUser!;
  int currentIndex = 0;
  int swipeCount = 0;
  DateTime? lastSwipeTime;
  bool isPremium = false; // Fetch this from the user's profile
  int maxSwipes = 5; // Swipe limit for standard users,
  final SwiperController _swiperController = SwiperController();
  bool _isFirstText = true;
  List<Map<String, dynamic>> partnerData = []; // List to store user data

  @override
  void initState() {
    super.initState();
    _loadSwipeData();
fetchpartnerData();
    fetchUsersStatus();
    _onlineStatusService.updateUserStatus();
  }
Future<void> fetchpartnerData() async {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final ambassadorSnapshot = await FirebaseFirestore.instance
      .collection("users")
      .doc(currentUser.email)
      .get();

  if (ambassadorSnapshot.exists) {
    final data = ambassadorSnapshot.data() as Map<String, dynamic>;

    // Fetch the added users' emails
    final List<dynamic> addedUsersEmails = data['partners'] ?? [];

    // Fetch the list of blocked users
    final blockedSnapshot = await FirebaseFirestore.instance
        .collection("Blocked USers")
        .doc(currentUser.email)
        .get();

    List<String> blockedEmails = [];
    if (blockedSnapshot.exists) {
      final blockedData = blockedSnapshot.data() as Map<String, dynamic>?;
      if (blockedData != null && blockedData["This Id blocked Users"] != null) {
        blockedEmails = List<String>.from(blockedData["This Id blocked Users"]);
      }
    }

    // Add users to the data list only if they are not blocked and are not the current user
    for (var email in addedUsersEmails) {
      // Skip if the user is blocked or if it's the current user's email
      if (blockedEmails.contains(email) || email == currentUser.email) {
        continue;
      }

      final userSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(email)
          .get();
      
      if (userSnapshot.exists) {
        // Add to usersData if the user is not blocked and is not the current user
        partnerData.add(userSnapshot.data() as Map<String, dynamic>);
      }
    }

    setState(() {});
  }
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

  Future<void> _loadSwipeData() async {
    final userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(curentuser.email)
        .get();
    final userData = userDoc.data();
    if (userData != null) {
      setState(() {
        isPremium = userData["premium"] ?? false;
        swipeCount = userData["swipeCount"] ?? 0;
        lastSwipeTime = (userData["lastSwipeTime"] as Timestamp?)?.toDate();
      });
    }
    if (!isPremium) {
      maxSwipes = userData!.length;
    }
  }

  Future<void> _updateSwipeData() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(curentuser.email)
        .update({
      "swipeCount": swipeCount,
      "lastSwipeTime": lastSwipeTime,
    });
  }



  void _onSwipe(int newIndex) {
    // Debugging to track swipes
    print("Current index: $currentIndex");
    print("New index: $newIndex");

    // Prevent back swiping for non-premium users
    if (newIndex < currentIndex) {
      if (!isPremium) {
        print("Back swipe blocked for standard user.");
        // Revert back swipe
        Future.delayed(Duration(milliseconds: 100), () {
          _swiperController.move(currentIndex, animation: true);
        });
        return;
      }
    }

    // Handle forward swipe
    if (newIndex > currentIndex) {
      if (!_canSwipe() && isPremium) {
        print("Forward swipe blocked due to swipe limit.");
        // Revert forward swipe if limit reached
        Future.delayed(Duration(milliseconds: 100), () {
          _swiperController.move(currentIndex, animation: true);
        });
        _showLimitReachedMessage();
        return;
      }
    }

    // Allow swipe and update current index
    setState(() {
      currentIndex = newIndex;

      if (!isPremium) {
        swipeCount++;
        lastSwipeTime = DateTime.now();
        _updateSwipeData(); // Update Firestore with the new swipe data
      }
    });

    // Reset swipe count on first swipe of the day
    if (lastSwipeTime != null && _isFirstSwipeOfTheDay(lastSwipeTime!)) {
      _updateFirstSwipeTime();
    }
  }

  bool _isFirstSwipeOfTheDay(DateTime lastSwipe) {
    final now = DateTime.now();
    return lastSwipe.day != now.day;
  }

  void _updateFirstSwipeTime() async {
    // Update the first swipe time in Firestore to reset the swipe count
    await FirebaseFirestore.instance
        .collection("users")
        .doc(curentuser.email)
        .update({
      "swipeCount": 0,
      "lastSwipeTime": DateTime.now(),
    });
  }

  bool _canSwipe() {
    if (isPremium) return true; // Premium users can swipe without limits

    if (swipeCount >= maxSwipes) {
      final now = DateTime.now();
      if (lastSwipeTime != null &&
          now.difference(lastSwipeTime!).inHours >= 24) {
        // Reset swipe count after 24 hours
        setState(() {
          maxSwipes += 5;
          lastSwipeTime = DateTime.now(); // reset the last swipe time
        });
        return true; // Allow swiping again
      }
      return false; // Swipe limit reached
    }
    return true;
  }

  void _showLimitReachedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Swipe limit reached. Wait 24 hours to swipe again."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

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

             if (userdataperson['statusType'] == 'deactive') {
  WidgetsBinding.instance.addPostFrameCallback((_) async{
    if (mounted) {
                  await FirebaseAuth.instance.signOut();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => deactivepage()),
        (Route<dynamic> route) => false,
      );
    }
  });
}         if (userdataperson?['statusType'] == 'block') {
           WidgetsBinding.instance.addPostFrameCallback((_) async {
             if (mounted) {
               await FirebaseAuth.instance.signOut();
               Navigator.of(context).pushAndRemoveUntil(
                 MaterialPageRoute(builder: (context) => block()),
                 (Route<dynamic> route) => false,
               );
             }
           });
         }              if (userdataperson?['statusType'] == 'delete') {
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
            return Scaffold(
              appBar: AppBar(
                toolbarHeight: height / 400,
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                automaticallyImplyLeading: false,
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
              ),
              body: Container(
                color: Color.fromARGB(255, 255, 255, 255),
                height: height,
                width: width,
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: width / 20,
                        left: width / 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                        color: Color.fromARGB(255, 121, 5, 245),
                                      ),
                                      Text(
                                        userdataperson['Address'].toString() ??
                                            "",
                                        style: TextStyle(
                                            color: const Color(0xff26150F),
                                            fontFamily: "defaultfontsbold",
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
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color(0xffEDEDED)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.tune,
                                      color: Color.fromARGB(255, 121, 5, 245),
                                      size: height / 30,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (userdataperson['profile'] == 'premium') ...[
                            Padding(
                              padding:  EdgeInsets.only(top: 20),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                  ),
                                  backgroundColor: Color(0xff7905F5),
                                ),
                                onPressed: () {
                                  setState(() {
                                    
                                    _isFirstText = !_isFirstText;
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Text(
                                    _isFirstText ? "Ambassador Suggestions  >" : "<  Back To Home",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: "button",
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                          SizedBox(
                            height: height / 40,
                          ),
                         
                         _isFirstText ?
Expanded(
  child: FutureBuilder<DocumentSnapshot>(
    future: FirebaseFirestore.instance
        .collection("Blocked Users")
        .doc(curentuser.email)
        .get(),
    builder: (context, blockedSnapshot) {
      if (blockedSnapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (blockedSnapshot.hasError) {
        return Center(child: Text('Error fetching blocked users: ${blockedSnapshot.error}'));
      }

      // List to store blocked emails
      List<String> blockedEmails = [];
      if (blockedSnapshot.data != null) {
        final blockedData = blockedSnapshot.data!.data() as Map<String, dynamic>?;
        if (blockedData != null && blockedData["This Id blocked Users"] != null) {
          blockedEmails = List<String>.from(blockedData["This Id blocked Users"]);
        }
      }

      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, userSnapshot) {
          if (userSnapshot.hasError) {
            return Center(child: Text('Error: ${userSnapshot.error}'));
          }
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Get user data from Firestore
          final data = userSnapshot.data!.docs.where((doc) {
            final email = doc['email'] as String;
            return email != curentuser.email && !blockedEmails.contains(email);
          }).toList();

          if (data.isEmpty) {
            return Center(child: Text("No users available"));
          }

          // Manage swipe limits and timing
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(curentuser.email)
                .get(),
            builder: (context, userProfileSnapshot) {
              if (userProfileSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (userProfileSnapshot.hasError) {
                return Center(child: Text('Error fetching user profile: ${userProfileSnapshot.error}'));
              }

              final userProfile = userProfileSnapshot.data!.data() as Map<String, dynamic>;
              final swipeCount = userProfile?['swipeCount'] ?? 0;
              final lastSwipeTime = userProfile?['lastSwipeTime']?.toDate();
              final isPremium = userProfile?['profile'] == 'premium';

              // Calculate time difference
              final now = DateTime.now();
              final isTimeExceeded = lastSwipeTime != null && now.difference(lastSwipeTime).inHours >= 24;

              // Handle swipe limit (5 cards per day for non-premium users)
              if (!isPremium && swipeCount >= 5 && !isTimeExceeded) {
                
                return Center(child: Text("Swipe limit reached. Please try again in 24 hours."));
                
              }

              // Handle swipe logic when user is allowed to swipe
              return Padding(
                padding: EdgeInsets.only(bottom: height / 8),
                child: Swiper(
                  itemBuilder: (context, index) {
                    final user = data[index];
                    final String userEmail = user['email'];
                    bool isOnline = false;
                    String lastSeen = "Last seen: N/A";
                    Color stateColor = Colors.white;

                    if (usersStatusDetails.containsKey(userEmail)) {
                      final userStatus = usersStatusDetails[userEmail];
                      isOnline = userStatus['status'] == 'online';
                      if (isOnline) {
                        lastSeen = "Online";
                        stateColor = const Color.fromARGB(255, 49, 255, 56);
                      } else {
                        var lastSeenDate = DateTime.fromMillisecondsSinceEpoch(userStatus['lastSeen']).toLocal();
                        lastSeen = "Last seen: ${DateFormat('MMM d, yyyy h:mm a').format(lastSeenDate)}";
                        stateColor = Colors.white;
                      }
                    }

                    // Return the user card UI
                    return person(
                      onlinecheck: lastSeen,
                      statecolour: stateColor,
                      profileimage: user['profile_pic'] ?? "https://img.freepik.com/premium-vector/data-loading-icon",
                      name: user['name'].toString().toUpperCase(),
                      distance: 300,
                      location: user['Address'],
                      startLatitude: user["X"],
                      startLongitude: user["Y"],
                      endLatitude: userdataperson["X"],
                      endLongitude: userdataperson["Y"],
                      age:   int.parse(user['Age'].toString()),
                      height: user['height'],
                      labels: user['Interest'],
                      iconss: user["Icon"],
                      imagecollection: user['images'],
                      ID: user.id,
                      useremail: userdataperson['email'],
                      languages: user['languages'],
                      education: user['education'],
                      description: user['description'],
                    );
                  },
                  itemCount: data.length,
                  itemWidth: width - 30,
                  itemHeight: height / 1.5,
                  layout: SwiperLayout.TINDER,
                  loop: false,
                  autoplay: false,
                  scrollDirection: Axis.horizontal,
                  index: currentIndex,
                  axisDirection: AxisDirection.right,
              
              
              
              
              onIndexChanged: (index) async {
  if (!isPremium) {
    // Increment swipe count locally
    final updatedSwipeCount = swipeCount + 1;

    // Update Firestore asynchronously without waiting
    FirebaseFirestore.instance.collection('users').doc(curentuser.email).update({
      'swipeCount': updatedSwipeCount,
      'lastSwipeTime': DateTime.now(),
    }).catchError((error) {
      // Optionally log error or show a message if needed
      print('Error updating swipe count: $error');
    });
  }

  // Update current index state
  setState(() {
    currentIndex = index;
  });
},

              
              
              

              
              
              
              
                ),
              );
            },
          );
        },
      );
    },
  ),
):

                                  Expanded(child: 
                                  
                                                                         Padding(
                                         padding: EdgeInsets.only(
                                             bottom: height / 8),
                                         child: Swiper(
                                           itemBuilder: (context, index) {
                                             final user = partnerData[index];
                                             final String userEmail =
                                                 user['email'];
                                             bool isOnline = false;
                                             String lastSeen =
                                                 "Last seen: N/A";
                                             Color stateColor = Colors.white;
                                             if (usersStatusDetails
                                                 .containsKey(userEmail)) {
                                               final userStatus =
                                                   usersStatusDetails[
                                                       userEmail];
                                               isOnline =
                                                   userStatus['status'] ==
                                                       'online';
                                               if (isOnline) {
                                                 lastSeen = "Online";
                                                 stateColor =
                                                     const Color.fromARGB(
                                                         255, 49, 255, 56);
                                               } else {
                                                 var lastSeenDate = DateTime
                                                     .fromMillisecondsSinceEpoch(
                                                   userStatus['lastSeen'],
                                                 ).toLocal();
                                                 lastSeen =
                                                     "Last seen: ${DateFormat('MMM d, yyyy h:mm a').format(lastSeenDate)}";
                                                 stateColor = Colors.white;
                                               }
                                             }
                                             return person(
                                               onlinecheck: lastSeen,
                                               statecolour: stateColor,
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
                                               age:  int.parse(user['Age'].toString()),
                                               height: user['height'],
                                               labels: user['Interest'],
                                               iconss: user["Icon"],
                                               imagecollection: user['images'],
                                               ID: user['email'],
                                               useremail:
                                                   userdataperson['email'],
                                               languages: user['languages'],
                                               education: user['education'],
                                               description:
                                                   user['description'],
                                             );
                                           },
                                           itemCount: partnerData.length,
                                           itemWidth: width - 30,
                                           itemHeight: height / 1.5,
                                           layout: SwiperLayout.TINDER,
                                           loop: false,
                                           autoplay: false,
                                           scrollDirection: Axis.horizontal,
                                           axisDirection: AxisDirection.right,
                                          
                                          
                                         ),
                                       )
                                  
                                  )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
