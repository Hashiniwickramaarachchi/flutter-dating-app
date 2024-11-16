import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/Landingpages/ladingpage.dart';
import 'package:datingapp/Usermanegement/signin.dart';
import 'package:datingapp/ambassdor/A_Mainscree.dart';
import 'package:datingapp/ambassdor/newuser/homepage.dart';
import 'package:datingapp/ambassdor/olduser/showresultsignin.dart';
import 'package:datingapp/homepage.dart';
import 'package:datingapp/mainscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class splashscreen extends StatefulWidget {
  const splashscreen({super.key});

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  void initState() {
    super.initState();
    // Check if the user is logged in
    Timer(const Duration(seconds: 1), () async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email!)
            .get();
        // Check if the chat partner is in the 'ambassador' collection
        final ambassadorSnapshot = await FirebaseFirestore.instance
            .collection('Ambassdor')
            .doc(user.email!)
            .get();
        if (userSnapshot.exists) {
          // Print message if the chat partner is in the 'user' collection
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) {
              return MainScreen();
            },
          ));
        } else if (ambassadorSnapshot.exists) {

          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) {
              return A_MainScreen();
            },
          ));
        }
        // User is logged in, navigate to home page
      } else {
        // User is not logged in, navigate to landing page
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return landingpage();
        }));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 125, 5, 245),
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Image.asset("images/logo white.png")],
        ),
      ),
    );
  }
}
