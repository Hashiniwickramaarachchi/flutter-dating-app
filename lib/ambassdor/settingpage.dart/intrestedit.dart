import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class A_interestedit extends StatefulWidget {
  const A_interestedit({super.key});

  @override
  State<A_interestedit> createState() => _interesteditState();
}

class _interesteditState extends State<A_interestedit> {
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
      if (mounted) {
        
      
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Languages updated successfully!')));
      }
    } catch (e) {
      if (mounted) {
        
      
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating languages: $e')));
      }
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
      if (mounted) {
        
      
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$interest added successfully!')));
      }
    } catch (e) {
      if (mounted) {
        
      
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error adding interest: $e')));
      }
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
      if (mounted) {
        
      
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$interest removed successfully!')));
      }
    } catch (e) {
      if (mounted) {
        
      
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error removing interest: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final curentuser = FirebaseAuth.instance.currentUser!;

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      height: height,
      width: width,
      child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Ambassdor")
              .doc(curentuser.email!)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userdataperson =
                  snapshot.data!.data() as Map<String, dynamic>;

              return Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: width / 15, right: width / 15, top: height / 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: List<Widget>.generate(_interests.length,
                              (int index) {
                            return ChoiceChip(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              avatar: Icon(_interests[index]['icon'], size: 20),
                              label: Text(_interests[index]['label']),
                              selected: _selectedInterestIndices
                                  .contains(_interests[index]['label']),
                              onSelected: (bool selected) {
                                if (selected) {
                                  _addInterestToFirestore(
                                      curentuser.email!,
                                      _interests[index]['label'],
                                      _interests[index]['icon'].codePoint);
                                } else {
                                  _removeInterestFromFirestore(
                                      curentuser.email!,
                                      _interests[index]['label'],
                                      _interests[index]['icon'].codePoint);
                                }
                                setState(() {
                                  _setSelectedInterestsAndIcons(
                                      selected, _interests[index]);
                                });
                              },
                              selectedColor:
                                  const Color.fromARGB(255, 121, 5, 245),
                              backgroundColor: Colors.grey[300],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else {
              return Center(
                  child: Container(
                      height: height / 50,
                      width: width / 50,
                      child: CircularProgressIndicator(
                        color: Color(
                          0xff7905F5,
                        ),
                      )));
            }
          }),
    );
  }

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
