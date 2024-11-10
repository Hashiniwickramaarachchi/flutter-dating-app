import 'dart:io';

import 'package:datingapp/Usermanegement/addemail.dart';
import 'package:datingapp/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class A_passwordsequrity extends StatefulWidget {
  const A_passwordsequrity({super.key});

  @override
  State<A_passwordsequrity> createState() => _A_passwordsequrityState();
}

class _A_passwordsequrityState extends State<A_passwordsequrity> {
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
            .collection("Ambassdor")
            .doc(curentuser.email!)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userdataperson =
                snapshot.data!.data() as Map<String, dynamic>;

            return Scaffold(
                        appBar: AppBar(
                      toolbarHeight:height/400,
                      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                      automaticallyImplyLeading: false,
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  surfaceTintColor:const Color.fromARGB(255, 255, 255, 255),
                  ),
              backgroundColor: Colors.white,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: height / 60,
                          right: width / 20,
                          left: width / 20),
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
                                      color: const Color.fromARGB(
                                          255, 121, 5, 245),
                                    ),
                                  ),
                                ),
                                SizedBox(width: width / 20),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "Password manager",
                                      style: TextStyle(
                                          color: const Color(0xff26150F),
                                          fontFamily: "defaultfontsbold",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20),
                                    ),
                                  ),
                                ),
                                SizedBox(width: width / 20),
                              ],
                            ),
                            SizedBox(height: height / 20),
                            Text(
                              'Current password',
                              style: TextStyle(
                                  color: const Color(0xff4D4D4D),
                                  fontFamily: "defaultfontsbold",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            TextField(
                              controller: currentpasword,
                              obscureText: _currentpassword,
                              style:
                                  Theme.of(context).textTheme.headlineSmall,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                hintText: 'Password',
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _currentpassword = !_currentpassword;
                                      });
                                    },
                                    icon: Icon(
                                      _currentpassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Color(0xff4D4D4D),
                                      size: height / 40,
                                    )),
                                contentPadding: EdgeInsets.only(
                                    left: width / 50, top: height / 50),
                              ),
                            ),
                            SizedBox(
                              height: height / 60,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) {
                                    return Addemail();
                                  },
                                ));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("Forgot Password ?",
                                      style: TextStyle(
                                          color: Color(0xff7905F5),fontSize: 14)),
                                ],
                              ),
                            ),
                            SizedBox(height: height / 40),
                            Padding(
                              padding:  EdgeInsets.only(top: height/30,bottom:height/20),
                              child: TextField(
                                controller: newpassword,
                                obscureText: _newpassword,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  hintText: 'New Password',
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _newpassword = !_newpassword;
                                        });
                                      },
                                      icon: Icon(
                                        _newpassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Color(0xff4D4D4D),
                                        size: height / 40,
                                      )),
                                  contentPadding: EdgeInsets.only(
                                      left: width / 50, top: height / 50),
                                ),
                              ),
                            ),
                            TextField(
                              controller: confirmpassword,
                              obscureText: _confirmpassword,
                              style:
                                  Theme.of(context).textTheme.headlineSmall,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                hintText: 'Confirm Password',
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _confirmpassword = !_confirmpassword;
                                      });
                                    },
                                    icon: Icon(
                                      _confirmpassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Color(0xff4D4D4D),
                                      size: height / 40,
                                    )),
                                contentPadding: EdgeInsets.only(
                                    left: width / 50, top: height / 50),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: width / 22,
                        right: width / 22,
                        bottom: height / 40),
                    child: GestureDetector(
                      onTap: () async {
                        updateinfo(curentuser.email!, currentpasword,
                            newpassword, confirmpassword);
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
                            "Update Password",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
