import 'dart:io';

import 'package:datingapp/Usermanegement/addemail.dart';
import 'package:datingapp/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class privacy extends StatefulWidget {
  const privacy({super.key});

  @override
  State<privacy> createState() => _privacyState();
}

class _privacyState extends State<privacy> {
  final currentpasword = TextEditingController();
  final newpassword = TextEditingController();
  final confirmpassword = TextEditingController();
  bool _currentpassword = true;
  bool _newpassword = true;
  bool _confirmpassword = true;

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

            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: height / 30,
                            bottom: height / 60,
                            right: width / 30,
                            left: width / 30),
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
                                      color: const Color.fromARGB(
                                          255, 121, 5, 245),
                                    ),
                                  ),
                                ),
                                SizedBox(width: width / 20),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "Privacy policy",
                                      style: TextStyle(
                                          color: const Color(0xff26150F),
                                          fontFamily: "defaultfontsbold",
                                          fontWeight: FontWeight.w500,
                                          fontSize: height / 35),
                                    ),
                                  ),
                                ),
                                SizedBox(width: width / 5),
                              ],
                            ),
                            SizedBox(height: height / 60),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: width / 50, right: width / 50),
                              child: Container(
                                height: height/1.4,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Lorem Ipsum',
                                        style: TextStyle(
                                            color: const Color(0xff4D4D4D),
                                            fontFamily: "defaultfontsbold",
                                            fontWeight: FontWeight.bold,
                                            fontSize: height / 50),
                                      ),
                                      Text(
                                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum id mollis mauris. Cras enim augue,semper in maximus ac, tristique nec sem. In tellus libero, laoreet ac sem consectetur, convallis interdum lacus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi eget vulputate odio. Donec ullamcorper faucibus nulla nec mollis.",
                                        style: TextStyle(
                                            color: const Color(0xff4D4D4D),
                                            fontFamily: "defaultfonts",
                                            fontSize: height / 60),
                                      ),
                                                              
                                      SizedBox(height: height/60,),
                                                    Text(
                                                'Lorem Ipsum',
                                                style: TextStyle(
                                                    color: const Color(0xff4D4D4D),
                                                    fontFamily: "defaultfontsbold",
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: height / 50),
                                              ),
                                              Text(
                                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum id mollis mauris. Cras enim augue,semper in maximus ac, tristique nec sem. In tellus libero, laoreet ac sem consectetur, convallis interdum lacus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi eget vulputate odio. Donec ullamcorper faucibus nulla nec mollis.",
                                                style: TextStyle(
                                                    color: const Color(0xff4D4D4D),
                                                    fontFamily: "defaultfonts",
                                                    fontSize: height / 60),
                                              ),
                                                              
                                                              
                                                  SizedBox(height: height/60,),
                                                  Text(
                                              'Lorem Ipsum',
                                              style: TextStyle(
                                                  color: const Color(0xff4D4D4D),
                                                  fontFamily: "defaultfontsbold",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: height / 50),
                                            ),
                                            Text(
                                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum id mollis mauris. Cras enim augue,semper in maximus ac, tristique nec sem. In tellus libero, laoreet ac sem consectetur, convallis interdum lacus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi eget vulputate odio. Donec ullamcorper faucibus nulla nec mollis.",
                                              style: TextStyle(
                                                  color: const Color(0xff4D4D4D),
                                                  fontFamily: "defaultfonts",
                                                  fontSize: height / 60),
                                            ),
                                                              
                                                              
                                                SizedBox(height: height/60,),
                                                  Text(
                                              'Lorem Ipsum',
                                              style: TextStyle(
                                                  color: const Color(0xff4D4D4D),
                                                  fontFamily: "defaultfontsbold",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: height / 50),
                                            ),
                                            Text(
                                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum id mollis mauris. Cras enim augue,semper in maximus ac, tristique nec sem. In tellus libero, laoreet ac sem consectetur, convallis interdum lacus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi eget vulputate odio. Donec ullamcorper faucibus nulla nec mollis.",
                                              style: TextStyle(
                                                  color: const Color(0xff4D4D4D),
                                                  fontFamily: "defaultfonts",
                                                  fontSize: height / 60),
                                            ),
                                                              
                                                              
                                                SizedBox(height: height/60,),
                                                  Text(
                                              'Lorem Ipsum',
                                              style: TextStyle(
                                                  color: const Color(0xff4D4D4D),
                                                  fontFamily: "defaultfontsbold",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: height / 50),
                                            ),
                                            Text(
                                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum id mollis mauris. Cras enim augue,semper in maximus ac, tristique nec sem. In tellus libero, laoreet ac sem consectetur, convallis interdum lacus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi eget vulputate odio. Donec ullamcorper faucibus nulla nec mollis.",
                                              style: TextStyle(
                                                  color: const Color(0xff4D4D4D),
                                                  fontFamily: "defaultfonts",
                                                  fontSize: height / 60),
                                            )
                                                              
                                                              
                                    ],
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
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error${snapshot.error}"),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Future<void> updateinfo(
      final userEmail,
      TextEditingController currentpassword,
      TextEditingController password,
      TextEditingController confirmpassword) async {
    try {
      // Handle password change if necessary
      if (password.text.isNotEmpty && confirmpassword.text.isNotEmpty) {
        if (password.text == confirmpassword.text) {
          await changePassword(currentpassword.text, password.text);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Passwords do not match!')),
          );
        }
      }
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile.')),
      );
    }
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    final user = FirebaseAuth.instance.currentUser!;
    final cred = EmailAuthProvider.credential(
        email: user.email!, password: currentPassword);

    try {
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password updated successfully!')),
      );
    } catch (e) {
      print('Error changing password: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update password.')),
      );
    }
  }
}
