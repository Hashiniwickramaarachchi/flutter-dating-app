import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:datingapp/accountdelectionpage.dart';
import 'package:datingapp/ambassdor/onlinecheck.dart';
import 'package:datingapp/block.dart';
import 'package:datingapp/blockpage.dart';
import 'package:datingapp/bootmnavbar.dart';
import 'package:datingapp/deactivepage.dart';
import 'package:datingapp/fav.dart';
import 'package:datingapp/onlinecheck.dart';
import 'package:datingapp/premium/ambassdorshow.dart';
import 'package:datingapp/userchatpage.dart';
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
    final A_OnlineStatusService A_onlineStatusService = A_OnlineStatusService();


  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  Map<String, dynamic> usersStatusDetails = {}; // Change from List to Map
  String lastSeenhistory = "Last seen: N/A";
  Color statecolour = Colors.white;
  bool isLoading = true; // Track loading state
  int loadedUsers = 0; // Counter for loaded users
  bool _isMapInitialized = false;
  String buttonText = "Request Ambassador";
  bool isLoadingambassdor = false;

  // Future<void> handleButtonPress() async {
    // if (buttonText == "Your Ambassador") {

      // try {
        // final userEmail = widget.useremail;

        // DocumentSnapshot requestSnapshot = await FirebaseFirestore.instance
            // .collection('requestedAmbassador')
            // .doc(userEmail)
            // .get();

        // if (requestSnapshot.exists) {
          // final data = requestSnapshot.data() as Map<String, dynamic>;
          // final ambassadorEmail = data['ambassadorEmail'];

          // if (ambassadorEmail.isNotEmpty) {
            // DocumentSnapshot ambassadorSnapshot = await FirebaseFirestore
                // .instance
                // .collection('Ambassdor')
                // .doc(ambassadorEmail)
                // .get();

            // if (ambassadorSnapshot.exists) {
              // final ambassadorData =
                  // ambassadorSnapshot.data() as Map<String, dynamic>;

              // Navigator.of(context).push(MaterialPageRoute(
                  // builder: (context) => ChatPage(
                      // chatPartnerEmail: ambassadorEmail,
                      // who: "Ambassdor",
                      // chatPartnername: ambassadorData['name'],
                      // chatPartnerimage: ambassadorData['profile_pic'],
                      // onlinecheck: lastSeenhistory,
                      // statecolour: statecolour)));
              // return;
            // }
          // }
        // }

        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // content: Text("No ambassador assigned yet."),
        // ));
      // } catch (e) {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // content: Text("Error: ${e.toString()}"),
        // ));
      // } finally {
        // setState(() {
          // isLoading = false;
        // });
      // }

      // return;
    // }
    // setState(() {
      // isLoading = true;
    // });

    // try {
      // final userEmail = widget.useremail;

      // DocumentReference docRef = FirebaseFirestore.instance
          // .collection('requestedAmbassador')
          // .doc(userEmail);

      // DocumentSnapshot docSnapshot = await docRef.get();

      // if (!docSnapshot.exists) {
        // await docRef.set({
          // 'request': 'requested',
          // 'ambassadorEmail': '', // Initially empty
          // 'requestedDate': FieldValue.serverTimestamp(),
          // 'email': userEmail, // User email
        // });

        // setState(() {
          // buttonText = "Ambassador request is in queue";
        // });
      // } else {
        // final data = docSnapshot.data() as Map<String, dynamic>;
        // if (data['ambassadorEmail'] == '') {
          // setState(() {
            // buttonText = "Ambassador request is in queue";
          // });
        // } else {
          // setState(() {
            // buttonText = "Your Ambassador";
          // });
        // }
      // }
    // } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        // content: Text("Error: ${e.toString()}"),
      // ));
    // } finally {
      // setState(() {
        // isLoading = false;
      // });
    // }
  // }
 Future<void> handleButtonPress() async {
    setState(() {
      isLoadingambassdor = true;
    });

    try {
      final userEmail = widget.useremail;

      // Check if the document exists
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('requestedAmbassador')
          .doc(userEmail)
          .get();
  DocumentSnapshot docSnapshot2 = await FirebaseFirestore.instance
      .collection('users')
      .doc(userEmail)
      .get();
      if (!docSnapshot.exists) {
        // Create a new request document if it doesn't exist
        await FirebaseFirestore.instance
            .collection('requestedAmbassador')
            .doc(userEmail)
            .set({
          'request': 'requested',
          'ambassadorEmail': '',
          'requestedDate': FieldValue.serverTimestamp(),
          'email': userEmail,
        });
     await FirebaseFirestore.instance
         .collection('users')
         .doc(userEmail)
         .update({
    
       'ambassadorEmail': '',
     });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Request submitted successfully."),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: ${e.toString()}"),
      ));
    } finally {
      setState(() {
        isLoadingambassdor = false;
      });
    }
  }

  Future<void> navigateToChatPage(String ambassadorEmail) async {
    setState(() {
      isLoadingambassdor = true;
    });

    try {
      // Fetch ambassador details from Firestore
      DocumentSnapshot ambassadorSnapshot = await FirebaseFirestore.instance
          .collection('Ambassdor') // Correct spelling if needed
          .doc(ambassadorEmail)
          .get();

      if (ambassadorSnapshot.exists) {
        final ambassadorData =
            ambassadorSnapshot.data() as Map<String, dynamic>;

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChatPage(
            chatPartnerEmail: ambassadorEmail,
            who: "Ambassdor", // Ensure spelling consistency
            chatPartnername: ambassadorData['name'],
            chatPartnerimage: ambassadorData['profile_pic'],
            onlinecheck: lastSeenhistory, // Replace with real data if needed
            statecolour: statecolour,    // Replace with real data if needed
          ),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Ambassador details not found."),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: ${e.toString()}"),
      ));
    } finally {
      setState(() {
        isLoadingambassdor = false;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    _getAllUsers(); // Fetch all users
    _addLoggedUserMarker();
    fetchUsersStatus();
    // Call this when the app starts or the user logs in
    _checkUserExistsAndUpdateStatus();
  }

  @override
  void dispose() {
    super.dispose();
    // Ensure no pending map updates occur when navigating away
    _controller.future
        .then((controller) => controller.dispose())
        .catchError((_) {
      // Ignore errors if already disposed
    });
    // Call this when the app is closed
_checkUserExistsAndUpdateStatusoffline();
  }



Future<void> _checkUserExistsAndUpdateStatus() async {
  final userEmail = widget.useremail; // Assuming you have the user email

  try {
    // Check if the document exists in the 'users' collection
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .get();

    if (userDoc.exists) {
      // User exists, update the online status
      _onlineStatusService.updateUserStatus();
    } else {
      A_onlineStatusService.updateUserStatus();
    }
  } catch (e) {
    print("Error checking user existence: $e");
  }
}


Future<void> _checkUserExistsAndUpdateStatusoffline() async {
  final userEmail = widget.useremail; // Assuming you have the user email

  try {
    // Check if the document exists in the 'users' collection
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .get();

    if (userDoc.exists) {
      // User exists, update the online status
      _onlineStatusService.setUserOffline();
    } else {
      A_onlineStatusService.setUserOffline();
    }
  } catch (e) {
    print("Error checking user existence: $e");
  }
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

  void _onMapCreated(GoogleMapController controller) {
    if (!_controller.isCompleted) {
      _controller.complete(controller);
    }
    setState(() {
      _isMapInitialized = true; // Map is ready
    });
  }

Future<void> _getAllUsers() async {
  try {
    // Step 1: Fetch blocked users for the logged-in user
    DocumentSnapshot blockedSnapshot = await FirebaseFirestore.instance
        .collection("Blocked USers")
        .doc(widget.useremail)
        .get();

    List<String> blockedEmails = [];
    if (blockedSnapshot.exists) {
      final blockedData = blockedSnapshot.data() as Map<String, dynamic>?;
      if (blockedData != null &&
          blockedData["This Id blocked Users"] != null) {
        blockedEmails = List<String>.from(blockedData["This Id blocked Users"]);
      }
    }

    // Step 2: Fetch all users
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .get(); // Fetch all users

    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;

      // Skip the logged-in user's marker and blocked users
      if (data['email'] == widget.useremail ||
          blockedEmails.contains(data['email'])) {
        continue;
      }

      // Step 3: Get profile picture as marker with rounded border
      Uint8List markerIcon = await _getMarkerWithImage(
          data['profile_pic'], data['profile'] == 'premium');

      // Step 4: Add marker to map
       _markers.add(
   Marker(
     markerId: MarkerId(doc.id),
     position: LatLng(data['X'], data['Y']),
     icon: BitmapDescriptor.fromBytes(markerIcon),
     onTap: () {
       bool isOnline = false;
       String lastSeen = "Last seen: N/A";
       lastSeenhistory = "Last seen: N/A";
       if (usersStatusDetails.containsKey(data['email'])) {
         final userStatus = usersStatusDetails[data['email']];
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
                builder: (context) =>
                        viewpage(
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
              ID: data['email'],
              iconss: data["Icon"],
              labels: data['Interest'],
              imagecollection: data['images'],
              fav: favStatus[data['email']]!,
              onlinecheck: lastSeen,
              statecolour: statecolour,
              useremail: widget.useremail,
              description: data['description'],
            )),
  
              
            );
          },
        ),
      );

      // Step 5: Add the user to filteredUsers for display
      setState(() {
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
       'description': data['description'],
       "imagecollection": data['images'],
    
});
      });

      favStatus[data['email']] = false; // Initialize favorite status
      loadedUsers++; // Increment loaded users counter
      _checkIfLoadingComplete();
    }
  } catch (e) {
    print('Error fetching all users: $e');
  }
}



  // Future<void> _getAllUsers() async {
    // try {
      // QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          // .collection('users')
          // .get(); // Fetch all users

      // for (var doc in querySnapshot.docs) {
        // var data = doc.data() as Map<String, dynamic>;

        // if (data['email'] == widget.useremail) continue;

        // Uint8List markerIcon = await _getMarkerWithImage(
            // data['profile_pic'], data['profile'] == 'premium');

        // _markers.add(
          // Marker(
            // markerId: MarkerId(doc.id),
            // position: LatLng(data['X'], data['Y']),
            // icon: BitmapDescriptor.fromBytes(markerIcon),
            // onTap: () {
              // bool isOnline = false;
              // String lastSeen = "Last seen: N/A";
              // lastSeenhistory = "Last seen: N/A";
              // if (usersStatusDetails.containsKey(data['email'])) {
                // final userStatus = usersStatusDetails[data['email']];
                // isOnline = userStatus['status'] == 'online';
                // if (isOnline) {
                  // lastSeen = "Online";
                  // lastSeenhistory = "Online";
                  // statecolour = const Color.fromARGB(255, 49, 255, 56);
                // } else {
                  // var lastSeenDate = DateTime.fromMillisecondsSinceEpoch(
                          // userStatus['lastSeen'])
                      // .toLocal();
                  // lastSeen =
                      // "Last seen: ${DateFormat('MMM d, yyyy h:mm a').format(lastSeenDate)}";
                  // lastSeenhistory = lastSeen;
                  // statecolour = Colors.white;
                // }
              // }
              // Navigator.push(
                // context,
                // MaterialPageRoute(
                    // builder: (context) =>
                    // viewpage(
                          // address: data['Address'],
                          // age: data['Age'],
                          // languages: data['languages'],
                          // education: data['education'],
                          // distance: calculateDistance(data["X"], data["Y"],
                                  // widget.userLatitude, widget.userLongitude)
                              // .toInt(),
                          // height: data['height'],
                          // image: data['profile_pic'] ??
                              // "https://img.freepik.com/premium-vector/data-loading-icon-waiting-program-vector-image-file-upload_652575-219.jpg?w=740",
                          // name: data['name'],
                          // ID: data['email'],
                          // iconss: data["Icon"],
                          // labels: data['Interest'],
                          // imagecollection: data['images'],
                          // fav: favStatus[data['email']]!,
                          // onlinecheck: lastSeen,
                          // statecolour: statecolour,
                          // useremail: widget.useremail,
                          // description: data['description'],
                        // )),
              // );
            // },
          // ),
        // );
