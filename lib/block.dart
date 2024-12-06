import 'dart:io';

import 'package:datingapp/Usermanegement/addemail.dart';
import 'package:datingapp/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class block extends StatefulWidget {
  const block({super.key});

  @override
  State<block> createState() => _blockState();
}

class _blockState extends State<block> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: height / 400,
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        backgroundColor: Colors.white,
        body: Container(
            child: Padding(
                padding: EdgeInsets.only(right: width / 20, left: width / 20),
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: height / 40,
                        ),
                      Container(
                        height: height / 3.4,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "assetss/block1.png"))),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: height / 90),
                        child: Text(
                          textAlign: TextAlign.center,
                          "Your account has\nbeen blocked!",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              fontFamily: "defaultfontsbold"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: width / 15,
                            right: width / 15,
                            top: height / 30,
                            bottom: height / 60),
                        child: Center(
                            child: Text(
                  "We reviewed your account and found that it still doesn't follow our Community Standards on account integrity and authentic identity.",
                          style: TextStyle(
                              color: Color(0xff565656),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'defaultfonts'),
                          textAlign: TextAlign.center,
                        )),
                      ),
                          Padding(
                         padding: EdgeInsets.only(top: height / 15),
                         child: Column(
                          crossAxisAlignment:CrossAxisAlignment.center,
                           children: [
                             Text(
                               "Please contact your ",
                               style: TextStyle(
                   color: Color(0xff4D4D4D),
                   fontSize: 20,
                   fontWeight: FontWeight.w500,
                   fontFamily: "defaultfontsbold"),
                             ),
                   GestureDetector(
          onTap: sendEmail,
                     child: Text(
                            "Account supporter",
                                       
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                                color: Color(0xff7905F5),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                fontFamily: "defaultfontsbold"),
                          ),
                   ),
                           ],
                         ),
                       ),          
                  
                      ]
                      
                      ),
                )
                    )
                    )
                    
                    );
  }
  sendEmail() async {
    final Email email = Email(
      body: "Help me to remove Deactivation",
      subject: "For Deactivation",
      recipients: ['enviyaclothing@gmail.com'],
      isHTML: false,
    );
    await FlutterEmailSender.send(email);
  }
}
