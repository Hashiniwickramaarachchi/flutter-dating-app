import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:datingapp/bootmnavbar.dart';
import 'package:datingapp/fav.dart';
import 'package:datingapp/onlinecheck.dart';
import 'package:datingapp/premium/ambassdorshow.dart';
import 'package:datingapp/viewpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class allusermap extends StatefulWidget {
  final double userLatitude;
  final double userLongitude;
  final String useremail;

  const allusermap({
    Key? key,
    required this.userLatitude,
    required this.userLongitude,
    required this.useremail,
  }) : super(key: key);

  @override
  _allusermapState createState() => _allusermapState();
}

class _allusermapState extends State<allusermap> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  List<Map<String, dynamic>> filteredUsers = []; // List to hold users
  Map<String, bool> favStatus = {}; // Map to track favorite status by email
  final OnlineStatusService _onlineStatusService = OnlineStatusService();
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  Map<String, dynamic> usersStatusDetails = {}; // Change from List to Map
  String lastSeenhistory = "Last seen: N/A";
  Color statecolour = Colors.white;
  bool isLoading = true; // Track loading state
  int loadedUsers = 0; // Counter for loaded users

  @override
  void initState() {
    super.initState();
    _getAllUsers(); // Fetch all users
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

  Future<void> _getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .get(); // Fetch all users

      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;

        // Check if all necessary fields exist
        // Skip the logged-in user's marker
        if (data['email'] == widget.useremail) continue;

        // Get profile picture as marker with rounded border
        Uint8List markerIcon = await _getMarkerWithImage(
            data['profile_pic'], data['profile'] == 'premium');

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
          ),
        );

        // Add the user to filteredUsers if you still want to display them in the list
        filteredUsers.add({
          'name': data['name'],
          'age': data['Age'],
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

        favStatus[data['email']] = false; // Initialize favorite status
        loadedUsers++; // Increment loaded users counter
        _checkIfLoadingComplete();
      }

      // setState(() {

      // }); // Update the map with new markers
    } catch (e) {
      print('Error fetching all users: $e');
    }
  }

  void _checkIfLoadingComplete() {
    // Check if all users are loaded
    if (0 < loadedUsers) {
      setState(() {
        isLoading = false; // Stop loading when all users are loaded
      });
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

  Future<Uint8List> _getMarkerWithImage(String imageUrl, bool check) async {
    try {
      final http.Response response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        Uint8List imageData = response.bodyBytes;

        // Decode the profile picture image
        ui.Codec codec = await ui.instantiateImageCodec(imageData);
        ui.FrameInfo frameInfo = await codec.getNextFrame();
        ui.Image image = frameInfo.image;

        // Set up the canvas and sizes
        final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
        final Canvas canvas = Canvas(pictureRecorder);
        const double size = 150.0; // Marker size
        const double whiteBorderSize = 15.0; // White border size around image
        const double imageSize =
            size - (whiteBorderSize * 2); // Inner profile image size

        // Draw the outer white border
        final Paint whiteBorderPaint = Paint()
          ..color = Colors.transparent
          ..style = PaintingStyle.fill;
        canvas.drawCircle(
          Offset(size / 2, size / 2),
          size / 1.2,
          whiteBorderPaint,
        );

        if (check == true) {
          final ui.Image settingsIcon = await loadSettingsIcon();
          const double iconSize = 40.0; // Settings icon size
          final double iconOffsetX = size - iconSize - 2; // Adjust X to right
          final double iconOffsetY = 2; // Adjust Y to top
          canvas.drawImageRect(
            settingsIcon,
            Rect.fromLTWH(0, 0, settingsIcon.width.toDouble(),
                settingsIcon.height.toDouble()),
            Rect.fromLTWH(iconOffsetX, iconOffsetY, iconSize, iconSize),
            Paint(),
          );
        }
        // Draw the inner circular profile picture
        final Rect imageRect = Rect.fromLTWH(
            whiteBorderSize, whiteBorderSize, imageSize, imageSize);
        final ui.Path clipPath = ui.Path()..addOval(imageRect);
        canvas.clipPath(clipPath);
        canvas.drawImageRect(
          image,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          imageRect,
          Paint(),
        );

        // Load the settings icon and place it on the top-right of the white border

        // Convert the canvas to an image
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

  Future<ui.Image> loadSettingsIcon() async {
    final ByteData data = await rootBundle.load(
      "assetss/Vector.png",
    ); // Path to settings icon
    final Uint8List bytes = data.buffer.asUint8List();
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final curentuser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(curentuser.email!)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userdataperson =
                snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
              body: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target:
                          LatLng(widget.userLatitude, widget.userLongitude),
                      zoom: 10,
                    ),
                    markers: _markers,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                  if (isLoading)
                    Center(
                      child:
                          CircularProgressIndicator(), // Show loading indicator
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
                              if (usersStatusDetails
                                  .containsKey(widget.useremail)) {
                                final userStatus =
                                    usersStatusDetails[widget.useremail];
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
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
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
                                            imagecollection:
                                                user['imagecollection'],
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              user['profile_pic']),
                                          radius: 28,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                     Container(
                      color: Colors.transparent,
           width: width/3,
           child: Expanded(
             child: Center(
               child: Text(
                textAlign: TextAlign.center,
                  user['name'],
                 style: TextStyle(
                   color: const Color(0xff26150F),
                   fontFamily: "defaultfontsbold",
                   fontWeight: FontWeight.w500,
                   fontSize: 18,
                 ),
                 softWrap: true,
                 overflow: TextOverflow
                     .visible, // You can also use TextOverflow.ellipsis if you want to truncate
               ),
             ),
           ),
         ),
                                            Text(
                                              user['location'],
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12),
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
                                                    !favStatus[
                                                        user['email']]!;
                                              });
                                              // Update Firestore collection
                                              if (favStatus[user['email']]!) {
                                                FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(user['email'])
                                                    .get()
                                                    .then((DocumentSnapshot
                                                        documentSnapshot) async {
                                                  if (documentSnapshot
                                                      .exists) {
                                                    // Get the document data from the "Sell" collection
                                                    Map<String, dynamic>
                                                        data =
                                                        documentSnapshot
                                                                .data()
                                                            as Map<String,
                                                                dynamic>;
                                                    try {
                                                      // Step 2: Create a new document in the "Favourite" collection with a generated ID
                                                      DocumentReference
                                                          favDocRef =
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Favourite')
                                                              .doc(widget
                                                                  .useremail); // Add the data to the main document in Favourite
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
                                                    } catch (e) {
                                                      print(
                                                          "Error adding favourite user: $e");
                                                    }
                                                  }
                                                });
                                              } else {
                                                try {
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
                                            icon: favStatus[user['email']]!
                                                ? Icon(Icons.favorite_rounded,
                                                    color: Colors.white)
                                                : Icon(
                                                    Icons
                                                        .favorite_border_outlined,
                                                    color: Colors.white,
                                                  ),
                                          ),
                                        )
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
                  if (userdataperson['profile'] == 'premium') ...[
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 80),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            backgroundColor: Color(0xff7905F5),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (context) {
                                return ambassdorshow(
                                    useremail: widget.useremail);
                              },
                            ));
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(
                              "Request Ambassador",
                              style: TextStyle(color: Colors.white,fontSize:15,fontFamily: "button" )
                            ),
                          )),
                    )
                  ],
           
           
           
           
                  Positioned(
                  left: width/20,
                  right: width/20,
                  bottom: height/60,
                    child: BottomNavBar(
                      selectedIndex2: 1,
                    ),
                  )
           
           
           
           
                ],
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
