import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/ambassdor/settingpage.dart/intrestedit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class A_UpdateProfilePage extends StatefulWidget {
  @override
  _A_UpdateProfilePageState createState() => _A_UpdateProfilePageState();
}

class _A_UpdateProfilePageState extends State<A_UpdateProfilePage> {
  // Dropdown values
  String? selectedAge;
  String? selectedHeight;
  String? selectedLanguage;
  final education = TextEditingController();
    final description = TextEditingController();


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

  List<String> ageList = List.generate(100, (index) => (index + 1).toString());
         List<String> heightList = ["0 cm"] + List.generate(100, (index) => "${100 + index} cm");


  final Set<String> _selectedInterestIndices = {}; // Store multiple selections
  final Set<int> _selectedInterestIcons =
      {}; // Store icon codePoints as integers

  List<String> languages = [
    "English",
    "Chinese",
    "Spanish",
    "French",
    "German"
  ];
  List<dynamic> selectedLanguages = []; // To store the selected languages
  Future<void> _updateLanguagesInFirestore(String userEmail) async {
    try {
      // Add new languages using arrayUnion
      await FirebaseFirestore.instance
          .collection('Ambassdor')
          .doc(userEmail)
          .update({
        'languages': FieldValue.arrayUnion(selectedLanguages),
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Languages updated successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating languages: $e')));
    }
  }

  Future<void> _addInterestToFirestore(
      String userEmail, String interest, int iconCode) async {
    try {
      await FirebaseFirestore.instance
          .collection('Ambassdor')
          .doc(userEmail)
          .update({
        'Interest': FieldValue.arrayUnion([interest]),
        'Icon': FieldValue.arrayUnion([iconCode]),
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$interest added successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error adding interest: $e')));
    }
  }

  // Function to remove interest and icon from Firebase
  Future<void> _removeInterestFromFirestore(
      String userEmail, String interest, int iconCode) async {
    try {
      await FirebaseFirestore.instance
          .collection('Ambassdor')
          .doc(userEmail)
          .update({
        'Interest': FieldValue.arrayRemove([interest]),
        'Icon': FieldValue.arrayRemove([iconCode]),
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$interest removed successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error removing interest: $e')));
    }
  }

  Future<void> _removeLanguageFromFirestore(
      String userEmail, String language) async {
    try {
      // Remove language using arrayRemove
      await FirebaseFirestore.instance
          .collection('Ambassdor')
          .doc(userEmail)
          .update({
        'languages': FieldValue.arrayRemove([language]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Language removed successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error removing language: $e')));
    }
  }

  Future<void> _updateProfile(String userEmail) async {
    try {
      // Update Firestore with new data, excluding languages (which are handled separately)
      await FirebaseFirestore.instance
          .collection('Ambassdor')
          .doc(userEmail)
          .update({
        'education': education.text.trim(),
        'Age': int.tryParse(selectedAge.toString()), // Update age as integer
        'height': selectedHeight,
        'description':description.text.trim()
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;

    final curentuser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Ambassdor")
            .doc(curentuser.email!)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userdataperson =
                snapshot.data!.data() as Map<String, dynamic>;

            // Set existing data if available
            if (education.text.isEmpty) {
              education.text = userdataperson['education'] ?? '';
            }
  if (description.text.isEmpty) {
    description.text = userdataperson['description'] ?? '';
  }
            // education.text = education.text.toString() ?? userdataperson['education'];
            selectedAge = selectedAge ?? userdataperson['Age'].toString();
            selectedHeight =
                selectedHeight ?? userdataperson['height'].toString();
            selectedLanguages = List.from(userdataperson['languages'] ?? []);
            _selectedInterestIndices
                .addAll(List<String>.from(userdataperson['Interest'] ?? []));
            _selectedInterestIcons
                .addAll(List<int>.from(userdataperson['Icon'] ?? []));

            return Scaffold(
                appBar: AppBar(
         toolbarHeight:deviceHeight/400,
         foregroundColor: const Color.fromARGB(255, 255, 255, 255),
         automaticallyImplyLeading: false,
     backgroundColor: const Color.fromARGB(255, 255, 255, 255),
     surfaceTintColor:const Color.fromARGB(255, 255, 255, 255),
     ),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              body: Container(
                color: Color.fromARGB(255, 255, 255, 255),
                height: deviceHeight,
                width: deviceWidth,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: deviceHeight / 60,
                      right: deviceWidth / 20,
                      left: deviceWidth / 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: deviceWidth / 60),
                          child: Row(
                            children: [
                              Container(
                                height: deviceHeight / 10,
                                width: deviceWidth / 10,
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
                                    color: const Color.fromARGB(
                                        255, 121, 5, 245),
                                  ),
                                ),
                              ),
                              SizedBox(width: deviceWidth / 20),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Personal Information",
                                    style: TextStyle(
                                        color: const Color(0xff26150F),
                                        fontFamily: "defaultfontsbold",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                              SizedBox(width: deviceWidth / 20)
                            ],
                          ),
                        ),
                                                SizedBox(height: 20,),
                                          Text(
                  'Description',
                  style: TextStyle(
                      color: const Color(0xff4D4D4D),
                      fontFamily: "defaultfontsbold",
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                SizedBox(height: 10),
                // ),
                      
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent),
                  height: deviceHeight / 6,
                  child: TextField(
                    controller: description,
                    maxLines: 10,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: deviceWidth / 50,
                          top: deviceHeight / 90),
                      hintText: 'Enter description',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Color(0xff8F9DA6)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Color(0xff8F9DA6)),
                      ),
                    ),
                    style:
                        Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                SizedBox(height:20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: deviceHeight / 80),
                              child: Text(
                                'Interest',
                                style: TextStyle(
                                    color: const Color(0xff4D4D4D),
                                    fontFamily: "defaultfontsbold",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  
                                  enableDrag: false,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(50),
                                      topRight: Radius.circular(50),
                                    ),
                                  ),
                                  backgroundColor: Colors.white,
                                  context: context,
                                  builder: (context) {
                                    return A_interestedit();
                                  },
                                );
                              },
                              child: SvgPicture.asset(
                                "images/Group.svg",
                                height: deviceHeight / 50,
                                width: deviceWidth / 50,
                              ),
                            ),
                          ],
                        ),
                            
                        //  Wrap(
                        // spacing: 8.0,
                        // runSpacing: 8.0,
                        // children: List<Widget>.generate(_interests.length, (int index) {
                        // return ChoiceChip(
                        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        // avatar: Icon(_interests[index]['icon'], size: 20),
                        // label: Text(_interests[index]['label']),
                        // selected: _selectedInterestIndices.contains(_interests[index]['label']),
                        // onSelected: (bool selected) {
                        // if (selected) {
                        // _addInterestToFirestore(curentuser.email!, _interests[index]['label'], _interests[index]['icon'].codePoint);
                        // } else {
                        // _removeInterestFromFirestore(curentuser.email!, _interests[index]['label'], _interests[index]['icon'].codePoint);
                        // }
                            
                        // setState(() {
                        // _setSelectedInterestsAndIcons(selected, _interests[index]);
                        // });
                        // },
                        // selectedColor: const Color.fromARGB(255, 121, 5, 245),
                        // backgroundColor: Colors.grey[300],
                        // );
                        // }),
                        // ),
                        //
                            
                        Wrap(
                            spacing: deviceWidth / 90,
                            runSpacing: deviceHeight / 70,
                            children: List<Widget>.generate(
                              userdataperson['Interest'].length,
                              (int index) {
                                return _buildInterestChip(
                                    curentuser.email!,
                                    context,
                                    userdataperson['Interest'][index],
                                    userdataperson['Icon'][index],
                                    deviceHeight);
                              },
                            )),
                            
                        SizedBox(height: 20),
                        // Age Dropdown Section
                        Text(
                          'Age',
                          style: TextStyle(
                              color: const Color(0xff4D4D4D),
                              fontFamily: "defaultfontsbold",
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          dropdownColor: Colors.white,
                          style: Theme.of(context).textTheme.headlineSmall,
                          value: selectedAge,
                          hint: Text("Select Age"),
                          items: ageList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),     
                          onChanged: (value) {
                            setState(() {
                              selectedAge = value;
                            });
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
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
                                left: deviceWidth / 50,
                                top: deviceHeight / 50),
                          ),
                        ),
                        SizedBox(height: 20),
                        // Height Dropdown Section
                        Text(
                          'Height',
                          style: TextStyle(
                              color: const Color(0xff4D4D4D),
                              fontFamily: "defaultfontsbold",
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          dropdownColor: Colors.white,
                          style: Theme.of(context).textTheme.headlineSmall,
                          value: selectedHeight,
                          hint: Text("Select Height",
                              style: TextStyle(color: Colors.black)),
                          items: heightList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedHeight = value;
                              print(selectedHeight);
                            });
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
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
                                left: deviceWidth / 50,
                                top: deviceHeight / 50),
                          ),
                        ),
                        SizedBox(height: 20),
                        // Languages Dropdown and Chips Section
                        Text(
                          'Languages',
                          style: TextStyle(
                              color: const Color(0xff4D4D4D),
                              fontFamily: "defaultfontsbold",
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          dropdownColor: Colors.white,
                          style: Theme.of(context).textTheme.headlineSmall,
                          value: selectedLanguage,
                          hint: Text("Select Language",
                              style: TextStyle(color: Colors.black)),
                          items: languages.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null &&
                                !selectedLanguages.contains(value)) {
                              setState(() {
                                selectedLanguages.add(value);
                                selectedLanguage = value;
                              });
                              _updateLanguagesInFirestore(
                                  curentuser.email!); // Update Firestore
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
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
                                left: deviceWidth / 50,
                                top: deviceHeight / 50),
                          ),
                        ),
                            
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          children: selectedLanguages.map((language) {
                            return Chip(
                              label: Text(language.toString()),
                              backgroundColor: Color(0xffD9D9D9),
                              labelStyle: TextStyle(
                                color: const Color(0xff565656),
                                fontFamily: "defaultfontsbold",
                                fontSize: deviceHeight / 55,
                              ),
                              onDeleted: () {
                                setState(() {
                                  selectedLanguages.remove(language);
                                });
                                _removeLanguageFromFirestore(
                                    curentuser.email!,
                                    language); // Remove from Firestore
                              },
                            );
                          }).toList(),
                        ),
                            
                        SizedBox(height: 20),
                        Text(
                          'Education',
                          style: TextStyle(
                              color: const Color(0xff4D4D4D),
                              fontFamily: "defaultfontsbold",
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        // TextField(
                        // controller: education,
                        // style: Theme.of(context).textTheme.headlineSmall,
                        // decoration: InputDecoration(
                        // hintText: 'Enter Education',
                        // border: OutlineInputBorder(),
                        // ),
                        // ),
                            
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.transparent),
                          height: deviceHeight / 6,
                          child: TextField(
                            controller: education,
                            maxLines: 10,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: deviceWidth / 50,
                                  top: deviceHeight / 90),
                              hintText: 'Enter Education',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Color(0xff8F9DA6)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Color(0xff8F9DA6)),
                              ),
                            ),
                            style:
                                Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        // Center(
                        // child: ElevatedButton(
                        // onPressed: () async {
                        // await _updateProfile(curentuser.email!);
                        // },
                        // child: Text('Update Profile'),
                        // ),
                        // ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: deviceHeight / 40,
                            bottom: deviceHeight / 30,
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              await _updateProfile(curentuser.email!);
                            },
                            child: Container(
                              height: deviceHeight / 15,
                              width: deviceWidth,
                              decoration: BoxDecoration(
                                color: Color(0xff7905F5),
                                borderRadius: BorderRadius.circular(
                                    deviceHeight / 10),
                              ),
                              child: Center(
                                child: Text(
                                  "Update Profile",
                                  style:
                                      Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
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



          return Center(
              child: Container(
                  height: deviceHeight / 50,
                  width: deviceWidth / 50,
                  child: CircularProgressIndicator(
                    color: Color(
                      0xff7905F5,
                    ),
                  )));
        }
        );
  }

  // Update the selected interests set

  void _setSelectedInterestsAndIcons(
      bool selected, Map<String, dynamic> interest) {
    if (selected) {
      _selectedInterestIndices.add(interest['label']);
      _selectedInterestIcons.add(interest['icon'].codePoint);
    } else {
      _selectedInterestIndices.remove(interest['label']);
      _selectedInterestIcons.remove(interest['icon'].codePoint);
    }
  }

  Widget _buildInterestChip(String email, BuildContext context, String label,
      int iconname, final height) {
    return Chip(
        onDeleted: () {
          setState(() {
            _removeInterestFromFirestore(email, label, iconname);
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        avatar: Icon(
          size: 18,
          IconData(iconname, fontFamily: 'MaterialIcons'),
          color: Color(0xff565656),
        ), // Ensure the correct font family
        label: Text(
          label,
          style: TextStyle(
              color: const Color(0xff565656),
              fontFamily: "defaultfontsbold",
              fontSize: height / 55),
        ),
        backgroundColor: Color(0xffD9D9D9));
  }
}
