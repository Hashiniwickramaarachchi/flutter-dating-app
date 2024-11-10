import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/Usermanegement/completeprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart'; // Import geocoding package
import 'package:geocoding/geocoding.dart' as geocoding; // For searching addresses

class Manual extends StatefulWidget {
  const Manual({super.key});

  @override
  State<Manual> createState() => _ManualState();
}

class _ManualState extends State<Manual> {
  LatLng? _currentLatLng; // To store the selected location coordinates
  String? _currentAddress; // To store the reverse geocoded address
  String? _currentAddressDB;

  TextEditingController _searchController = TextEditingController();
  List<Placemark> _searchResults = [];
  List<Location> _locations = [];

  // Function to open Google Maps to select a location
  Future<void> _openMap() async {
    LatLng initialLocation = LatLng(7.8731, 80.7718); // Default location

    // Navigate to Google Maps and let the user select a location
    LatLng? selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MapScreen(
          initialLocation: initialLocation,
        ),
      ),
    );

    if (selectedLocation != null) {
      setState(() {
        _currentLatLng = selectedLocation;
      });
      _getAddressFromLatLng(
          selectedLocation); // Reverse geocode the selected location
    }
  }

  // Function to get address from latitude and longitude
  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress =
              "${place.street}, ${place.locality}, ${place.country}";
          _currentAddressDB = "${place.locality}, ${place.country}";
        });
      }

      try {
        // Get the logged-in user's email (this will be the document ID in Firestore)
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          throw Exception("User not logged in");
        }
        String userEmail = user.email!;
        if (_currentAddress.toString().isNotEmpty &&
            _currentLatLng.toString().isNotEmpty) {
          // Upload the image to Firebase Storage
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userEmail)
              .update({
            'X': _currentLatLng?.latitude,
            "Y": _currentLatLng?.longitude,
            'Address': _currentAddressDB
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Location added Successfully')),
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
          SnackBar(content: Text('Failed to add location: $e')),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  // Function to search for a location by name or address
  Future<void> _searchLocation(String query) async {
    try {
      // Fetch location coordinates from address
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        // Fetch placemark (address details) for those coordinates
        List<Placemark> placemarks = await placemarkFromCoordinates(
          locations.first.latitude,
          locations.first.longitude,
        );
        setState(() {
          _searchResults = placemarks;  // Store placemarks for display
          _locations = locations; // Store locations to match placemarks
        });
      } else {
        setState(() {
          _searchResults = [];
        });
      }
    } catch (e) {
      print("Error while searching for location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
                                               appBar: AppBar(
     toolbarHeight:height/400,
     foregroundColor: const Color.fromARGB(255, 255, 255, 255),
     automaticallyImplyLeading: false,
   backgroundColor: const Color.fromARGB(255, 255, 255, 255),
   surfaceTintColor:const Color.fromARGB(255, 255, 255, 255),
   ),
      body: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        height: height,
        width: width,
        child: Padding(
          padding: EdgeInsets.only(
              bottom: height / 60,
              right: width / 30,
              left: width / 30),
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
                    Expanded(
                      child: Center(
                        child: Text(
                          "Enter your location",
                          style: TextStyle(
                              color: const Color(0xff26150F),
                              fontFamily: "defaultfontsbold",
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(width: width / 20)
                  ],
                ),
                SizedBox(height: height / 50),
                // Search field to search for location
                Padding(
                  padding:  EdgeInsets.only(left: width/30,right: width/30),
                  child: Container(
                    height: height / 22,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _searchLocation, // Trigger search on text input
                      style: Theme.of(context).textTheme.headlineSmall,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: width / 20,
                            top: height / 2,
                            bottom: height / 150),
                        hintText: "Search location",
                        border: InputBorder.none,
                        suffixIcon: Icon(
                          Icons.search,
                          color: Color(0xff565656),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height / 30),
    
                // Display search results// Display search results
    _searchResults.isNotEmpty && _locations.isNotEmpty
        ? ListView.builder(
      shrinkWrap: true,
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        if (index >= _locations.length) {
          return Container(); // Safety check: If locations are fewer, don't show more items
        }
        
        Placemark place = _searchResults[index];
        Location location = _locations[index];
        
        return ListTile(
          title: Text(
            "${place.street}, ${place.locality}, ${place.country}",
          ),
          onTap: () {
            setState(() {
              _currentLatLng = LatLng(
                location.latitude,
                location.longitude,
              );
              _currentAddress =
                  "${place.street}, ${place.locality}, ${place.country}";
              _currentAddressDB =
                  "${place.locality}, ${place.country}";
            });
            _searchController.clear();
            _searchResults.clear();
          },
        );
      },
    )
        : Container(),
    
    
                // Manual location input field (read-only, opens map)
                TextField(
                  onTap: _openMap, // Open map when tapping
                  readOnly: true,
                  style: Theme.of(context).textTheme.headlineSmall,
                  decoration: InputDecoration(
                    hintText: _currentAddress ?? "Use current location",
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff8F9DA6)),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff8F9DA6)),
                    ),
                    contentPadding:
                        EdgeInsets.only(left: width / 50, top: height / 50),
                    prefixIcon: Icon(
                      Icons.navigation,
                      color: Color(0xff565656),
                      size: 20
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// MapScreen widget to select location using Google Map
class MapScreen extends StatefulWidget {
  final LatLng initialLocation;
  const MapScreen({Key? key, required this.initialLocation}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Location')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.initialLocation,
          zoom: 16,
        ),
        onTap: _selectLocation,
        markers: _pickedLocation == null
            ? {}
            : {
                Marker(
                  markerId: MarkerId('picked-location'),
                  position: _pickedLocation!,
                ),
              },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: FloatingActionButton(
            child: Icon(Icons.check),
            onPressed: () {
              if (_pickedLocation != null) {
                Navigator.of(context).pop(_pickedLocation);
              }
            },
          ),
        ),
      ),
    );
  }
}
