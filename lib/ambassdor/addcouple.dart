import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/Usermanegement/manualadding.dart';
import 'package:datingapp/ambassdor/interestpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CoupleAddingPage extends StatefulWidget {
  const CoupleAddingPage({super.key});

  @override
  State<CoupleAddingPage> createState() => _CoupleAddingPageState();
}

class _CoupleAddingPageState extends State<CoupleAddingPage> {
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
    } catch (e) {
      print(e);
    }
  }

  final name = TextEditingController();
  final age = TextEditingController();
  final education = TextEditingController();
  final email = TextEditingController();
    final job = TextEditingController();
   final _height =TextEditingController();

  final password = TextEditingController();
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
                  SizedBox(width: width / 10),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: 0.25, // Shows progress from 0.0 to 1.0
                      minHeight: 10.0, // Adjust height of progress bar
                      color: const Color.fromARGB(255, 121, 5, 245),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(width: width / 20),
                  Text(
                    "1/4",
                    style:
                        TextStyle(color: Colors.black, fontSize: height / 50),
                  ),
                  SizedBox(width: width/10,)
                ],
              ),
              SizedBox(height: height / 60),
              Center(
                child: Text(
                  "Add Partner",
                  style: TextStyle(
                      color: const Color(0xff26150F),
                      fontFamily: "defaultfontsbold",
                      fontWeight: FontWeight.w500,
                      fontSize: 24),
                ),
              ),
              SizedBox(height: height / 70),
    
              // CoupleAddingPage chip
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
     ),                  child: DropdownButtonFormField<String>(
                  value: selectedgender,
                  
                  style: TextStyle(fontSize: 5),
                  decoration: InputDecoration(
                    hintStyle: Theme.of(context).textTheme.headlineSmall,
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
              style:    Theme.of(context).textTheme.headlineSmall,
                 
                 
                 
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedgender = newValue;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: height / 47,
                ),
                child: TextField(
                  controller: email,
                  style: Theme.of(context).textTheme.headlineSmall,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Email',
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
                  controller: password,
                  obscureText: passwordshow,
                  style: Theme.of(context).textTheme.headlineSmall,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Password',
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            passwordshow = !passwordshow;
                          });
                        },
                        icon: Icon(
                          passwordshow
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Color(0xff4D4D4D),
                          size: height / 40,
                        )),
                    contentPadding:
                        EdgeInsets.only(left: width / 50, top: height / 50),
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
           controller: _height,
                            maxLength: 3,
                  buildCounter: (BuildContext context, {int? currentLength, bool? isFocused, int? maxLength}) {
   return null; // Hides the counter
 },
           decoration: InputDecoration(
             border: UnderlineInputBorder(),
             hintText: 'Height (cm)',
             contentPadding:
                 EdgeInsets.only(left: width / 50, top: height / 90),
           ),
         ),
       ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: height / 30,
                ),
                child: TextField(
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
                    controller: education,
                    maxLines: 10,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(left: width / 50, top: height / 90),
                      hintText: 'Enter Education',
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
                           Padding(
             padding: EdgeInsets.only(
               bottom: height / 47,
             ),
             child: TextField(
               style: Theme.of(context).textTheme.headlineSmall,
               controller: job,
               decoration: InputDecoration(
                 border: UnderlineInputBorder(),
                 hintText: 'Job',
                 contentPadding:
                     EdgeInsets.only(left: width / 50, top: height / 90),
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
                    return Singupcheck(currentUser);
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
                        "Next",
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

  Future Singupcheck(User currentuserlog) async {
    if (name.text.isNotEmpty &&
        password.text.isNotEmpty &&
        email.text.isNotEmpty &&
        education.text.isNotEmpty &&
        selectedgender.toString().isNotEmpty &&
        _height.text.isNotEmpty&&
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
          'height': "${_height.text.trim()} cm",
          "languages": ['English'],
          'education': education.text.trim(),
          'description':'',
          'job':job.text.trim(),
                    'created':FieldValue.serverTimestamp(),
                              'profile': "standard"


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
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "Account Created!!",
        style: TextStyle(color: Colors.white),
      ),
    ));
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return A_Interest(email:email.text.trim() ,);
      },
    ));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add location: $e')),
          );
        }
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
  // Store selected CoupleAddingPages and icon codePoints
}
