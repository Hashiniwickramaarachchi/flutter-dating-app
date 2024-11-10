import 'dart:io';

import 'package:datingapp/Usermanegement/addemail.dart';
import 'package:datingapp/ambassdor/settingpage.dart/helpcenter.dart';
import 'package:datingapp/homepage.dart';
import 'package:datingapp/settingpage.dart/technicalissue.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class A_f_and_q extends StatefulWidget {
  const A_f_and_q({super.key});

  @override
  State<A_f_and_q> createState() => _A_f_and_qState();
}

class _A_f_and_qState extends State<A_f_and_q> {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: width / 20,
                          left: width / 20),
                      child: Row(
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
                          SizedBox(width: width / 20),
                          Expanded(
                            child: Center(
                              child: Text(
                                "FAQs & Help Center",
                                style: TextStyle(
                                    color: const Color(0xff26150F),
                                    fontFamily: "defaultfontsbold",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                          SizedBox(width: width / 10),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: width / 15, right: width / 15),
                    child: Container(
                      height: height / 22,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: TextField(
                        style: Theme.of(context).textTheme.headlineSmall,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: width / 20,
                              top: height / 5,
                              bottom: height / 150),
                          hintText: "Search for help...",
                          border: InputBorder.none,
                          suffixIcon: Icon(
                            Icons.search,
                            color: Color(0xff565656),
                            size: height / 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height / 40),
                  Padding(
                    padding:
                        EdgeInsets.only(left: width / 20, right: width / 20),
                    child: Container(
                      height: height / 5,
                      child: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (context) {
                                      return A_helpcenter(
                                        mainname: "Account Management",
                                        questions: [
                                          'How do I reset my password?',
                                          "What should I do if I can't access my account?",
                                          "How can I change my username?",
                                          "Can I have multiple accounts?"
                                        ],
                                      );
                                    },
                                  ));
                                },
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        child: Image.asset("images/lock.png"),
                                      ),
                                      Center(
                                        child: Text(
                                          "Account Management",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontFamily: "defaultfonts"),
                                        ),
                                      )
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 10,
                                            color: const Color.fromARGB(
                                                255, 211, 211, 211))
                                      ],
                                      borderRadius:
                                          BorderRadius.circular(10)),
                                ),
                              )),
                          SizedBox(
                            width: width / 35,
                          ),
                          Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (context) {
                                      return A_helpcenter(
                                        mainname: "Matchmaking",
                                        questions: [
                                          'How does the matchmaking algorithm work?',
                                          "Can I hide my profile from certain users?",
                                          "What happens if I accidentally unmatched someone?",
                                          "How can I improve my match suggestions?"
                                        ],
                                      );
                                    },
                                  ));
                                },
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        child:
                                            Image.asset("images/heart.png"),
                                      ),
                                      Center(
                                        child: Text(
                                          "Matchmaking",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontFamily: "defaultfonts"),
                                        ),
                                      )
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 10,
                                            color: const Color.fromARGB(
                                                255, 211, 211, 211))
                                      ],
                                      borderRadius:
                                          BorderRadius.circular(10)),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: width / 20,
                        right: width / 20,
                        top: height / 60),
                    child: Container(
                      height: height / 4.8,
                      child: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (context) {
                                      return A_helpcenter(
                                        mainname: "Safety & Security",
                                        questions: [
                                          'What should I do if I feel uncomfortable during a\nconversation?',
                                          "How do I ensure my profile is private?",
                                          "Can I review my chat history?",
                                          "What are the signs of a scammer?"
                                        ],
                                      );
                                    },
                                  ));
                                },
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        child:
                                            Image.asset("images/privacy.png"),
                                      ),
                                      Center(
                                        child: Text(
                                          "Safety & Security",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontFamily: "defaultfonts"),
                                        ),
                                      )
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 10,
                                            color: const Color.fromARGB(
                                                255, 211, 211, 211))
                                      ],
                                      borderRadius:
                                          BorderRadius.circular(10)),
                                ),
                              )),
                          SizedBox(
                            width: width / 35,
                          ),
                          Expanded(
                              flex: 2,
                              child: GestureDetector(
                                             onTap: () {
             Navigator.of(context)
                 .push(MaterialPageRoute(
               builder: (context) {
                 return A_technicalissue(
                   mainname: "Technical Issues",
                       
                       
                       
                       
                       
                       
                 );
               },
             ));
                         },
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        child: Image.asset(
                                            "images/settings.png"),
                                      ),
                                      Center(
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          "Technical Issues",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontFamily: "defaultfonts"),
                                        ),
                                      )
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 10,
                                            color: const Color.fromARGB(
                                                255, 211, 211, 211))
                                      ],
                                      borderRadius:
                                          BorderRadius.circular(10)),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: width / 20, top: height / 60),
                    child: Text(
                      'Popular Questions',
                      style: TextStyle(
                          color: const Color(0xff4D4D4D),
                          fontFamily: "defaultfontsbold",
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: width / 20, top: height / 90),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Q: How do I reset my password?",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12),
                                ),
                                Text(
                                  "A: Click "
                                  "Forgot Password"
                                  " on the login screen and follow the instructions",
                                  style: TextStyle(
                                      color: Color(0xff4D4D4D), fontSize: 10),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height / 60,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Q: What should I do if I encounter inappropriate behavior?",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12),
                                ),
                                Text(
                                  "A: Report the user by tapping on their profile and selecting "
                                  "Report User.",
                                  style: TextStyle(
                                      color: Color(0xff4D4D4D), fontSize: 10),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height / 60,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Q: How do I change my profile picture?",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12),
                                ),
                                Text(
                                  "A: Tap on your profile icon, select "
                                  "Edit Profile,"
                                  " then choose "
                                  "Change Profile Picture"
                                  " to upload a new photo.",
                                  style: TextStyle(
                                      color: Color(0xff4D4D4D), fontSize: 10),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ))
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
