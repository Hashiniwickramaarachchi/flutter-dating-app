import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/Usermanegement/signin.dart';
import 'package:datingapp/Usermanegement/signup.dart';
import 'package:datingapp/ambassdor/newuser/signup.dart';
import 'package:datingapp/homepage.dart';
import 'package:datingapp/premium/detailsadding.dart';
import 'package:datingapp/premium/welcompremiuum.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class premiumbuy extends StatefulWidget {
  const premiumbuy({super.key});

  @override
  State<premiumbuy> createState() => _premiumbuyState();
}

class _premiumbuyState extends State<premiumbuy> {
  bool ismonthly = false;
  bool isyearly = false;
  String payemntversion = 'Monthly';
  int amount=32;
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
            return Scaffold(
              backgroundColor: const Color(0xffDFC1FF),
              appBar: AppBar(
                backgroundColor: const Color(0xffDFC1FF),
                leading: Padding(
                  padding: EdgeInsets.only(left: width / 20),
                  child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ))),
                ),
              ),
              body: Container(
                height: height,
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Container(
                              height: height / 3.4,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assetss/send-money-in-person-from-jamaica-resp-removebg-preview 1.png"))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: height / 50),
                              child: Text(
                                "Upgrade To Premium",
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
                                  top: height / 60,
                                  bottom: height / 60),
                              child: Center(
                                  child: Text(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut diam orci, rutrum id arcu in, cursus commodo ex.",
                                style: TextStyle(
                                    color: Color(0xff565656),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    fontFamily: 'defaultfonts'),
                                textAlign: TextAlign.center,
                              )),
                            ),
                          ],
                        )),
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30)),
                            color: Colors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: height / 20,
                                      left: width / 22,
                                      right: width / 22),
                                  child: GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        ismonthly = !ismonthly;
                                        isyearly = false;
                                        payemntversion = 'Monthly';
                                                                                amount=32;

                                      });
                                    },
                                    child: Container(
                                      height: height / 16,
                                      width: width,
                                      decoration: BoxDecoration(
                                        color: ismonthly
                                            ? Color(0xffDFC1FF)
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: Color(0xff7905F5),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(height / 10),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: width / 20,
                                              right: width / 30),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Monthly",
                                                style: TextStyle(
                                                  fontFamily: "button",
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 20,
                                                ),
                                              ),
                                              Text(
                                                "\$32/Month",
                                                style: TextStyle(fontSize: 16),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: height / 70,
                                      bottom: height / 30,
                                      left: width / 22,
                                      right: width / 22),
                                  child: GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        isyearly = !isyearly;
                                        ismonthly = false;
                                        payemntversion = 'Yearly';
                                        amount=90;
                                      });
                                    },
                                    child: Container(
                                      height: height / 16,
                                      width: width,
                                      decoration: BoxDecoration(
                                        color: isyearly
                                            ? Color(0xffDFC1FF)
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: Color(0xff7905F5),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(height / 10),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: width / 20,
                                              right: width / 30),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Yearly",
                                                style: TextStyle(
                                                  fontFamily: "button",
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 20,
                                                ),
                                              ),
                                              Text(
                                                "\$90/Month",
                                                style: TextStyle(fontSize: 16),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: height / 40,
                                  bottom: height / 40,
                                  left: width / 22,
                                  right: width / 22),
                              child: GestureDetector(
                                onTap: () async {
                                  if (userdataperson['profile'] == 'standard') {
                                    if (ismonthly == true || isyearly == true) {
                                      try {
                                        // await FirebaseFirestore.instance
                                            // .collection(payemntversion)
                                            // .doc(userdataperson['email'])
                                            // .set({
                                          // 'Buy Time':
                                              // FieldValue.serverTimestamp(),
                                          // "User": userdataperson['email']
                                        // });

                                        // await FirebaseFirestore.instance
                                            // .collection('users')
                                            // .doc(userdataperson['email'])
                                            // .update({'profile': 'premium'});

                                        // Once the async operation is complete, update the state and navigate
                                        // setState(() {});
                                        // ScaffoldMessenger.of(context)
                                            // .showSnackBar(SnackBar(
                                                // content: Text(
                                                    // 'User upgraded to premium')));

                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return detailsadding(Amount: amount, dbemail: userdataperson['email'], version: payemntversion,);
                                        }));
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Error updating profile: $e')));
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text('Select a Plan')));
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'You already a premium member!!')));
                                  }
                                },
                                child: Container(
                                  height: height / 15,
                                  width: width,
                                  decoration: BoxDecoration(
                                    color: Color(0xff7905F5),
                                    borderRadius:
                                        BorderRadius.circular(height / 10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Continue",
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
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
          }
          return Center(
              child: Container(
                  height: height / 50,
                  width: width / 50,
                  child: CircularProgressIndicator(
                    color: Color(
                      0xff7905F5,
                    ),
                  )));
        });
  }
}
