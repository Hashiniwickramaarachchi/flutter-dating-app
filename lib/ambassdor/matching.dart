import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/Usermanegement/manualadding.dart';
import 'package:datingapp/ambassdor/filterresult.dart';
import 'package:datingapp/ambassdor/interestpage.dart';
import 'package:datingapp/ambassdor/matchingfilter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CoupleMatchingPage extends StatefulWidget {
  const CoupleMatchingPage({super.key});

  @override
  State<CoupleMatchingPage> createState() => _CoupleMatchingPageState();
}

class _CoupleMatchingPageState extends State<CoupleMatchingPage> {
  LatLng? _currentLatLng; // To store the selected location coordinates
  String? _currentAddress; // To store the reverse geocoded address
  String? _currentAddressDB;
  final Set<String> _selectedInterestIndices = {}; //
  final Set<int> _selectedInterestIcons = {}; // Store
  TextEditingController _searchController = TextEditingController();
  double? selectlat;
  double? selectlong;
  List<Placemark> _searchResults = [];
  List<Location> _locations = [];

  Future<void> _openMap(double lat, double long) async {
    LatLng initialLocation = LatLng(lat, long); // Default location

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

  final List<Map<String, dynamic>> _interests = [
    {'icon': Icons.music_note, 'label': 'Music'},
    {'icon': Icons.directions_bike, 'label': 'Dance'},
    {'icon': Icons.book, 'label': 'Books'},
    {'icon': Icons.language, 'label': 'Languages'},
    {'icon': Icons.photo_camera, 'label': 'Photography'},
    {'icon': Icons.checkroom, 'label': 'Fashion'},
    {'icon': Icons.nature, 'label': 'Nature'},
    {'icon': Icons.fitness_center, 'label': 'Gym'},
    {'icon': Icons.pets, 'label': 'Animal'},
    {'icon': Icons.brush, 'label': 'Arts'},
    {'icon': Icons.sports_soccer, 'label': 'Football'},
    {'icon': Icons.attach_money, 'label': 'Finance'},
    {'icon': Icons.computer, 'label': 'Technology'},
    {'icon': Icons.business, 'label': 'Business'},
    {'icon': Icons.airplanemode_active, 'label': 'Travel'},
    {'icon': Icons.directions_car, 'label': 'Cars'},
  ];
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

      // Get the logged-in user's email (this will be the document ID in Firestore)

      setState(() {
        selectlat = _currentLatLng?.latitude;
        selectlong = _currentLatLng?.longitude;
      });
    } catch (e) {
      print(e);
    }
  }

  int _selectedgender = 2;

  final preferance = TextEditingController();
  final name = TextEditingController();
  final age = TextEditingController();
  final education = TextEditingController();
  final email = TextEditingController();
  bool passwordshow = true;
  String? selectedgender;

  final List<String> genders = ["Male", "Female", "Other"];
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final currentUser = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                                                   appBar: AppBar(
               toolbarHeight:height/400,
               foregroundColor: const Color.fromARGB(255, 255, 255, 255),
               automaticallyImplyLeading: false,
             backgroundColor: const Color.fromARGB(255, 255, 255, 255),
             surfaceTintColor:const Color.fromARGB(255, 255, 255, 255),
             ),
      body: Container(
        height: height,
        width: width,
        color: Color.fromARGB(255, 255, 255, 255),
        padding: EdgeInsets.only(
          bottom: height / 60,
          right: width / 20,
          left: width / 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress bar and back button
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
                        "Match Couples",
                        style: TextStyle(
                            color: const Color(0xff26150F),
                            fontFamily: "defaultfontsbold",
                            fontWeight: FontWeight.w500,
                            fontSize: 24),
                      ),
                    ),
                  ),
                  SizedBox(width: width / 15),
                ],
              ),
              SizedBox(height: height / 60),
           const   Text(
                "Fill in the details to find a match!",
                style: TextStyle(
                    color: const Color(0xff7905F5),
                    fontFamily: "defaultfontsbold",
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
              SizedBox(height: height / 70),
    
              // CoupleMatchingPage chip
              Padding(
                padding: EdgeInsets.only(
                  bottom: height / 47,
                ),
                child: TextField(
                  style: Theme.of(context).textTheme.headlineSmall,
                  controller: name,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Name',
                    contentPadding:
                        EdgeInsets.only(left: width / 50, top: height / 90),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: height / 47,
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: Theme.of(context).textTheme.headlineSmall,
                  controller: age,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Age',
                    contentPadding:
                        EdgeInsets.only(left: width / 50, top: height / 90),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: height / 47,
                ),
                child: DropdownButtonFormField<String>(
                  value: selectedgender,
                  style: Theme.of(context).textTheme.headlineSmall,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    contentPadding:
                        EdgeInsets.only(left: width / 50, top: height / 90),
                    hintText: "Gender",
                  ),
                  items: genders.map((String district) {
                    return DropdownMenuItem<String>(
                      value: district,
                      child: Text(
                        district,
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedgender = newValue;
                      if (selectedgender == "Male") {
                        _selectedgender = 0;
                      } else if (selectedgender == "Female") {
                        _selectedgender = 1;
                      } else if (selectedgender == "Other") {
                        _selectedgender = 2;
                      }
                    });
                  },
                ),
              ),
    
              Text(
                'Interested In',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              // Interest Chips
              Padding(
                padding: EdgeInsets.only(
                    bottom: height / 47, left: width / 40, top: height / 90),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children:
                      List<Widget>.generate(_interests.length, (int index) {
                    return ChoiceChip(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        avatar: Icon(_interests[index]['icon'],
                            size: 18, color: Color(0xff565656)),
                        label: Text(
                          _interests[index]['label'],
                          style: TextStyle(
                              color: _selectedInterestIndices
         .contains(_interests[index]['label']) ?
                              Colors.white:
                               const Color.fromARGB(255, 55, 55, 55),
                              fontFamily: "defaultfontsbold",
                              fontSize: height / 55),
                        ),
                        selected: 
                        _selectedInterestIndices
                            .contains(_interests[index]['label']),
                        onSelected: (bool selected) {
                          _setSelectedInterestsAndIcons(
                              selected, _interests[index]);
                        },
                        selectedColor:
                            const Color.fromARGB(255, 171, 108, 238),
                        backgroundColor: Color(0xffD9D9D9));
                  }),
                ),
              ),
              // Distance Slider
    
              Padding(
                padding: EdgeInsets.only(
                  bottom: height / 47,
                ),
                child: TextField(
                  controller: education,
                  style: Theme.of(context).textTheme.headlineSmall,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Education',
                    contentPadding:
                        EdgeInsets.only(left: width / 50, top: height / 50),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: height / 30,
                ),
                child: TextField(
                  onTap: () {
                    _openMap(7.8731, 80.7718);
                  }, // Open map when tapping
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
                    suffixIcon: Icon(
                      Icons.location_pin,
                      color: Color(0xff565656),
                      size: height / 40,
                    ),
                  ),
                ),
              ),
    
              Padding(
                padding: EdgeInsets.only(bottom: height / 47),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent),
                  height: height / 6,
                  child: TextField(
                    controller: preferance,
                    maxLines: 10,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(left: width / 50, top: height / 90),
                      hintText: 'Preferences',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xff8F9DA6)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xff8F9DA6)),
                      ),
                    ),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
              // Submit button
              Padding(
                padding: EdgeInsets.only(
                    top: height / 30,
                    bottom: height / 30,
                    left: width / 22,
                    right: width / 22),
                child: GestureDetector(
                  onTap: () async {
                    if (selectlat != 0 &&
                        selectlong != 0 &&
                        selectedgender.toString().isNotEmpty &&
                        _selectedInterestIndices.toString().isNotEmpty &&
                        age.toString().isNotEmpty) {
                    
                    
                    
                    
                    
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => matchingfilter(
                              selectedGender: _selectedgender,
                              selectedInterests: _selectedInterestIndices,
                              ageRange: 
                              RangeValues(
                                  double.tryParse(age.text.trim()) ??
                                      0.0, // Fallback to 0.0 if parsing fails
                                  double.tryParse(age.text.trim()) ?? 0.0),
                              distanceRange: RangeValues(0, 100),
                              userLatitude: selectlat ?? 0,
                              userLongitude: selectlong ?? 0,
                              useremail: currentUser.email!, Gender: selectedgender.toString(),),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Fill the lines')),
                      );
                    }
    
                    // return Singupcheck(currentUser);
                  },
                  child: Container(
                    height: height / 15,
                    width: width,
                    decoration: BoxDecoration(
                      color: const Color(0xff7905F5),
                      borderRadius: BorderRadius.circular(height / 10),
                    ),
                    child: Center(
                      child: Text(
                        "Find a match",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setSelectedInterestsAndIcons(
      bool selected, Map<String, dynamic> interest) {
    setState(() {
      if (selected) {
        _selectedInterestIndices.add(interest['label']);
        _selectedInterestIcons
            .add(interest['icon'].codePoint); // Store icon codePoint
      } else {
        _selectedInterestIndices.remove(interest['label']);
        _selectedInterestIcons.remove(interest['icon'].codePoint);
      }
    });
  }

  Future Singupcheck(User currentuserlog) async {
    if (name.text.isNotEmpty &&
        email.text.isNotEmpty &&
        education.text.isNotEmpty &&
        selectedgender.toString().isNotEmpty &&
        age.text.isNotEmpty) {
      try {
        FirebaseFirestore.instance
            .collection("test")
            .doc(email.text.trim())
            .set({
          'name': name.text.trim(),
          'email': email.text.trim(),
          'Address': '',
          'Age': int.parse(age.text.toString()),
          'Gender': selectedgender,
          'Icon': [],
          'Interest': [],
          'Phonenumber': '',
          'X': 0.0,
          'Y': 0.0,
          'images': [],
          'profile_pic': '',
          'lastSeen': FieldValue.serverTimestamp(),
          'status': 'Online',
          'height': '0cm',
          "languages": ['English'],
          'education': education.text.trim(),
        });
        try {
          // Get the logged-in user's email (this will be the document ID in Firestore)
          if (_currentAddress.toString().isNotEmpty &&
              _currentLatLng.toString().isNotEmpty) {
            // Upload the image to Firebase Storage
            await FirebaseFirestore.instance
                .collection('test')
                .doc(email.text.trim())
                .update({
              'X': _currentLatLng?.latitude,
              "Y": _currentLatLng?.longitude,
              'Address': _currentAddressDB
            });

            // FirebaseFirestore.instance
            // .collection("Ambassdor")
            // .doc(currentuserlog.email!)
            // .update({
            // 'addedusers':[email.text.trim()],
            // });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Location added Successfully')),
            );
            // Navigator.of(context).push(MaterialPageRoute(
            // builder: (context) {
            // return completeprofile();
            // },
            // ));
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Account Created!!",
            style: TextStyle(color: Colors.white),
          ),
        ));
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return A_Interest(
              email: email.text.trim(),
            );
          },
        ));
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "${e.message}",
            style: TextStyle(color: Colors.red),
          ),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Fill the lines"),
      ));
    }
  }
  // Store selected CoupleMatchingPages and icon codePoints
}
