import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:datingapp/accountdelectionpage.dart';
import 'package:datingapp/ambassdor/bottombar.dart';
import 'package:datingapp/ambassdor/filterpage.dart';
import 'package:datingapp/ambassdor/olduser/signinperson.dart';
import 'package:datingapp/ambassdor/onlinecheck.dart';
import 'package:datingapp/ambassdor/person.dart';
import 'package:datingapp/block.dart';
import 'package:datingapp/bootmnavbar.dart';
import 'package:datingapp/deactivepage.dart';
import 'package:datingapp/onlinecheck.dart';
import 'package:datingapp/person.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class showsigninresult extends StatefulWidget {
  final double userLatitude;
  final double userLongitude;
  final String useremail;

  const showsigninresult({
    Key? key,
    required this.userLatitude,
    required this.userLongitude,
    required this.useremail,
  }) : super(key: key);

  @override
  _showsigninresultState createState() => _showsigninresultState();
}

class _showsigninresultState extends State<showsigninresult> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  List<Map<String, dynamic>> filteredUsers = []; // List to hold filtered users
  Map<String, bool> favStatus = {}; // Map to track favorite status by email
  final A_OnlineStatusService _onlineStatusService = A_OnlineStatusService();
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  Map<String, dynamic> usersStatusDetails = {}; // Change from List to Map
  List<Map<String, dynamic>> allUsers =
      []; // List to store all users before filtering
  bool isLoading = true; // Track loading state
  int loadedUsers = 0; // Counter for loaded users
  String lastSeenhistory = "Last seen: N/A";
  Color statecolour = Colors.white;
  TextEditingController _searchController = TextEditingController();

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

  Future<void> _getFilteredUsers() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .get(); // Fetch all users to filter manually

      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;

        // Check if all necessary fields exist

        double userDistance = _calculateDistance(
            widget.userLatitude, widget.userLongitude, data['X'], data['Y']);

        // Add filtered user to the list
        // filteredUsers.add({
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
        // 'education': data['education']
        // });
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
          "languages": data['languages'],
          'education': data['education'],
          'description': data['description']
        };
        allUsers.add(userInfo); // Add user to the full list

        favStatus[data['email']] = false;
        loadedUsers++;
        _checkIfLoadingComplete();
        // Get profile picture as marker with rounded border

        // Add marker to map
      }

      setState(() {
        filteredUsers = List.from(allUsers); // Initially show all users
      }); // Update the map with new markers
    } catch (e) {
      print('Error fetching filtered users: $e');
    }
  }

  void _checkIfLoadingComplete() {
    // Check if all users are loaded
    if (2 < loadedUsers) {
      setState(() {
        isLoading = false; // Stop loading when all users are loaded
      });
    }
  }

  double _convertToDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      return double.tryParse(value) ?? 0;
    }
    return 0;
  }

  Future<Uint8List> _getMarkerWithImage(String imageUrl) async {
    try {
      final http.Response response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        Uint8List imageData = response.bodyBytes;

        // Decode the image
        ui.Codec codec = await ui.instantiateImageCodec(imageData);
        ui.FrameInfo frameInfo = await codec.getNextFrame();
        ui.Image image = frameInfo.image;

        // Create a canvas to draw the rounded image with a border
        final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
        final Canvas canvas = Canvas(pictureRecorder);
        const double size = 150.0; // Adjust the size of the marker
        const double borderSize = 10.0; // Adjust the size of the purple border

        // Draw the purple border (circle)
        final Paint borderPaint = Paint()
          ..color = Color(0xff7905F5)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(
          Offset(size / 2, size / 2),
          size / 2,
          borderPaint,
        );

        // Draw the circular image inside the border
        final Rect imageRect = Rect.fromLTWH(borderSize, borderSize,
            size - borderSize * 2, size - borderSize * 2);
        final ui.Path clipPath = ui.Path()..addOval(imageRect);
        canvas.clipPath(clipPath);
        canvas.drawImageRect(
            image,
            Rect.fromLTWH(
                0, 0, image.width.toDouble(), image.height.toDouble()),
            imageRect,
            Paint());

        // Convert canvas to image
        final ui.Image markerAsImage = await pictureRecorder
            .endRecording()
            .toImage(size.toInt(), size.toInt());
        final ByteData? byteData =
            await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
        return byteData!.buffer.asUint8List();
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      print('Error loading image: $e');
      return Uint8List(0); // Return an empty list on error
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
    final User? curentuser = FirebaseAuth.instance.currentUser;

    if (curentuser == null) {
      // Handle unauthenticated user state (e.g., redirect to login page or s
      return Center(child: Text('No user is logged in.'));
    }

    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Ambassdor")
            .doc(curentuser.email)
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
                  top: height / 70,
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
                            Expanded(
                              child: Container(
                                height: height / 18, // Set height as needed
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: width / 20,
                                          vertical: height /
                                              60 // Adjust padding as needed
                                          ),
                                      hintText: "Search",
                                      border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff8F9DA6)),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                              color: Color(0xff8F9DA6)))),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width / 30,
                            ),
                            GestureDetector(
                              onTap: () async {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(50),
                                      topRight: Radius.circular(50),
                                    ),
                                  ),
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) {
                                    return A_filterpage();
                                  },
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xffEDEDED),
                                ),
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
                        SizedBox(
                          height: height / 30,
                        ),
                        isLoading
                            ? Center(child: CircularProgressIndicator())
                            : Expanded(
                                child: ListView.builder(
                                itemCount: filteredUsers.length,
                                itemBuilder: (context, index) {
                                  final user = filteredUsers[index];
                                  final String userEmail = user['email'];
                                  bool isOnline = false;
                                  String lastSeen = "Last seen: N/A";
                                  lastSeenhistory = "Last seen: N/A";
                                  if (usersStatusDetails
                                      .containsKey(userEmail)) {
                                    final userStatus =
                                        usersStatusDetails[userEmail];
                                    isOnline = userStatus['status'] == 'online';
                                    if (isOnline) {
                                      lastSeen = "Online";
                                      lastSeenhistory = "Online";
                                      statecolour = const Color.fromARGB(
                                          255, 49, 255, 56);
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
                                  return Padding(
                                    padding:
                                        EdgeInsets.only(bottom: height / 50),
                                    child: Container(
                                      height: height / 1.8,
                                      width: double.infinity,
                                      child: signinperson(
                                        onlinecheck: lastSeen,
                                        statecolour: statecolour,
                                        profileimage: user['profile_pic'] ??
                                            "https://img.freepik.com/premium-vector/data-loading-icon-waiting-program-vector-image-file-upload_652575-219.jpg?w=740",
                                        name: user['name']
                                            .toString()
                                            .toUpperCase(),
                                        distance: 300,
                                        location: user['Address'],
                                        startLatitude: user["X"],
                                        startLongitude: user["Y"],
                                        endLatitude: widget.userLatitude,
                                        endLongitude: widget.userLongitude,
                                        age: int.parse(user['Age'].toString()),
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
                        SizedBox(
                          height: height / 10,
                        )
                      ],
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
        });
  }
}
