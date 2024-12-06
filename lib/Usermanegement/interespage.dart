import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/Usermanegement/imageadding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Interest extends StatefulWidget {
  const Interest({super.key});

  @override
  State<Interest> createState() => _InterestState();
}

class _InterestState extends State<Interest> {
  final Set<String> _selectedInterestIndices = {}; // Store multiple selections
  final List<int> _selectedInterestIcons =
      []; // Store icon codePoints as integers
  final TextEditingController description = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final currentUser = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height / 400,
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
        height: height,
        width: width,
        color: Color.fromARGB(255, 255, 255, 255),
        padding: EdgeInsets.only(
          bottom: height / 60,
          right: width / 30,
          left: width / 30,
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
                      value: 0.75, // Shows progress from 0.0 to 1.0
                      minHeight: 10.0, // Adjust height of progress bar
                      color: const Color.fromARGB(255, 121, 5, 245),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(width: width / 20),
                  Text(
                    "3/4",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  SizedBox(width: width / 10),
                ],
              ),
              SizedBox(height: height / 60),
              Center(
                child: Text(
                  "Select your interests!",
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
                  "To give you better experience we need to know about you",
                  style: TextStyle(
                      color: const Color(0xff7D7676),
                      fontWeight: FontWeight.bold,
                      fontFamily: "defaultfontsbold",
                      fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: height / 70),

              // Interest chips
              Center(
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
                        avatar: Icon(
                          _interests[index]['icon'],
                          size: 20,
                          color: _selectedInterestIndices
                                  .contains(_interests[index]['label'])
                              ? Colors.white
                              : Color(0xff565656),
                        ),
                        label: Text(
                          _interests[index]['label'],
                          style: TextStyle(
                              color: _selectedInterestIndices
                                      .contains(_interests[index]['label'])
                                  ? Colors.white
                                  : const Color.fromARGB(255, 55, 55, 55),
                              fontFamily: "defaultfontsbold",
                              fontSize: 15),
                        ),
                        selected: _selectedInterestIndices
                            .contains(_interests[index]['label']),
                        onSelected: (bool selected) {
                          _setSelectedInterestsAndIcons(
                              selected, _interests[index]);
                        },
                        showCheckmark: false,
                        selectedColor: const Color.fromARGB(255, 171, 108, 238),
                        backgroundColor: Color(0xffD9D9D9));
                  }),
                ),
              ),

              // Add others text field
              Padding(
                padding: EdgeInsets.only(
                    left: width / 22,
                    bottom: height / 90,
                    top: height / 50,
                    right: width / 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Add others",
                      style: TextStyle(
                          color: const Color(0xff464646),
                          fontFamily: "defaultfonts",
                          fontWeight: FontWeight.w900,
                          fontSize: 18),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff7905F5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        if (description.text.isNotEmpty) {
                          setState(() {
                            // Add custom interest only if it's not already in the selected set
                            if (!_selectedInterestIndices
                                .contains(description.text)) {
                              _interests.add({
                                'icon': Icons.star,
                                'label': description.text.trim()
                              });

                              setState(() {
                                _selectedInterestIndices
                                    .add(description.text.trim());
                                _selectedInterestIcons.add(Icons.star
                                    .codePoint); // Use null for custom icons
                              });
                             }
                          });
                          description
                              .clear(); // Clear the input field after adding
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Please enter an interest to add.')),
                          );
                        }
                      },
                      child: Text(
                        "Add",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: width / 22, right: width / 22),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xfddD9D9D9)),
                  height: height / 6,
                  child: TextField(
                    controller: description,
                    maxLines: 10,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(left: width / 50, top: height / 90),
                      hintText: "",
                      hintStyle:
                          TextStyle(color: Colors.black, fontSize: height / 60),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Color(0xffD9D9D9)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Color(0xffD9D9D9)),
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
                    print(_selectedInterestIcons);
                    await _updateFirestore(currentUser);
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

  // Store selected interests and icon codePoints
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

  // Update Firestore with interest and icon data
  // Future<void> _updateFirestore(User currentUser) async {
  // try {
  // if (_selectedInterestIndices.isNotEmpty &&
  // _selectedInterestIcons.isNotEmpty) {
  // await FirebaseFirestore.instance
  // .collection('users')
  // .doc(currentUser.email!)
  // .update({
  // "Interest": FieldValue.arrayUnion(_selectedInterestIndices.toList()),
  // "Icon": FieldValue.arrayUnion(_selectedInterestIcons.toList()),
  // });
//
  // ScaffoldMessenger.of(context).showSnackBar(
  // const SnackBar(content: Text('Profile updated successfully!')),
  // );
  // Navigator.of(context).push(MaterialPageRoute(
  // builder: (context) {
  // return imageadding();
  // },
  // ));
  // } else {
  // ScaffoldMessenger.of(context).showSnackBar(
  // const SnackBar(content: Text('Select interests before proceeding')),
  // );
  // }
  // } catch (e) {
  // print('Error updating profile: $e');
  // ScaffoldMessenger.of(context).showSnackBar(
  // const SnackBar(content: Text('Failed to update profile.')),
  // );
  // }
  // }
  // Future<void> _updateFirestore(User currentUser) async {
  // try {
  // if (_selectedInterestIndices.isNotEmpty) {
  // final interests = _selectedInterestIndices.toList();
  // final icons = _selectedInterestIcons..toList(); // Use 0 as a placeholder for null
  // print(_selectedInterestIcons..toList());
//
  // await FirebaseFirestore.instance
  // .collection('users')
  // .doc(currentUser.email!)
  // .update({
  // "Interest": FieldValue.arrayUnion(interests),
  // "Icon": FieldValue.arrayUnion(_selectedInterestIcons..toList()),
  // });
//
  // ScaffoldMessenger.of(context).showSnackBar(
  // const SnackBar(content: Text('Profile updated successfully!')),
  // );
  // Navigator.of(context).push(MaterialPageRoute(
  // builder: (context) {
  // return imageadding();
  // },
  // ));
  // } else {
  // ScaffoldMessenger.of(context).showSnackBar(
  // const SnackBar(content: Text('Select interests before proceeding')),
  // );
  // }
  // } catch (e) {
  // print('Error updating profile: $e');
  // ScaffoldMessenger.of(context).showSnackBar(
  // const SnackBar(content: Text('Failed to update profile.')),
  // );
  // }
// }

  Future<void> _updateFirestore(User currentUser) async {
    try {
      if (_selectedInterestIndices.isNotEmpty) {
        // Fetch current Firestore data
        final docRef = FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.email!);
        final snapshot = await docRef.get();

        // Get existing data or set default
        List<dynamic> existingInterests = snapshot.data()?['Interest'] ?? [];
        List<dynamic> existingIcons = snapshot.data()?['Icon'] ?? [];

        // Add new interests and icons to existing lists
        final updatedInterests = [
          ...existingInterests,
          ..._selectedInterestIndices
        ];
        final updatedIcons = [...existingIcons, ..._selectedInterestIcons];

        // Update Firestore with new lists
        await docRef.update({
          "Interest": updatedInterests,
          "Icon": updatedIcons,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );

        // Navigate to the next screen
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return const imageadding(); // Replace with your next screen
          },
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one interest!')),
        );
      }
    } catch (e) {
      // Log error for debugging
      print('Error updating profile: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile. Try again.')),
      );
    }
  }
}
