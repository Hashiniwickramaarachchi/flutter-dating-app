import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/Usermanegement/manualadding.dart';
import 'package:datingapp/filterrexultpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class filterpage extends StatefulWidget {
  const filterpage({super.key});

  @override
  State<filterpage> createState() => _filterpageState();
}

class _filterpageState extends State<filterpage> {
  int _selectedgender = 2;
  final Set<String> _selectedInterestIndices = {}; // Store multiple selections
  final Set<int> _selectedInterestIcons =
      {}; // Store icon codePoints as integers
  LatLng? _currentLatLng; // To store the selected location coordinates
  String? _currentAddress; // To store the reverse geocoded address
  String? _currentAddressDB;
  double? selectlat;
  double? selectlong;
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

  // Interests with icons and labels
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

  // Initial values for the range slider
  RangeValues _currentRangeValues = const RangeValues(10, 30);
  RangeValues _currentRangeValuesage = const RangeValues(18, 78);

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
            return Container(
              width: width,
              height: height/1.2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    left: width / 15, right: width / 15, top: height / 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: 
                      Text(
                        "Filter",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontFamily: "defaultfontsbold",
                            fontWeight: FontWeight.bold,
                            fontSize: height / 45),
                      ),
                    ),
                    Container(
                      height: height/1.3,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: width / 32,
                                  bottom: height / 70,
                                  top: height / 30),
                              child: Text(
                                'Location',
                                style: TextStyle(
                                    color: const Color(0xff4D4D4D),
                                    fontFamily: "defaultfontsbold",
                                    fontWeight: FontWeight.bold,
                                    fontSize: height / 50),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 32),
                              child: TextField(
                                onTap: () {
                                  _openMap(
                                      userdataperson['X'], userdataperson["Y"]);
                                }, // Open map when tapping
                                readOnly: true,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                                decoration: InputDecoration(
                                  hintText: _currentAddress ?? "Your Location",
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: Color(0xff8F9DA6)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: Color(0xff8F9DA6)),
                                  ),
                                  contentPadding: EdgeInsets.only(
                                      left: width / 50, top: height / 50),
                                  prefixIcon: Icon(
                                    Icons.navigation,
                                    color: Color(0xff565656),
                                    size: height / 40,
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(
                                  left: width / 32,
                                  bottom: height / 70,
                                  top: height / 50),
                              child: Text(
                                'Sort By',
                                style: TextStyle(
                                    color:
                                     const Color(0xff4D4D4D),
                                    fontFamily: "defaultfontsbold",
                                    fontWeight: FontWeight.bold,
                                    fontSize: height / 50),
                              ),
                            ),
                            // Gender Selector
                            buildOptionSelector(3, _selectedgender,
                                (value, gender) {
                              setState(() {
                                _selectedgender = value;
                              });
                            }, width, height),

                            // Interested In Title
                            Padding(
                              padding: EdgeInsets.only(
                                  left: width / 32, top: height / 50),
                              child: Text(
                                'Interested In',
                                style: TextStyle(
                                    color: const Color(0xff4D4D4D),
                                    fontFamily: "defaultfontsbold",
                                    fontWeight: FontWeight.bold,
                                    fontSize: height / 50),
                              ),
                            ),

                            // Interest Chips
                            Padding(
                              padding: EdgeInsets.only(
                                  top: height / 70, left: width / 40),
                              child: Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: List<Widget>.generate(
                                    _interests.length, (int index) {
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
                                            color:
                                               _selectedInterestIndices
      .contains(_interests[index]['label']) ?Colors.white:
                                             const Color.fromARGB(
                                                255, 55, 55, 55),
                                                
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
                                      selectedColor: const Color.fromARGB(
                                          255, 171, 108, 238),
                                      backgroundColor: Color(0xffD9D9D9));
                                }),
                              ),
                            ),

                            // Distance Slider
                            buildRangeSlider(width, height),

                            buildRangeSliderage(width, height),

                            Padding(
                              padding: EdgeInsets.only(
                                  top: height / 50, bottom: height / 50),
                              child: Container(
                                width: width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        selectlat = 0;
                                        _currentAddress = '';
                                        selectlong = 0;
                                        _selectedInterestIndices.clear();

                                        setState(() {
                                          _currentRangeValues =
                                              const RangeValues(10, 30);
                                        });

                                        _currentRangeValuesage =
                                            RangeValues(18, 28);

                                        print(selectlat);
                                      },
                                      child: Container(
                                        width: width / 2.5,
                                        height: height / 16,
                                        decoration: BoxDecoration(
                                          color: Color(0xffD9D9D9),
                                          borderRadius: BorderRadius.circular(
                                              height / 10),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Clear",
                                            style: TextStyle(
                                                color: Color(0xff7905F5),
                                                fontFamily: "defaultfontsbold",
                                                fontWeight: FontWeight.bold,
                                                fontSize: height / 45),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        if (selectlat != 0 &&
                                            selectlong != 0 &&
                                            _selectedgender
                                                .toString()
                                                .isNotEmpty &&
                                            _selectedInterestIndices
                                                .toString()
                                                .isNotEmpty &&
                                            _currentRangeValues
                                                .toString()
                                                .isNotEmpty &&
                                            _currentRangeValuesage
                                                .toString()
                                                .isNotEmpty) {
                                          print(_selectedInterestIcons);
                                          print(_selectedgender);
                                          print(_currentRangeValuesage);
                                          print(_currentRangeValues);

                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FilterResultsMapPage(
                                                selectedGender: _selectedgender,
                                                selectedInterests:
                                                    _selectedInterestIndices,
                                                ageRange:
                                                    _currentRangeValuesage,
                                                distanceRange:
                                                    _currentRangeValues,
                                                userLatitude: selectlat ?? 0,
                                                userLongitude: selectlong ?? 0,
                                                useremail:
                                                    userdataperson['email'],
                                              ),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content:
                                                    Text('Fill the lines')),
                                          );
                                        }
                                      },
                                      child: Container(
                                        width: width / 2.5,
                                        height: height / 16,
                                        decoration: BoxDecoration(
                                          color: Color(0xff7905F5),
                                          borderRadius: BorderRadius.circular(
                                              height / 10),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Next",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "defaultfontsbold",
                                                fontWeight: FontWeight.bold,
                                                fontSize: height / 45),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
            return CircularProgressIndicator();
          }
        });
  }

  // Function to build range slider similar to your image

  Widget buildRangeSlider(width, height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: width / 32, top: height / 50),
          child: Text(
            'Distance',
            style: TextStyle(
                color: const Color(0xff4D4D4D),
                fontFamily: "defaultfontsbold",
                fontWeight: FontWeight.bold,
                fontSize: height / 50),
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 8.0, // Increase this value to make the track thicker
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius:
                  12.0, // Increase this value to make the thumb larger
            ),
            overlayShape: RoundSliderOverlayShape(
              overlayRadius:
                  24.0, // Increase this value to make the thumb's overlay larger
            ),
            thumbColor: Color(0xff7905F5),
            activeTrackColor: Color(0xff7905F5),
            // Customize active track color
            inactiveTrackColor:
                Color(0xffD9D9D9), // Customize inactive track color
          ),
          child: RangeSlider(
            values: _currentRangeValues,
            min: 0,
            max: 50,
            divisions: 5,
            labels: RangeLabels(
              '${_currentRangeValues.start.round()}km',
              '${_currentRangeValues.end.round()}km',
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _currentRangeValues = values;
              });
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 28),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0km',
                  style: TextStyle(color: Colors.black, fontSize: height / 60)),
              Text('10km',
                  style: TextStyle(color: Colors.black, fontSize: height / 60)),
              Text('20km',
                  style: TextStyle(color: Colors.black, fontSize: height / 60)),
              Text('30km',
                  style: TextStyle(color: Colors.black, fontSize: height / 60)),
              Text('40km',
                  style: TextStyle(color: Colors.black, fontSize: height / 60)),
              Text('50km',
                  style: TextStyle(color: Colors.black, fontSize: height / 60)),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildRangeSliderage(width, height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: width / 32, top: height / 50),
          child: Text(
            'Age',
            style: TextStyle(
                color: const Color(0xff4D4D4D),
                fontFamily: "defaultfontsbold",
                fontWeight: FontWeight.bold,
                fontSize: height / 50),
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 8.0, // Increase this value to make the track thicker
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius:
                  12.0, // Increase this value to make the thumb larger
            ),
            overlayShape: RoundSliderOverlayShape(
              overlayRadius:
                  24.0, // Increase this value to make the thumb's overlay larger
            ),

            thumbColor: Color(0xff7905F5),
            activeTrackColor: Color(0xff7905F5),
            // Customize active track color
            inactiveTrackColor:
                Color(0xffD9D9D9), // Customize inactive track color
          ),
          child: RangeSlider(
            values: _currentRangeValuesage,
            min: 18,
            max: 78,
            divisions: 6,
            labels: RangeLabels(
              '${_currentRangeValuesage.start.round()}',
              '${_currentRangeValuesage.end.round()}',
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _currentRangeValuesage = values;
              });
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 28),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('18',
                  style: TextStyle(color: Colors.black, fontSize: height / 60)),
              Text('28',
                  style: TextStyle(color: Colors.black, fontSize: height / 60)),
              Text('38',
                  style: TextStyle(color: Colors.black, fontSize: height / 60)),
              Text('48',
                  style: TextStyle(color: Colors.black, fontSize: height / 60)),
              Text('58',
                  style: TextStyle(color: Colors.black, fontSize: height / 60)),
              Text('68',
                  style: TextStyle(color: Colors.black, fontSize: height / 60)),
              Text('78',
                  style: TextStyle(color: Colors.black, fontSize: height / 60)),
            ],
          ),
        ),
      ],
    );
  }

  // Function to build additional slider with label

  // Function to handle interest selection and storing icon data
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

  // Function to build gender option selector
  Widget buildOptionSelector(int count, int selectedValue,
      Function(int, String) onTap, double width, double height) {
    List<Widget> options = [];
    for (int i = 1; i <= count; i++) {
      String gender;
      if (i == 1) {
        gender = "Male";
      } else if (i == 2) {
        gender = "Female";
      } else {
        gender = "Both";
      }

      options.add(
        GestureDetector(
          onTap: () {
            onTap(i, gender); // Pass both index and gender to onTap function
          },
          child: Container(
            width: width / 4,
            height: height / 20,
            decoration: BoxDecoration(
              color: selectedValue == i
                  ? const Color.fromARGB(255, 171, 108, 238)
                  : Color(0xffD9D9D9),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.transparent),
            ),
            child: Center(
              child: Text(
                gender,
                style: TextStyle(
                  fontFamily: "defaultfontsbold",
                  fontSize: height / 55,
                  color: selectedValue == i ?
                  Colors.white:
                  const Color.fromARGB(255, 55, 55, 55)
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: options,
    );
  }
}
