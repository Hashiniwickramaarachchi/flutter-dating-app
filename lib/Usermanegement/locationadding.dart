import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/Usermanegement/completeprofile.dart';
import 'package:datingapp/Usermanegement/manualadding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc; // Aliased the location package
import 'package:geocoding/geocoding.dart'; // For getting the location name

class loactionadding extends StatefulWidget {
  const loactionadding({super.key});

  @override
  State<loactionadding> createState() => _loactionaddingState();
}

class _loactionaddingState extends State<loactionadding> {
  loc.Location _location = loc.Location(); // Using the alias `loc` for location
  LatLng? _currentLatLng; // Variable to store the user's live location
  String? _currentLocationName; // Variable to store the location name
  String? _currentlocationcountry;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission(); // Request location permission when the widget is initialized
  }

  Future<void> _requestLocationPermission() async {
    bool _serviceEnabled;
    loc.PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final locationData = await _location.getLocation();
      setState(() {
        _currentLatLng =
            LatLng(locationData.latitude!, locationData.longitude!);
        print(
            'Latitude: ${_currentLatLng!.latitude}, Longitude: ${_currentLatLng!.longitude}');
      });

      // Get the location name using the geocoding package
      List<Placemark> placemarks = await placemarkFromCoordinates(
          locationData.latitude!, locationData.longitude!);
      if (placemarks.isNotEmpty) {
        setState(() {
          _currentLocationName = placemarks.first.administrativeArea;
          _currentlocationcountry = placemarks.first.isoCountryCode;
          print(
              'Location Name: $_currentLocationName,$_currentlocationcountry');
        });
      }

      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentLatLng!,
            zoom: 16.0,
          ),
        ),
      );
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height / 400,
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(
              bottom: height / 60, right: width / 30, left: width / 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  ],
                ),
                SizedBox(height: height / 90),
                Center(
                  child: Text(
                    "What is your location?",
                    style: TextStyle(
                        color: const Color(0xff26150F),
                        fontFamily: "defaultfontsbold",
                        fontWeight: FontWeight.w500,
                        fontSize: 24),
                  ),
                ),
                SizedBox(height: height / 100),
                Center(
                  child: Text(
                    "Only you can see your personal data",
                    style: TextStyle(
                        color: const Color(0xff7D7676),
                        fontWeight: FontWeight.bold,
                        fontFamily: "defaultfontsbold",
                        fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: height / 50, bottom: height / 50),
                    child: Container(
                      height: height / 3,
                      width: width / 3,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffEDEDED),
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: Colors.black,
                        size: height / 15,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: height / 30,
                      bottom: height / 30,
                      left: width / 22,
                      right: width / 22),
                  child: GestureDetector(
                    onTap: () async {
                      await _getCurrentLocation(); // Get live location when button is pressed
                    },
                    child: Container(
                      height: height / 15,
                      width: width,
                      decoration: BoxDecoration(
                        color: Color(0xff7905F5),
                        borderRadius: BorderRadius.circular(height / 10),
                      ),
                      child: Center(
                        child: Text(
                          "Allow location access",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) {
                          return Manual(); // Replace with your manual location screen
                        },
                      ),
                    );
                  },
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: height / 90, top: height / 50),
                      child: Text(
                        "Enter location manually",
                        style: TextStyle(
                            color: const Color(0xff7D7676),
                            fontWeight: FontWeight.w900,
                            fontFamily: "defaultfontsbold",
                            fontSize: 20),
                      ),
                    ),
                  ),
                ),
                if (_currentLatLng !=
                    null) // Display the map when location is fetched
                  SizedBox(
                    height: height / 2,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _currentLatLng!,
                        zoom: 16.0,
                      ),
                      markers: _currentLatLng != null
                          ? {
                              Marker(
                                markerId: MarkerId('current-location'),
                                position: _currentLatLng!,
                              )
                            }
                          : {},
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                    ),
                  ),
                if (_currentLocationName != null) ...[
                  Padding(
                    padding: EdgeInsets.only(top: height / 50),
                    child: Center(
                      child: Text(
                        "Location: $_currentLocationName,$_currentlocationcountry", // Display the location name
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: height / 40),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Location Correct ",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: height / 60),
                      ),
                      GestureDetector(
                        onTap: () async {
                          try {
                            // Get the logged-in user's email (this will be the document ID in Firestore)
                            final user = FirebaseAuth.instance.currentUser;
                            if (user == null) {
                              throw Exception("User not logged in");
                            }
                            String userEmail = user.email!;
                            if (_currentLocationName.toString().isNotEmpty &&
                                _currentLatLng.toString().isNotEmpty &&
                                _currentlocationcountry.toString().isNotEmpty) {
                              // Upload the image to Firebase Storage
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userEmail)
                                  .update({
                                'X': _currentLatLng?.latitude,
                                "Y": _currentLatLng?.longitude,
                                'Address':
                                    "$_currentLocationName,$_currentlocationcountry"
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Location added Successfully')),
                              );
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) {
                                  return completeprofile();
                                },
                              ));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Fill the lines')),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Failed to add location: $e')),
                            );
                          }
                        },
                        child: Text(
                          "Click Here",
                          style: TextStyle(
                            color: Color(0xff7905F5),
                            fontWeight: FontWeight.bold,
                            fontSize: height / 60,
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xff7905F5),
                          ),
                        ),
                      ),
                    ],
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
