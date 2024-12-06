import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:datingapp/ambassdor/bottombar.dart';
import 'package:datingapp/ambassdor/filterpage.dart';
import 'package:datingapp/ambassdor/olduser/signinperson.dart';
import 'package:datingapp/ambassdor/onlinecheck.dart';
import 'package:datingapp/ambassdor/person.dart';
import 'package:datingapp/bootmnavbar.dart';
import 'package:datingapp/onlinecheck.dart';
import 'package:datingapp/person.dart';
import 'package:datingapp/premium/premiumperson.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class allpremium extends StatefulWidget {
  final double userLatitude;
  final double userLongitude;
  final String useremail;

  const allpremium({
    Key? key,
    required this.userLatitude,
    required this.userLongitude,
    required this.useremail,
  }) : super(key: key);

  @override
  _allpremiumState createState() => _allpremiumState();
}

class _allpremiumState extends State<allpremium> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  List<Map<String, dynamic>> filteredUsers = []; // List to hold filtered users
  Map<String, bool> favStatus = {}; // Map to track favorite status by email
  final OnlineStatusService _onlineStatusService = OnlineStatusService();
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  Map<String, dynamic> usersStatusDetails = {}; // Change from List to Map
  List<Map<String, dynamic>> allUsers =
      []; // List to store all users before filtering

  String lastSeenhistory = "Last seen: N/A";
  Color statecolour = Colors.white;
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = true; // Loading flag

  @override
  void initState() {
    super.initState();
    _getFilteredUsers();
    fetchUsersStatus();
    _searchController.addListener(_applySearchFilter);
  }

  @override
  void dispose() {
    // Call this when the app is closed
    _onlineStatusService.setUserOffline();
    _searchController.removeListener(_applySearchFilter);
    _searchController.dispose();
    super.dispose();
  }

  void _applySearchFilter() {
    String searchQuery = _searchController.text.toLowerCase();

    setState(() {
      if (searchQuery.isEmpty) {
        filteredUsers =
            List.from(allUsers); // Show all users if search is empty
      } else {
        filteredUsers = allUsers.where((user) {
          String name = user['name'].toString().toLowerCase();
          return name
              .contains(searchQuery); // Filter users based on the search query
        }).toList();
      }
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

  // Future<void> _getFilteredUsers() async {
    // try {
      // QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          // .collection('users')
          // .get(); // Fetch all users to filter manually
// 
      // for (var doc in querySnapshot.docs) {
        // var data = doc.data() as Map<String, dynamic>;
// 
        // if (data['profile'] == 'premium' && data['email'] != widget.useremail) {
          // double userDistance = _calculateDistance(
              // widget.userLatitude, widget.userLongitude, data['X'], data['Y']);
// 
          // Map<String, dynamic> userInfo = {
            // 'name': data['name'],
            // 'Age': data['Age'],
            // 'distance': userDistance.toInt(),
            // 'profile_pic': data['profile_pic'],
            // 'X': data['X'],
            // 'Y': data['Y'],
            // 'Address': data['Address'],
            // 'email': data['email'],
            // 'Gender': data['Gender'],
            // 'Icon': data['Icon'],
            // 'Interest': data['Interest'],
            // 'Phonenumber': data['Phonenumber'],
            // 'images': data['images'],
            // 'height': data['height'],
            // "languages": data['languages'],
            // 'education': data['education'],
            // 'description': data['description']
          // };
          // allUsers.add(userInfo); // Add user to the full list
// 
          // favStatus[data['email']] = false;
// 
          // Uint8List markerIcon = await _getMarkerWithImage(data['profile_pic']);
// 
        // } else {
          // print('No user');
        // }
      // }
// 
      // setState(() {
        // filteredUsers = List.from(allUsers); // Initially show all users
                // _isLoading = false; // Update loading state
// 
      // }); // Update the map with new markers
    // } catch (e) {
      // print('Error fetching filtered users: $e');
      // setState(() {
                // _isLoading = false;
// 
      // });
    // }
  // }

// Future<void> _getFilteredUsers() async {
  // try {
    // DocumentSnapshot blockedUsersSnapshot = await FirebaseFirestore.instance
        // .collection('Blocked USers')
        // .doc(widget.useremail)
        // .get();
// 
    // List<String> blockedEmails = [];
    // if (blockedUsersSnapshot.exists) {
      // final blockedData = blockedUsersSnapshot.data() as Map<String, dynamic>?;
      // if (blockedData != null && blockedData['This Id blocked Users'] != null) {
        // blockedEmails = List<String>.from(blockedData['This Id blocked Users']);
      // }
    // }
// 
    // QuerySnapshot querySnapshot =
        // await FirebaseFirestore.instance.collection('users').get();
// 
    // for (var doc in querySnapshot.docs) {
      // var data = doc.data() as Map<String, dynamic>;
// 
      // if (data['email'] != widget.useremail &&
          // data['profile'] == 'premium' &&
          // !blockedEmails.contains(data['email'])) {
        // double userDistance = _calculateDistance(
            // widget.userLatitude, widget.userLongitude, data['X'], data['Y']);
// 
        // Map<String, dynamic> userInfo = {
          // 'name': data['name'],
          // 'Age': data['Age'],
          // 'distance': userDistance.toInt(),
          // 'profile_pic': data['profile_pic'],
          // 'X': data['X'],
          // 'Y': data['Y'],
          // 'Address': data['Address'],
          // 'email': data['email'],
          // 'Gender': data['Gender'],
          // 'Icon': data['Icon'],
          // 'Interest': data['Interest'],
          // 'Phonenumber': data['Phonenumber'],
          // 'images': data['images'],
          // 'height': data['height'],
          // 'languages': data['languages'],
          // 'education': data['education'],
          // 'description': data['description']
        // };
// 
        // allUsers.add(userInfo); // Add user to the full list
        // favStatus[data['email']] = false;
// 
       
// 
       
       
      // }
    // }
// 
    // setState(() {
      // filteredUsers = List.from(allUsers); // Initially show all users
      // _isLoading = false; // Update loading state
    // });
  // } catch (e) {
    // print('Error fetching filtered users: $e');
    // setState(() {
      // _isLoading = false;
    // });
  // }
// }
// 
  Future<void> _getFilteredUsers() async {
    try {
      // Fetch blocked users
      final blockedSnapshot = await FirebaseFirestore.instance
          .collection('Blocked USers')
          .doc(widget.useremail)
          .get();
      List<String> blockedEmails = [];
      if (blockedSnapshot.exists) {
        final blockedData = blockedSnapshot.data() as Map?;
        blockedEmails = List<String>.from(blockedData?['This Id blocked Users'] ?? []);
      }

      // Fetch all users with the premium profile
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
      List<Map<String, dynamic>> tempUsers = [];

      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;

        if (data['email'] != widget.useremail &&
            data['profile'] == 'premium' &&
            !blockedEmails.contains(data['email'])) {

          double userDistance = _calculateDistance(
            widget.userLatitude, widget.userLongitude, data['X'], data['Y']);

          Map<String, dynamic> userInfo = {
            'name': data['name'],
            'Age': data['Age'],
            'distance': userDistance.toInt(),
            'profile_pic': data['profile_pic'],
            'X': data['X'],
            'Y': data['Y'],
            'Address': data['Address'],
            'email': data['email'],
            'Gender': data['Gender'],
            'Icon': data['Icon'],
            'Interest': data['Interest'],
            'Phonenumber': data['Phonenumber'],
            'images': data['images'],
            'height': data['height'],
            'languages': data['languages'],
            'education': data['education'],
            'description': data['description']
          };
          tempUsers.add(userInfo);
          favStatus[data['email']] = false;
        }
      }

      setState(() {
        allUsers = tempUsers;
        filteredUsers = List.from(allUsers);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching filtered users: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  double _calculateDistance(
      double startLat, double startLng, double endLat, double endLng) {
    double distanceInMeters =
        Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
    return distanceInMeters / 1000; // Convert meters to kilometers
  }

  bool fav = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    print(widget.userLatitude);
    print(widget.useremail);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        toolbarHeight: height / 400,
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: width / 20,
          right: width / 20,
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: height / 10,
                      width: width / 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 1,
                          color: Colors.black,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: const Color.fromARGB(255, 121, 5, 245),
                        ),
                      ),
                    ),
                    SizedBox(width: width / 20),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Premium Members",
                          style: TextStyle(
                              color: const Color(0xff26150F),
                              fontFamily: "defaultfontsbold",
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(width: width / 15),
                  ],
                ),
                SizedBox(
                  height: height / 60,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: height / 18, // Set height as needed
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: Theme.of(context).textTheme.headlineSmall,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: width / 20,
                                  vertical:
                                      height / 60 // Adjust padding as needed
                                  ),
                              hintText: "Search",
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff8F9DA6)),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide:
                                      BorderSide(color: Color(0xff8F9DA6)))),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width / 30,
                    ),
                  ],
                ),
                SizedBox(
                  height: height / 20,
                ),
          _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            ):
                Expanded(
                    child: ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
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
                    return Padding(
                      padding: EdgeInsets.only(bottom: height / 30),
                      child: Container(
                        height: height / 15,
                        width: double.infinity,
                        child: premiumperson(
                          onlinecheck: lastSeen,
                          statecolour: statecolour,
                          profileimage: user['profile_pic'] ??
           "https://img.freepik.com/premium-vector/data-loading-icon-waiting-program-vector-image-file-upload_652575-219.jpg?w=740",
                          name: user['name'].toString().toUpperCase(),
                          distance: 300,
                          location: user['Address'],
                          startLatitude: user["X"],
                          startLongitude: user["Y"],
                          endLatitude: widget.userLatitude,
                          endLongitude: widget.userLongitude,
                          age: user['Age'],
                          height: user['height'],
                          labels: user['Interest'],
                          iconss: user["Icon"],
                          imagecollection: user['images'],
                          ID: user['email'],
                          useremail: widget.useremail,
                          gender: user['Gender'],
                          languages: user['languages'],
                          education: user['education'],
                          description: user['description'],
                        ),
                      ),
                    );
                  },
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
