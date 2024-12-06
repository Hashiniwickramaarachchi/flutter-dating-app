import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/accountdelectionpage.dart';
import 'package:datingapp/block.dart';
import 'package:datingapp/bootmnavbar.dart';
import 'package:datingapp/deactivepage.dart';
import 'package:datingapp/homepage.dart';
import 'package:datingapp/premium/allpremiumusers.dart';
import 'package:datingapp/settingpage.dart/setting&activitypage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
   File? _image;
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _pickImage(String email) async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        await _uploadImage(email);
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> _uploadImage(String email) async {
    if (_image == null) return;

    final storageRef = _storage.ref().child('profile_pics/${email}');
    try {
      // Upload image to Firebase Storage
      final uploadTask = await storageRef.putFile(_image!);
      final imageUrl = await uploadTask.ref.getDownloadURL();

      // Update Firestore
      await _firestore
          .collection('users')
          .doc(email)
          .update({'profile_pic': imageUrl});

      print("Profile picture updated successfully!");
    } catch (e) {
      print("Error uploading image: $e");
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
  ];
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
   final User? curentuser = FirebaseAuth.instance.currentUser;
   if (curentuser == null) {
     // Handle unauthenticated user state (e.g., redirect to login page or sh
     return Center(child: Text('No user is logged in.'));
   }    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(curentuser.email!)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
          // Check if data exists before casting to Map<String, dynamic>
          final userData = snapshot.data!.data() as Map<String, dynamic>?;

     
                 if (userData?['statusType'] == 'deactive') {
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
            if (userData?['statusType'] == 'block') {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                if (mounted) {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => block()),
                    (Route<dynamic> route) => false,
                  );
                }
              });
            }

            if (userData?['statusType'] == 'delete') {
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

            if (userData == null) {
              return Center(
                child: Text("User data not found."),
              );
            }
     
     
     
                final profilePic = userData['profile_pic'] ?? '';

        

            return Scaffold(
              appBar: AppBar(
                toolbarHeight: height / 400,
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                automaticallyImplyLeading: false,
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
              ),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              body: Container(
                height: height,
                width: width,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          right: width / 20, left: width / 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: width / 20,
                              ),
                              Expanded(
                                child: Center(
                                    child: Text(
                                  "Profile",
                                  style: TextStyle(
                                      color:
                                          const Color.fromARGB(255, 0, 0, 0),
                                      fontFamily: "defaultfontsbold",
                                      fontSize: 20),
                                )),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return settingactivity();
                                      },
                                    ));
                                  },
                                  child: Image(
                                      image: AssetImage(
                                          "images/heroicons-outline_menu-alt-2.png")))
                            ],
                          ),
            Center(
          child: Stack(
            children: [
              GestureDetector(
                onTap:() {
                  _pickImage(userData['email']);
                },
                child: Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 30),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 5,
                    width: MediaQuery.of(context).size.width / 2.5,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color.fromARGB(255, 121, 5, 245),width: 2),
                      
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(255, 206, 206, 206),
                    ),
                    child: profilePic.isEmpty
                        ? Icon(
                            Icons.person,
                            color: const Color.fromARGB(255, 66, 66, 66),
                            size: MediaQuery.of(context).size.height / 15,
                          )
                        : ClipOval(
                            child: Image.network(
                              profilePic,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width / 2.5,
                              height: MediaQuery.of(context).size.height / 5,
                            ),
                          ),
                  ),
                ),
              ),
                 Positioned(
     left: width / 3,
     top: height / 6,
     child:
      Container(
       height: height / 20,
       width: width / 20,
       decoration: BoxDecoration(
           image: DecorationImage(
               image:
                   AssetImage("assetss/red.png"))),
     ),
   ),
            ],
          ),
        ),
                          SizedBox(
                            height: height / 50,
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      userData['name'],
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                          fontFamily: "defaultfontsbold",
                                          fontSize: 20),
                                    ),
                                    if (userData['profile'] ==
                                        "premium") ...[
                                      Padding(
                                        padding:
                                            EdgeInsets.only(left: width / 50),
                                        child: Container(
                                          height: height / 20,
                                          width: width / 20,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                            image: AssetImage(
                                              "assetss/Vector.png",
                                            ),
                                          )),
                                        ),
                                      ),
                                    ],
                                  ],
                                )),
                                if (userData['profile'] ==
                                    "standard") ...[
                                  SizedBox(
                                    height: height / 60,
                                  ),
                                ],
                                if (userData['profile'] ==
                                    "premium") ...[
                                  SizedBox(
                                    height: height / 90,
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.only(left: width/40),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) {
                                            return allpremium(
                                                userLatitude:
                                                    userData['X'],
                                                userLongitude:
                                                    userData["Y"],
                                                useremail:
                                                    userData['email']);
                                          },
                                        ));
                                      },
                                      child: Text(
                                        "See Premium Users",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 121, 5, 245),
                                            fontFamily: "defaultfontsbold",
                                            fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ],
                              ]),
                          Wrap(
                              spacing: 3,
                              alignment:WrapAlignment.center,
                              children: List<Widget>.generate(
                                userData['Interest'].length,
                                (int index) {
                                  return _buildInterestChip(
                                      curentuser.email!,
                                      context,
                                      userData['Interest'][index],
                                      userData['Icon'][index],
                                      height);
                                },
                              )),
                          SizedBox(
                            height: height / 30,
                          ),
                          Expanded(
                            child: GridView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: userData['images'].length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: width * 0.02,
                                mainAxisSpacing: height * 0.02,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              userData['images']
                                                  [index]),
                                          fit: BoxFit.cover)),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Positioned(
                      // left: width/20,
                      // right: width/20,
                      // bottom: height/60,
                      // child: BottomNavBar(
                        // selectedIndex2: 4,
                      // ),
                    // )
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
        }
        );
  }

  Widget _buildInterestChip(String email, BuildContext context, String label,
      int iconname, final height) {
    return Chip(
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(30)),
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
              fontSize: 10),
        ),
        backgroundColor: Color(0xffD9D9D9));
  }
}
