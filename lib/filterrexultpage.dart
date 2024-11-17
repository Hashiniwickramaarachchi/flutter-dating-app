import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:datingapp/bootmnavbar.dart';
import 'package:datingapp/mainscreen.dart';
import 'package:datingapp/onlinecheck.dart';
import 'package:datingapp/viewpage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class FilterResultsMapPage extends StatefulWidget {
  final int selectedGender;
  final Set<String> selectedInterests;
  final RangeValues ageRange;
  final RangeValues distanceRange;
  final double userLatitude;
  final double userLongitude;
  final String useremail;

  const FilterResultsMapPage({
    Key? key,
    required this.selectedGender,
    required this.selectedInterests,
    required this.ageRange,
    required this.distanceRange,
    required this.userLatitude,
    required this.userLongitude,
    required this.useremail,
  }) : super(key: key);

  @override
  _FilterResultsMapPageState createState() => _FilterResultsMapPageState();
}

class _FilterResultsMapPageState extends State<FilterResultsMapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  List<Map<String, dynamic>> filteredUsers = []; // List to hold filtered users
  Map<String, bool> favStatus = {}; // Map to track favorite status by email
  final OnlineStatusService _onlineStatusService = OnlineStatusService();
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  Map<String, dynamic> usersStatusDetails = {}; // Change from List to Map
  String lastSeenhistory = "Last seen: N/A";
  Color statecolour = Colors.white;

  @override
  void initState() {
    super.initState();
    _getFilteredUsers();
    _addLoggedUserMarker();
    fetchUsersStatus();
    // Call this when the app starts or the user logs in
    _onlineStatusService.updateUserStatus();
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

  Future<void> _getFilteredUsers() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .get(); // Fetch all users to filter manually

      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;

        // Check if all necessary fields exist
        if (data.containsKey('Age') &&
            data.containsKey('Interest') &&
            data.containsKey('X') &&
            data.containsKey('Y') &&
            data.containsKey('profile_pic')) {
          // Determine if the user's gender matches the selected gender
          bool genderMatches = _isGenderMatching(data['Gender']);

          bool matchesInterests = widget.selectedInterests.every((interest) {
            return data['Interest']?.contains(interest) ?? false;
          });

          double userAge = _convertToDouble(data['Age']);
          double userDistance = _calculateDistance(
              widget.userLatitude, widget.userLongitude, data['X'], data['Y']);

          if (data['email'] != widget.useremail &&
              genderMatches &&
              matchesInterests &&
              userAge >= widget.ageRange.start &&
              userAge <= widget.ageRange.end &&
              userDistance >= widget.distanceRange.start &&
              userDistance <= widget.distanceRange.end) {
            // Add filtered user to the list
            filteredUsers.add({
              'name': data['name'],
              'age': data['Age'],
              'distance': userDistance.toInt(),
              'profile_pic': data['profile_pic'],
              'latitude': data['X'],
              'longitude': data['Y'],
              'location': data['Address'],
              'email': data['email'],
              "languages": data['languages'],
              "education": data['education'],
              "height": data['height'],
              "iconss": data["Icon"],
              "labels": data['Interest'],
              'description':data['description'],
              "imagecollection": data['images'],
            });
            favStatus[data['email']] = false;

            // Get profile picture as marker with rounded border
            Uint8List markerIcon =
                await _getMarkerWithImage(data['profile_pic']);

            // Add marker to map
            _markers.add(
              Marker(
                markerId: MarkerId(doc.id),
                position: LatLng(data['X'], data['Y']),
                icon: BitmapDescriptor.fromBytes(markerIcon),
                onTap: () {
                    bool isOnline = false;
   String lastSeen = "Last seen: N/A";
   lastSeenhistory = "Last seen: N/A";
   if (usersStatusDetails.containsKey(widget.useremail)) {
     final userStatus = usersStatusDetails[widget.useremail];
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
   Navigator.push(
     context,
     MaterialPageRoute(
         builder: (context) => viewpage(
             address: data['Address'],
             age: data['Age'],
             languages: data['languages'],
             education: data['education'],
             distance: calculateDistance(data["X"], data["Y"],
                     widget.userLatitude, widget.userLongitude)
                 .toInt(),
             height: data['height'],
             image: data['profile_pic'] ??
                            "https://img.freepik.com/premium-vector/data-loading-icon-waiting-program-vector-image-file-upload_652575-219.jpg?w=740",
             name: data['name'],
             ID: widget.useremail,
             iconss: data["Icon"],
             labels: data['Interest'],
             imagecollection: data['images'],
             fav: favStatus[data['email']]!,
             onlinecheck: lastSeen,
             statecolour: statecolour,
             useremail: widget.useremail, description: data['description'],)),
   ); 
                },
                // infoWindow: InfoWindow(
                  // title: data['name'],
                  // snippet:
                      // 'Age: ${data['Age']}, Distance: ${userDistance.toInt()} km',
                // ),
              ),
            );
          }
        } else {
          print('Document missing required fields: ${doc.id}');
        }
      }

      setState(() {}); // Update the map with new markers
    } catch (e) {
      print('Error fetching filtered users: $e');
    }
  }

  Future<void> _addLoggedUserMarker() async {
    // Add marker for logged-in user's location with a purple pin
    _markers.add(
      Marker(
        markerId: const MarkerId('loggedUser'),
        position: LatLng(widget.userLatitude, widget.userLongitude),
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
        infoWindow: const InfoWindow(
          title: 'You are here',
        ),
      ),
    );

    setState(() {});
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

  bool _isGenderMatching(String userGender) {
    switch (widget.selectedGender) {
      case 1: // Male
        return userGender == "Male";
      case 2: // Female
        return userGender == "Female";
      case 3: // Both
        return userGender == "Male" || userGender == "Female";
      // return userGender == "Male" && userGender == "Female";

      default:
        return false;
    }
  }

  bool fav = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.userLatitude, widget.userLongitude),
              zoom: 10,
            ),
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Padding(
                    padding: EdgeInsets.only(bottom: height / 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      bool isOnline = false;
                      String lastSeen = "Last seen: N/A";
                      lastSeenhistory = "Last seen: N/A";
                      if (usersStatusDetails.containsKey(widget.useremail)) {
                        final userStatus = usersStatusDetails[widget.useremail];
                        isOnline = userStatus['status'] == 'online';
                        if (isOnline) {
                          lastSeen = "Online";
                          lastSeenhistory = "Online";
                          statecolour = const Color.fromARGB(255, 49, 255, 56);
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
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return viewpage(
                                    address: user['location'],
                                    age: user['age'],
                                    languages: user['languages'],
                                    education: user['education'],
                                    distance: calculateDistance(
                                            user["latitude"],
                                            user["longitude"],
                                            widget.userLatitude,
                                            widget.userLongitude)
                                        .toInt(),
                                    height: user['height'],
                                    image: user['profile_pic'] ??
                                        "https://img.freepik.com/premium-vector/data-loading-icon-waiting-program-vector-image-file-upload_652575-219.jpg?w=740",
                                    name: user['name'],
                                    ID: widget.useremail,
                                    iconss: user["iconss"],
                                    labels: user['labels'],
                                    imagecollection: user['imagecollection'],
                                    fav: favStatus[user['email']]!,
                                    onlinecheck: lastSeen,
                                    statecolour: statecolour,
                                    useremail: widget.useremail, description: user['description'],);
                              },
                            ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 6,
                                  blurStyle: BlurStyle.outer,
                                  color: Color(0xff7905F5),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            width: 300,
                            height: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(user['profile_pic']),
                                  radius: 28,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                
                                  Flexible(
       child: Text(
         user['name'],
         style: TextStyle(
             fontSize: 18,
             fontWeight:
                 FontWeight.bold,
             color: Colors.black),
         softWrap: true,
         overflow: TextOverflow
             .visible, // You can also use TextOverflow.ellipsis if you want to 
       ),
     ),   
                                
                                
                                
                                    Text(
                                      user['location'],
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ),
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xff7905F5),
                                  ),
                                  child: IconButton(
                                      onPressed: () async {
                                        setState(() {
                                          favStatus[user['email']] =
                                              !favStatus[user['email']]!;
                                        });
                                        // Update Firestore collection
                                        if (favStatus[user['email']]!) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(user['email'])
                                              .get()
                                              .then((DocumentSnapshot
                                                  documentSnapshot) async {
                                            if (documentSnapshot.exists) {
                                              // Get the document data from the "Sell" collection
                                              Map<String, dynamic> data =
                                                  documentSnapshot.data()
                                                      as Map<String, dynamic>;
                                              try {
                                                           DocumentReference
               favDocRef =
               await FirebaseFirestore
                   .instance
                   .collection(
                       'Favourite')
                   .doc(widget
                       .useremail); // Add the data to the main document in Favou
           print(
               "Favourite document created with ID: ${favDocRef.id}");
           // Step 3: Create a subcollection under the newly created document
           await favDocRef
               .collection(
                   "fav1") // Subcollection name
               .doc(user[
                   'email']) // Use the same ID as in the "Sell" collection
               .set(
                   data); // Add the data from the "Sell" collection
           print(
               "Subcollection 'fav1' created with document ID: ${user['email']}");
           FirebaseFirestore
               .instance
               .collection(
                   'Favourite') // Replace with your collection name
               .doc(widget
                   .useremail)
               .collection("fav1")
               .doc(user['email'])
               .set(data);
                                                // Step 2: Create a new document in the "Favourite" collection with a generated ID
                                              } catch (error) {
                                                print(
                                                    "Error during creation of Favourite document or subcollection: $error");
                                              }
                                            } else {
                                              print(
                                                  "Document does not exist in Sell collection");
                                            }
                                          }).catchError((error) {
                                            print(
                                                "Failed to retrieve document from Sell collection: $error");
                                          });
                                        } else {      try {
        DocumentReference
            favDocRef =
            FirebaseFirestore
                .instance
                .collection(
                    'Favourite')
                .doc(widget
                    .useremail)
                .collection("fav1")
                .doc(user['email']);
        await favDocRef.delete();
        print(
            "Favorite removed with document ID: ${user['email']}");
      } catch (error) {
        print(
            "Error removing from Favourite: $error");
      }
    }
                                      },
                                      icon: Icon(
                                        favStatus[user['email']]!
                                            ? Icons.favorite_rounded
                                            : Icons.favorite_border_outlined,
                                        color: Colors.white,
                                        size: height / 30,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 30,
            right: 30,
                  bottom: MediaQuery.of(context).size.height/40,
            child: BottomNavBar(
              selectedIndex2: 1, onItemTapped: (int index) { 
                if (index == 1) {
           Navigator.pushReplacement(
             context,
             MaterialPageRoute(builder: (context) => MainScreen(initialIndex: 1,)),
           );
         }          else if (index == 0) {
           Navigator.pushReplacement(
             context,
             MaterialPageRoute(builder: (context) => MainScreen(initialIndex: 0,)),
           );
         } 
        else if (index == 2) {
           Navigator.pushReplacement(
             context,
             MaterialPageRoute(builder: (context) => MainScreen(initialIndex: 2,)),
           );
         } 
        else if (index == 3) {
           Navigator.pushReplacement(
             context,
             MaterialPageRoute(builder: (context) => MainScreen(initialIndex: 3,)),
           );
         } 
       else  if (index == 4) {
           Navigator.pushReplacement(
             context,
             MaterialPageRoute(builder: (context) => MainScreen(initialIndex: 4,)),
           );
         } 
               },
            ),
          )
        ],
      ),
    );
  }
}
