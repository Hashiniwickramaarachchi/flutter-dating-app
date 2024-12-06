import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/accountdelectionpage.dart';
import 'package:datingapp/block.dart';
import 'package:datingapp/bootmnavbar.dart';
import 'package:datingapp/deactivepage.dart';
import 'package:datingapp/favcontainer.dart';
import 'package:datingapp/onlinusers.dart';
import 'package:datingapp/person.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class fav extends StatefulWidget {
  const fav({super.key});

  @override
  State<fav> createState() => _favState();
}

class _favState extends State<fav> with SingleTickerProviderStateMixin {
  late TabController _tabController; // Declare late variable
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  Map<String, dynamic> usersStatusDetails = {};
  String lastSeenhistory = "Last seen: N/A";
  Color statecolour = Colors.white;

  @override
  void initState() {
    super.initState();
    fetchUsersStatus();
    // Initialize TabController
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Update the UI when the tab changes
    });
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

  double calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    double distanceInMeters = Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
    // Convert meters to kilometers
    double distanceInKilometers = distanceInMeters / 1000;
    return distanceInKilometers;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final User? curentuser = FirebaseAuth.instance.currentUser;

    if (curentuser == null) {
      // Handle unauthenticated user state (e.g., redirect to login page or show an error message)
      return Center(child: Text('No user is logged in.'));
    }
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(curentuser.email!)
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
         }            if (userdataperson?['statusType'] == 'delete') {
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
              appBar: AppBar(
                toolbarHeight: height / 400,
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                automaticallyImplyLeading: false,
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
              ),
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              body: Padding(
                padding: EdgeInsets.only(
                  right: width / 20,
                  left: width / 20,
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Text(
                          "Favourites",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontFamily: "defaultfontsbold",
                              fontSize: 20),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: height / 30),
                                child: Container(
                                  height: height / 20,
                                  color: Colors.transparent,
                                  child: TabBar(
                                    dividerColor: Colors.transparent,
                                    controller: _tabController,
                                    labelColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    unselectedLabelColor:
                                        const Color.fromARGB(255, 0, 0, 0),
                                    labelStyle: TextStyle(
                                      fontSize: height / 50,
                                    ),
                                    indicator: BoxDecoration(
                                      color: Color(
                                          0xff7905F5), // Selected tab background color
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    indicatorSize: TabBarIndicatorSize.label,
                                    indicatorPadding: EdgeInsets.zero,
                                    labelPadding:
                                        EdgeInsets.only(left: 5, right: 5),
                                    tabs: [
                                      Tab(
                                        child: Container(
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: _tabController.index == 0
                                                ? Color(0xff7905F5)
                                                : Color(
                                                    0xffCAC7C7), // Unselected background
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Text(
                                            "All",
                                            style: TextStyle(
                                                fontFamily: "defaultfonts",
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      Tab(
                                        child: Container(
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: _tabController.index == 1
                                                ? Color(
                                                    0xff7905F5) // Selected background
                                                : Colors
                                                    .grey, // Unselected background
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Text(
                                            "Online",
                                            style: TextStyle(
                                                fontFamily: "defaultfonts",
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      Tab(
                                        child: Container(
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: _tabController.index == 2
                                                ? Color(
                                                    0xff7905F5) // Selected background
                                                : Colors
                                                    .grey, // Unselected background
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Text(
                                            "Nearest",
                                            style: TextStyle(
                                                fontFamily: "defaultfonts",
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      Tab(
                                        child: Container(
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: _tabController.index == 3
                                                ? Color(
                                                    0xff7905F5) // Selected background
                                                : Colors
                                                    .grey, // Unselected background
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Text(
                                            "Newest",
                                            style: TextStyle(
                                                fontFamily: "defaultfonts",
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color: Colors.white,
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: width / 40,
                                            right: width / 40,
                                            top: height / 20),
                                        child: StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection("Favourite")
                                                .doc(curentuser.email!)
                                                .collection('fav1')
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
                                                    child:
                                                        CircularProgressIndicator());
                                              }
                                              final data = snapshot.data!.docs;

                                              return FutureBuilder<
                                                      DocumentSnapshot>(
                                                  future: FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                          'Blocked USers')
                                                      .doc(curentuser.email!)
                                                      .get(),
                                                  builder: (context,
                                                      blockedSnapshot) {
                                                    if (blockedSnapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    }

                                                    List<String> blockedEmails =
                                                        [];
                                                    if (blockedSnapshot
                                                            .hasData &&
                                                        blockedSnapshot
                                                            .data!.exists) {
                                                      final blockedData =
                                                          blockedSnapshot.data!
                                                                  .data()
                                                              as Map<String,
                                                                  dynamic>?;
                                                      if (blockedData != null &&
                                                          blockedData[
                                                                  'This Id blocked Users'] !=
                                                              null) {
                                                        blockedEmails = List<
                                                                String>.from(
                                                            blockedData[
                                                                'This Id blocked Users']);
                                                      }
                                                    }

                                                    // Filter out blocked users
                                                    final filteredData =
                                                        data.where((doc) {
                                                      final userEmail =
                                                          doc['email'];
                                                      return !blockedEmails
                                                          .contains(userEmail);
                                                    }).toList();

                                                    if (filteredData.isEmpty) {
                                                      return Center(
                                                          child: Text(
                                                              'No favorite users to display'));
                                                    }

                                                    return GridView.builder(
                                                      physics: ScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          filteredData.length,
                                                      gridDelegate:
                                                          SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 2,
                                                        crossAxisSpacing:
                                                            width * 0.02,
                                                        mainAxisSpacing:
                                                            height * 0.02,
                                                        childAspectRatio: 0.8,
                                                      ),
                                                      itemBuilder:
                                                          (context, index) {
                                                        final user =
                                                            data[index];
                                                        final String userEmail =
                                                            user['email'];
                                                        // Fetch the status for this specific user
                                                        bool isOnline = false;
                                                        String lastSeen =
                                                            "Last seen: N/A";
                                                        lastSeenhistory =
                                                            "Last seen: N/A";
                                                        if (usersStatusDetails
                                                            .containsKey(
                                                                userEmail)) {
                                                          final userStatus =
                                                              usersStatusDetails[
                                                                  userEmail];
                                                          isOnline = userStatus[
                                                                  'status'] ==
                                                              'online';
                                                          if (isOnline) {
                                                            lastSeen = "Online";
                                                            lastSeenhistory =
                                                                "Online";
                                                            statecolour =
                                                                const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    49,
                                                                    255,
                                                                    56);
                                                          } else {
                                                            var lastSeenDate =
                                                                DateTime.fromMillisecondsSinceEpoch(
                                                                        userStatus[
                                                                            'lastSeen'])
                                                                    .toLocal();
                                                            lastSeen =
                                                                "Last seen: ${DateFormat('MMM d, yyyy h:mm a').format(lastSeenDate)}";
                                                            lastSeenhistory =
                                                                lastSeen;
                                                            statecolour =
                                                                Colors.white;
                                                          }
                                                        }
                                                        return Container(
                                                          child: favcontainer(
                                                            profileimage: data[
                                                                        index][
                                                                    'profile_pic'] ??
                                                                "https://img.freepik.com/premium-vector/data-loading-icon-waiting-program-vector-image-file-upload_652575-219.jpg?w=740",
                                                            name: data[index]
                                                                ['name'],
                                                            distance: calculateDistance(
                                                                data[index]
                                                                    ["X"],
                                                                data[index]
                                                                    ["Y"],
                                                                userdataperson[
                                                                    "X"],
                                                                userdataperson[
                                                                    "Y"]),
                                                            location:
                                                                data[index]
                                                                    ['Address'],
                                                            startLatitude:
                                                                data[index]
                                                                    ["X"],
                                                            startLongitude:
                                                                data[index]
                                                                    ["Y"],
                                                            endLatitude:
                                                                userdataperson[
                                                                    "X"],
                                                            endLongitude:
                                                                userdataperson[
                                                                    "Y"],
                                                            age: data[index]
                                                                ['Age'],
                                                            height: data[index][
                                                                    'height'] ??
                                                                "",
                                                            labels: data[index]
                                                                ['Interest'],
                                                            iconss: data[index]
                                                                ["Icon"],
                                                            imagecollection:
                                                                data[index]
                                                                    ['images'],
                                                            ID: data[index].id,
                                                            useremail:
                                                                userdataperson[
                                                                    'email'],
                                                            onlinecheck:
                                                                lastSeen,
                                                            statecolour:
                                                                statecolour,
                                                            education: data[
                                                                    index]
                                                                ['education'],
                                                            languages: data[
                                                                    index]
                                                                ['languages'],
                                                            description: data[
                                                                    index]
                                                                ['description'],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  });
                                            }),
                                      ),
                                      OnlineUsersPage(),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: width / 40,
                                            right: width / 40,
                                            top: height / 20),
                                        child: StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection("Favourite")
                                              .doc(curentuser.email!)
                                              .collection('fav1')
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError) {
                                              return Center(
                                                child: Text(
                                                    'Error: ${snapshot.error}'),
                                              );
                                            }
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }

                                            final data = snapshot.data!.docs;

                                            return FutureBuilder<
                                                DocumentSnapshot>(
                                              future: FirebaseFirestore.instance
                                                  .collection('Blocked USers')
                                                  .doc(curentuser.email!)
                                                  .get(),
                                              builder:
                                                  (context, blockedSnapshot) {
                                                if (blockedSnapshot
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                }

                                                List<String> blockedEmails = [];
                                                if (blockedSnapshot.hasData &&
                                                    blockedSnapshot
                                                        .data!.exists) {
                                                  final blockedData =
                                                      blockedSnapshot.data!
                                                              .data()
                                                          as Map<String,
                                                              dynamic>?;
                                                  if (blockedData != null &&
                                                      blockedData[
                                                              'This Id blocked Users'] !=
                                                          null) {
                                                    blockedEmails = List<
                                                            String>.from(
                                                        blockedData[
                                                            'This Id blocked Users']);
                                                  }
                                                }

                                                // Filter users by distance and exclude blocked users
                                                final filteredData =
                                                    data.where((user) {
                                                  final String userEmail =
                                                      user['email'];
                                                  if (blockedEmails
                                                      .contains(userEmail)) {
                                                    return false; // Exclude blocked users
                                                  }

                                                  double userDistance =
                                                      calculateDistance(
                                                    user["X"],
                                                    user["Y"],
                                                    userdataperson["X"],
                                                    userdataperson["Y"],
                                                  );
                                                  return userDistance >= 0 &&
                                                      userDistance <= 100;
                                                }).toList();

                                                if (filteredData.isEmpty) {
                                                  return Center(
                                                      child: Text(
                                                          'No favorite users to display'));
                                                }

                                                return GridView.builder(
                                                  physics: ScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      filteredData.length,
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    crossAxisSpacing:
                                                        width * 0.02,
                                                    mainAxisSpacing:
                                                        height * 0.02,
                                                    childAspectRatio: 0.8,
                                                  ),
                                                  itemBuilder:
                                                      (context, index) {
                                                    final user =
                                                        filteredData[index];
                                                    final String userEmail =
                                                        user['email'];

                                                    bool isOnline = false;
                                                    String lastSeen =
                                                        "Last seen: N/A";
                                                    if (usersStatusDetails
                                                        .containsKey(
                                                            userEmail)) {
                                                      final userStatus =
                                                          usersStatusDetails[
                                                              userEmail];
                                                      isOnline = userStatus[
                                                              'status'] ==
                                                          'online';
                                                      if (isOnline) {
                                                        lastSeen = "Online";
                                                        statecolour =
                                                            const Color
                                                                .fromARGB(255,
                                                                49, 255, 56);
                                                      } else {
                                                        var lastSeenDate = DateTime
                                                                .fromMillisecondsSinceEpoch(
                                                                    userStatus[
                                                                        'lastSeen'])
                                                            .toLocal();
                                                        lastSeen =
                                                            "Last seen: ${DateFormat('MMM d, yyyy h:mm a').format(lastSeenDate)}";
                                                        statecolour =
                                                            Colors.white;
                                                      }
                                                    }

                                                    return Container(
                                                      child: favcontainer(
                                                        profileimage: user[
                                                                'profile_pic'] ??
                                                            "https://img.freepik.com/premium-vector/data-loading-icon-waiting-program-vector-image-file-upload_652575-219.jpg",
                                                        name: user['name'],
                                                        distance:
                                                            calculateDistance(
                                                          user["X"],
                                                          user["Y"],
                                                          userdataperson["X"],
                                                          userdataperson["Y"],
                                                        ),
                                                        location:
                                                            user['Address'],
                                                        startLatitude:
                                                            user["X"],
                                                        startLongitude:
                                                            user["Y"],
                                                        endLatitude:
                                                            userdataperson["X"],
                                                        endLongitude:
                                                            userdataperson["Y"],
                                                        age: user['Age'],
                                                        height:
                                                            user['height'] ??
                                                                "",
                                                        labels:
                                                            user['Interest'],
                                                        iconss: user["Icon"],
                                                        imagecollection:
                                                            user['images'],
                                                        ID: user.id,
                                                        useremail:
                                                            userdataperson[
                                                                'email'],
                                                        onlinecheck: lastSeen,
                                                        statecolour:
                                                            statecolour,
                                                        education:
                                                            user['education'],
                                                        languages:
                                                            user['languages'],
                                                        description:
                                                            user['description'],
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: width / 40,
                                            right: width / 40,
                                            top: height / 20),
                                        child: StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection("Favourite")
                                              .doc(curentuser.email!)
                                              .collection('fav1')
                                              .orderBy('created',
                                                  descending: true)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError) {
                                              return Center(
                                                child: Text(
                                                    'Error: ${snapshot.error}'),
                                              );
                                            }
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }

                                            final data = snapshot.data!.docs;

                                            return FutureBuilder<
                                                DocumentSnapshot>(
                                              future: FirebaseFirestore.instance
                                                  .collection('Blocked Users')
                                                  .doc(curentuser.email!)
                                                  .get(),
                                              builder:
                                                  (context, blockedSnapshot) {
                                                if (blockedSnapshot
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                }

                                                // Retrieve blocked users list
                                                List<String> blockedEmails = [];
                                                if (blockedSnapshot.hasData &&
                                                    blockedSnapshot
                                                        .data!.exists) {
                                                  final blockedData =
                                                      blockedSnapshot.data!
                                                              .data()
                                                          as Map<String,
                                                              dynamic>?;
                                                  if (blockedData != null &&
                                                      blockedData[
                                                              'This Id blocked Users'] !=
                                                          null) {
                                                    blockedEmails = List<
                                                            String>.from(
                                                        blockedData[
                                                            'This Id blocked Users']);
                                                  }
                                                }

                                                // Filter out blocked users
                                                final filteredData =
                                                    data.where((user) {
                                                  final String userEmail =
                                                      user['email'];
                                                  return !blockedEmails
                                                      .contains(userEmail);
                                                }).toList();

                                                if (filteredData.isEmpty) {
                                                  return Center(
                                                      child: Text(
                                                          'No favorite users to display.'));
                                                }

                                                return GridView.builder(
                                                  physics: ScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      filteredData.length,
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    crossAxisSpacing:
                                                        width * 0.02,
                                                    mainAxisSpacing:
                                                        height * 0.02,
                                                    childAspectRatio: 0.8,
                                                  ),
                                                  itemBuilder:
                                                      (context, index) {
                                                    final user =
                                                        filteredData[index];
                                                    final String userEmail =
                                                        user['email'];

                                                    bool isOnline = false;
                                                    String lastSeen =
                                                        "Last seen: N/A";
                                                    if (usersStatusDetails
                                                        .containsKey(
                                                            userEmail)) {
                                                      final userStatus =
                                                          usersStatusDetails[
                                                              userEmail];
                                                      isOnline = userStatus[
                                                              'status'] ==
                                                          'online';
                                                      if (isOnline) {
                                                        lastSeen = "Online";
                                                        statecolour =
                                                            const Color
                                                                .fromARGB(255,
                                                                49, 255, 56);
                                                      } else {
                                                        var lastSeenDate = DateTime
                                                                .fromMillisecondsSinceEpoch(
                                                                    userStatus[
                                                                        'lastSeen'])
                                                            .toLocal();
                                                        lastSeen =
                                                            "Last seen: ${DateFormat('MMM d, yyyy h:mm a').format(lastSeenDate)}";
                                                        statecolour =
                                                            Colors.white;
                                                      }
                                                    }

                                                    return Container(
                                                      child: favcontainer(
                                                        profileimage: user[
                                                                'profile_pic'] ??
                                                            "https://img.freepik.com/premium-vector/data-loading-icon-waiting-program-vector-image-file-upload_652575-219.jpg?w=740",
                                                        name: user['name'],
                                                        distance:
                                                            calculateDistance(
                                                          user["X"],
                                                          user["Y"],
                                                          userdataperson["X"],
                                                          userdataperson["Y"],
                                                        ),
                                                        location:
                                                            user['Address'],
                                                        startLatitude:
                                                            user["X"],
                                                        startLongitude:
                                                            user["Y"],
                                                        endLatitude:
                                                            userdataperson["X"],
                                                        endLongitude:
                                                            userdataperson["Y"],
                                                        age: user['Age'],
                                                        height:
                                                            user['height'] ??
                                                                "",
                                                        labels:
                                                            user['Interest'],
                                                        iconss: user["Icon"],
                                                        imagecollection:
                                                            user['images'],
                                                        ID: user.id,
                                                        useremail:
                                                            userdataperson[
                                                                'email'],
                                                        onlinecheck: lastSeen,
                                                        statecolour:
                                                            statecolour,
                                                        education:
                                                            user['education'],
                                                        languages:
                                                            user['languages'],
                                                        description:
                                                            user['description'],
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
                              SizedBox(
                                height: height / 60,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),

                    //  Align(
                    // alignment: Alignment.bottomCenter,
                    // child: Padding(
                    // padding: EdgeInsets.only(bottom: height / 60),
                    // child: BottomNavBar(
                    // selectedIndex2: 2,
                    // ),
                    // ),
                    // )
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
}