// setState(() {
  // 

        // filteredUsers.add({
          // 'name': data['name'],
          // 'age': data['Age'],
          // 'profile_pic': data['profile_pic'],
          // 'latitude': data['X'],
          // 'longitude': data['Y'],
          // 'location': data['Address'],
          // 'email': data['email'],
          // "languages": data['languages'],
          // "education": data['education'],
          // "height": data['height'],
          // "iconss": data["Icon"],
          // "labels": data['Interest'],
          // 'description': data['description'],
          // "imagecollection": data['images'],
        // });
// });
        // favStatus[data['email']] = false; // Initialize favorite status
        // loadedUsers++; // Increment loaded users counter
        // _checkIfLoadingComplete();
      // }

      // setState(() {

      // }); // Update the map with new markers
    // } catch (e) {
      // print('Error fetching all users: $e');
    // }
  // }

  void _checkIfLoadingComplete() {
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
   final User? curentuser = FirebaseAuth.instance.currentUser;
   if (curentuser == null) {
     // Handle unauthenticated user state (e.g., redirect to login page or show an
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
                  if (!_isMapInitialized)
                    Center(
                      child:
                          CircularProgressIndicator(), // Loading indicator until map is ready
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
                                  .containsKey(user['email'])) {
                                final userStatus =
                                    usersStatusDetails[user['email']];
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
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
                                          ID: user['email'],
                                          iconss: user["iconss"],
                                          labels: user['labels'],
                                          imagecollection:
                                              user['imagecollection'],
                                          fav: favStatus[user['email']]!,
                                          onlinecheck: lastSeen,
                                          statecolour: statecolour,
                                          useremail: widget.useremail,
                                          description: user['description'],
                                        );
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
                                          backgroundImage:
                                              NetworkImage(user['profile_pic']),
                                          radius: 28,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: Text(
                                                user['name'],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff26150F),
                                                  fontFamily:
                                                      "defaultfontsbold",
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                ),
                                                maxLines:
                                                    1, // Limit to one line
                                                overflow: TextOverflow
                                                    .ellipsis, // Adds "..." if the text is too long
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
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'Favourite') // Replace with your collection name
                                                          .doc(widget.useremail)
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
                                                  DocumentReference favDocRef =
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'Favourite')
                                                          .doc(widget.useremail)
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
                    // Padding(
                      // padding: EdgeInsets.only(left: 20, top: 80),
                      // child: ElevatedButton(
                          // style: ElevatedButton.styleFrom(
                            // shape: RoundedRectangleBorder(
                                // borderRadius:
                                    // BorderRadius.all(Radius.circular(30))),
                            // backgroundColor: Color(0xff7905F5),
                          // ),
                          // onPressed: isLoadingambassdor
                              // ? null
                              // : () {
                                  // handleButtonPress();
                                // },
                          // child: Padding(
                            // padding: EdgeInsets.only(top: 10, bottom: 10),
                            // child: isLoading
                                // ? CircularProgressIndicator(color: Colors.white)
                                // : Text(buttonText,
                                    // style: TextStyle(
                                        // color: Colors.white,
                                        // fontSize: 15,
                                        // fontFamily: "button")),
                          // )),
