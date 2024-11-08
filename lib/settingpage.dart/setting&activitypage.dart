import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/Usermanegement/signin.dart';
import 'package:datingapp/onlinecheck.dart';
import 'package:datingapp/premium/premiumbuy.dart';
import 'package:datingapp/settingpage.dart/f&q.dart';
import 'package:datingapp/settingpage.dart/feedback.dart';
import 'package:datingapp/settingpage.dart/personalinfo.dart';
import 'package:datingapp/settingpage.dart/privacy.dart';
import 'package:datingapp/settingpage.dart/profileupdate.dart';
import 'package:datingapp/settingpage.dart/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class settingactivity extends StatefulWidget {
  const settingactivity({super.key});

  @override
  State<settingactivity> createState() => _settingactivityState();
}

class _settingactivityState extends State<settingactivity> {
  final OnlineStatusService _onlineStatusService =
      OnlineStatusService(); // Instantiate the service

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.only(
              top: height / 30,
              bottom: height / 60,
              right: width / 30,
              left: width / 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: height / 10,
                          width: width / 10,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(width: 1, color: Colors.black)),
                          child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: Color.fromARGB(255, 121, 5, 245),
                              )),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "Settings & activity",
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontFamily: "defaultfontsbold",
                                  fontSize: height / 32),
                            ),
                          ),
                        ),
                        SizedBox(width: width / 20)
                      ],
                    ),
                    SizedBox(height: height / 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return ProfileUpdatePage();
                          },
                        ));
                      },
                      child: Padding(
                        padding:  EdgeInsets.only(left: width/40,right: width/40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person_2_outlined,
                                  color: Color(0xff565656),
                                  size: height / 30,
                                ),
                                SizedBox(
                                  width: width / 25,
                                ),
                                Text(
                                  'Your Profile',
                                  style: TextStyle(
                                      color: const Color(0xff565656),
                                      fontFamily: "defaultfontsbold",
                                      fontWeight: FontWeight.bold,
                                      fontSize: height / 45),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xff565656),
                              size: height / 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width / 30, right: width / 30, top: height / 30),
                      child: Container(
                        width: width,
                        child: Divider(
                          height: 1,
                                    color: const Color(0xffCAC7C7),
                        ),
                      ),
                    ),
                              SizedBox(height: height / 20),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return premiumbuy();
                  },
                ));
              },
              child: Padding(
                padding:  EdgeInsets.only(left: width/40,right: width/40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.diamond,
                          color: Color(0xff565656),
                          size: height / 30,
                        ),
                        SizedBox(
                          width: width / 25,
                        ),
                        Text(
                          'Upgrade To Premeium ',
                          style: TextStyle(
                              color: const Color(0xff565656),
                              fontFamily: "defaultfontsbold",
                              fontWeight: FontWeight.bold,
                              fontSize: height / 45),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xff565656),
                      size: height / 40,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: width / 30, right: width / 30, top: height / 30),
              child: Container(
                width: width,
                child: Divider(
                  height: 1,
                            color: const Color(0xffCAC7C7),
                ),
              ),
            ),
                    SizedBox(
                      height: height / 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return settings();
                          },
                        ));
                      },
                      child: Padding(
                        padding:  EdgeInsets.only(left: width/40,right: width/40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.settings,
                              color: Color(0xff565656),
                                  size: height / 30,
                                ),
                                SizedBox(
                                  width: width / 25,
                                ),
                                Text(
                                  'Settings',
                                  style: TextStyle(
                                      color: const Color(0xff565656),
                                      fontFamily: "defaultfontsbold",
                                      fontWeight: FontWeight.bold,
                                      fontSize: height / 45),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xff565656),
                              size: height / 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width / 30, right: width / 30, top: height / 30),
                      child: Container(
                        width: width,
                        child: Divider(
                          height: 1,
                                    color: const Color(0xffCAC7C7),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height / 30,
                    ),
                    GestureDetector(
                      onTap: () {
                               Navigator.of(context).push(MaterialPageRoute(
                     builder: (context) {
             return f_and_q();
                     },
                   ));
                      },
                      child: Padding(
                        padding:  EdgeInsets.only(left: width/40,right: width/40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.local_hospital,
                                color: Color(0xff565656),
                                  size: height / 30,
                                ),
                                SizedBox(
                                  width: width / 25,
                                ),
                                Text(
                                  'Help Center',
                                  style: TextStyle(
                                      color: const Color(0xff565656),
                                      fontFamily: "defaultfontsbold",
                                      fontWeight: FontWeight.bold,
                                      fontSize: height / 45),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                                color: Color(0xff565656),
                              size: height / 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width / 30, right: width / 30, top: height / 30),
                      child: Container(
                        width: width,
                        child: Divider(
                          height: 1,
                                    color: const Color(0xffCAC7C7),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height / 30,
                    ),
                    Padding(
                        padding:  EdgeInsets.only(left: width/40,right: width/40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.group_add,
                              color: Color(0xff565656),
                                size: height / 30,
                              ),
                              SizedBox(
                                width: width / 25,
                              ),
                              Text(
                                'Invite Friends',
                                style: TextStyle(
                                    color: const Color(0xff565656),
                                    fontFamily: "defaultfontsbold",
                                    fontWeight: FontWeight.bold,
                                    fontSize: height / 45),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                              color: Color(0xff565656),
                            size: height / 40,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width / 30, right: width / 30, top: height / 30),
                      child: Container(
                        width: width,
                        child: Divider(
                          height: 1,
                                    color: const Color(0xffCAC7C7),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height / 30,
                    ),
                    Padding(
                        padding:  EdgeInsets.only(left: width/40,right: width/40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.help,
                              color: Color(0xff565656),
                                size: height / 30,
                              ),
                              SizedBox(
                                width: width / 25,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder:(context) {
                                    return privacy();
                                  },));
                                },
                                child: Text(
                                  'Privacy policy',
                                  style: TextStyle(
                                      color: const Color(0xff565656),
                                      fontFamily: "defaultfontsbold",
                                      fontWeight: FontWeight.bold,
                                      fontSize: height / 45),
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                              color: Color(0xff565656),
                            size: height / 40,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width / 30, right: width / 30, top: height / 30),
                      child: Container(
                        width: width,
                        child: Divider(
                          height: 1,
                                    color: const Color(0xffCAC7C7),
                        ),
                      ),
                    ),
            
                                      SizedBox(
                      height: height / 30,
                    ),
                    Padding(
                        padding:  EdgeInsets.only(left: width/40,right: width/40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.help,
                              color: Color(0xff565656),
                                size: height / 30,
                              ),
                              SizedBox(
                                width: width / 25,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder:(context) {
                                    return FeedbackPage();
                                  },));
                                },
                                child: Text(
                                  'Feedback & Review',
                                  style: TextStyle(
                                      color: const Color(0xff565656),
                                      fontFamily: "defaultfontsbold",
                                      fontWeight: FontWeight.bold,
                                      fontSize: height / 45),
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                              color: Color(0xff565656),
                            size: height / 40,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width / 30, right: width / 30, top: height / 30),
                      child: Container(
                        width: width,
                        child: Divider(
                          height: 1,
                                    color: const Color(0xffCAC7C7),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height/10,),
                GestureDetector(
                  onTap: () async {
                    try {
                      // Mark the user offline in Firestore and Realtime
                      await _onlineStatusService.setUserOffline();
            
                      // Perform Firebase sign-out
                      await FirebaseAuth.instance.signOut();
                      // Show logout success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Logout Successful'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      // Wait for a brief moment to ensure the SnackBar i                    // Navigate to the sign-in page
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => signin()));
                    } catch (e) {
                      // Handle logout errors if needed
                      print('Error logging out: $e');
                    }
                  },
                  child: Padding(
                        padding:  EdgeInsets.only(left: width/40,right: width/40),
                    child: Row(
                      children: [
                        Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(3.14), //
                          child: Icon(
                            Icons.logout,
                            
                                color: Color(0xff565656),
                            size: height / 30,
                          ),
                        ),
                        SizedBox(
                          width: width / 25,
                        ),
                        Text(
                          'Logout',
                      
                           style: TextStyle(
                             color: const Color(0xff565656),
                             fontFamily: "defaultfontsbold",
                             fontWeight: FontWeight.bold,
                             fontSize: height / 45),
                      
                      
                        ),
                      ],
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
}
