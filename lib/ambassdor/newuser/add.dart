import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/ambassdor/addcouple.dart';
import 'package:datingapp/ambassdor/bottombar.dart';
import 'package:datingapp/ambassdor/filterpage.dart';
import 'package:datingapp/ambassdor/matching.dart';
import 'package:datingapp/bootmnavbar.dart';
import 'package:datingapp/filterpage.dart';
import 'package:datingapp/onlinecheck.dart';
import 'package:datingapp/person.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class addpage extends StatefulWidget {
  const addpage({super.key});

  @override
  State<addpage> createState() => _addpageState();
}

class _addpageState extends State<addpage> {

  @override
  void initState() {
    super.initState();
    // Call this when the app starts or the user logs in
  }

  @override
  void dispose() {
    // Call this when the app is closed
    super.dispose();
  }


  String capitalizeFirstLetter(String name) {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final curentuser = FirebaseAuth.instance.currentUser!;

    return Container(
      height: height,
      width: width,
      color: const Color.fromARGB(255, 255, 255, 255),
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Ambassdor")
            .doc(curentuser.email!)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
    
    
            return WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                                                             appBar: AppBar(
             toolbarHeight:height/400,
             foregroundColor: const Color.fromARGB(255, 255, 255, 255),
             automaticallyImplyLeading: false,
           backgroundColor: const Color.fromARGB(255, 255, 255, 255),
           surfaceTintColor:const Color.fromARGB(255, 255, 255, 255),
           ),
                body: Container(
                  color: Color.fromARGB(255, 255, 255, 255),
                  height: height,
                  width: width,
                  child: Padding(
                    padding: EdgeInsets.only(
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(
                                  right: width / 20,
                                  left: width / 20,
                                ),
                                child: Container(
                                  child: Image.asset(
                                    "assetss/logo.png",
                                    height: height / 15,
                                    fit: BoxFit.fill,
                                  ),
                                )),
                            SizedBox(
                              height: height / 30,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: width / 20,
                                  left: width / 20,
                                  top: height / 60),
                              child: Container(
                                height: height / 1.5,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Image.asset(
                                          "assetss/Group 18642.png",
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: height / 30,
                                            bottom: height / 15),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(MaterialPageRoute(builder:(context) {
                                              return CoupleAddingPage();
                                            },));
                                          },
                                          child: Container(
                                            height: height / 15,
                                            width: width,
                                            child: Center(
                                                child: Text(
                                              "Add New Couple",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            )),
                                            decoration: BoxDecoration(
                                                color: Color(0xff7905F5),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        height / 10)),
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Image.asset(
                                          "assetss/couple.png",
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: height / 30,
                                            bottom: height / 30),
                                        child: GestureDetector(
                                          onTap: () {
              
                       Navigator.of(context).push(MaterialPageRoute(builder:(context) {
                         return CoupleMatchingPage();
                       },));
              
                                          },
                                          child: Container(
                                            height: height / 15,
                                            width: width,
                                            child: Center(
                                                child: Text(
                                              "Find a match",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            )),
                                            decoration: BoxDecoration(
                                                color: Color(0xff7905F5),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        height / 10)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: height / 1.25,
                            right: width / 20,
                            left: width / 20,
                          ),
                          child: A_BottomNavBar(
                            selectedIndex2: 2, check: 'already',
                          ),
                        ),
                      ],
                    ),
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
        },
      ),
    );
  }
}