StreamBuilder<DocumentSnapshot>(
  stream: FirebaseFirestore.instance
      .collection('users')
      .doc(curentuser.email!)
      .snapshots(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }

    if (snapshot.hasError) {
      return Text("Error: ${snapshot.error}");
    }

    String buttonText = "Request Ambassador";
    String? ambassadorEmail;

    if (snapshot.hasData && snapshot.data!.exists) {
      final data = snapshot.data!.data() as Map<String, dynamic>;
      
      // Check if 'ambassadorEmail' attribute is included
      if (data.containsKey('ambassadorEmail')) {
        ambassadorEmail = data['ambassadorEmail'] ?? '';
      bool isOnline = false;
      String lastSeen = "Last seen: N/A";
      lastSeenhistory = "Last seen: N/A";
      if (usersStatusDetails
          .containsKey(ambassadorEmail)) {
        final userStatus =
            usersStatusDetails[ambassadorEmail];
        isOnline =
            userStatus['status'] == 'online';
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
        // Fetch the status for this specific user

        // Update button text based on 'ambassadorEmail'

        buttonText = ambassadorEmail!.isEmpty
            ? "Ambassador request is in queue"
            : "Your Ambassador";
      } else {
        buttonText = "Request Ambassador";
      }
    }

    return Padding(
      padding: EdgeInsets.only(left: 20, top: 80),
      child: 
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          backgroundColor: Color(0xff7905F5),
        ),
        onPressed: isLoading
            ? null
            : () async {
                if (buttonText == "Your Ambassador" &&
                    ambassadorEmail != null) {
                  await navigateToChatPage(ambassadorEmail);
                } else if (buttonText == "Request Ambassador") {
                  await handleButtonPress();
                }
              },
        child: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: isLoading
              ? CircularProgressIndicator(color: Colors.white)
              : 
              Text(
                  buttonText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: "button",
                  ),
                ),
        ),
      ),
    );
  },
)

                  ],

                  // Positioned(
                  // left: width/20,
                  // right: width/20,
                  // bottom: height/60,
                  // child: BottomNavBar(
                  // selectedIndex2: 1,
                  // ),
                  // )
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
