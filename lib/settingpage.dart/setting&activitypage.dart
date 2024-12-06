import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/Usermanegement/signin.dart';
import 'package:datingapp/invite.dart';
import 'package:datingapp/onlinecheck.dart';
import 'package:datingapp/premium/premiumbuy.dart';
import 'package:datingapp/settingpage.dart/f&q.dart';
import 'package:datingapp/settingpage.dart/feedback.dart';
import 'package:datingapp/settingpage.dart/personalinfo.dart';
import 'package:datingapp/settingpage.dart/privacy.dart';
import 'package:datingapp/settingpage.dart/profileupdate.dart';
import 'package:datingapp/settingpage.dart/settings.dart';
import 'package:datingapp/settingpage.dart/unblockpage.dart';
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
        final curentuser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder<DocumentSnapshot>(
     
            stream: FirebaseFirestore.instance
           .collection("users")
           .doc(curentuser.email!)
           .snapshots(),
       builder: (context, snapshot) {
         if (snapshot.hasData) {
         // Check if data exists before casting to Map<String, dynamic>
         final userData = snapshot.data!.data() as Map<String, dynamic>?;
         if (userData == null) {
           return Center(
             child: Text("User data not found."),
           );
         }
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: height / 400,
            foregroundColor: const Color.fromARGB(255, 255, 255, 255),
            automaticallyImplyLeading: false,
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
          ),
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.only(
                bottom: height / 60, right: width / 20, left: width / 20),
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
                                    fontSize: 20),
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
                          padding:
                              EdgeInsets.only(left: width / 40, right: width / 40),
                          child: Container(
                            color: Colors.transparent,
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
                                          fontSize: 18),
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
                          padding:
                              EdgeInsets.only(left: width / 40, right: width / 40),
                          child: Container(
                            color: Colors.transparent,
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
                                          fontSize: 18),
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
                          padding:
                              EdgeInsets.only(left: width / 40, right: width / 40),
                          child: Container(
                            color: Colors.transparent,
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
                                          fontSize: 18),
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
                          padding:
                              EdgeInsets.only(left: width / 40, right: width / 40),
                          child: Container(
                            color: Colors.transparent,
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
                                          fontSize: 18),
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
                        onTap: () async {
                          // _createAndShareDynamicLink();
                        // inviteFriends();
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: width / 40, right: width / 40),
                          child: Container(
                            color: Colors.transparent,
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
                                          fontSize: 18),
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
                              return privacy(
                                who: 'users',
                              );
                            },
                          ));
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: width / 40, right: width / 40),
                          child: Container(
                            color: Colors.transparent,
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
                                    Text(
                                      'Privacy policy',
                                      style: TextStyle(
                                          color: const Color(0xff565656),
                                          fontFamily: "defaultfontsbold",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
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
                              return FeedbackPage();
                            },
                          ));
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: width / 40, right: width / 40),
                          child: Container(
                            color: Colors.transparent,
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
                                    Text(
                                      'Feedback & Review',
                                      style: TextStyle(
                                          color: const Color(0xff565656),
                                          fontFamily: "defaultfontsbold",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
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
                              return unblock(userLatitude: userData["X"], userLongitude: userData['Y'], useremail: userData['email'],);
                            },
                          ));
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: width / 40, right: width / 40),
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: Color(0xff565656),
                                      size: height / 30,
                                    ),
                                    SizedBox(
                                      width: width / 25,
                                    ),
                                    Text(
                                      'Block list',
                                      style: TextStyle(
                                          color: const Color(0xff565656),
                                          fontFamily: "defaultfontsbold",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
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
                  SizedBox(
                    height: height / 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      // try {
                      // await _onlineStatusService.setUserOffline();
                      //
                      // await FirebaseAuth.instance.signOut();
                      // ScaffoldMessenger.of(context).showSnackBar(
                      // SnackBar(
                      // content: Text('Logout Successful'),
                      // duration: Duration(seconds: 2),
                      // ),
                      // );
                      // Navigator.of(context).pushReplacement(
                      // MaterialPageRoute(builder: (context) => signin()));
                      // } catch (e) {
                      // print('Error logging out: $e');
                      // }
        
                      // Show loading dialog
                      showDialog(
                        context: context,
                        barrierDismissible:
                            false, // Prevents the dialog from closing when tapped outside
                        builder: (context) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
        
                      try {

                                             await FirebaseFirestore.instance
      .collection('users')
      .doc(curentuser.email!)
      .update({'Logged': 'false'});     
                        await FirebaseAuth.instance.signOut();
                        // Show logout success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Logout Successful'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        // Wait for a brief moment to ensure the SnackBar is visible
                        await Future.delayed(Duration(seconds: 2));
                        // Close the loading dialog
                        Navigator.of(context).pop();
                        // Navigate to splash screen
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => signin()),
                          (Route<dynamic> route) => false,
                        );
                      } catch (e) {
                        // Close the loading dialog
                        Navigator.of(context).pop();
                        // Handle logout errors if needed
                        print('Error logging out: $e');
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: width / 40, right: width / 40),
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
                                fontSize: 18),
                          ),
                        ],
                      ),
                    ),
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
            return CircularProgressIndicator();
          }
      }
    );
  }
  // void inviteFriends() {
  // const String appUrl = 'https://play.google.com';
  // const String message = 'Join me on ApexLove, the premier dating app for meaningful connections! Download now: $appUrl';

  // Share.share(message);
//  }
  // Future<void> _createAndShareDynamicLink() async {
  // final link = await DynamicLinkService.instance.createDynamicLink();
  // _shareDynamicLink(link);
// }
//
// Future<void> _shareDynamicLink(String link) async {
  // Share.share(
  // 'Here is a dynamic link for you: $link',
  // subject: 'Check this out!', // Use subject as the title (optional) use share etends for thuis
  // );
// }
}
