import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/Usermanegement/signin.dart';
import 'package:datingapp/Usermanegement/signup.dart';
import 'package:datingapp/ambassdor/newuser/signup.dart';
import 'package:datingapp/homepage.dart';
import 'package:datingapp/mainscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class wlcomepremium extends StatefulWidget {
  const wlcomepremium({super.key});

  @override
  State<wlcomepremium> createState() => _wlcomepremiumState();
}

class _wlcomepremiumState extends State<wlcomepremium> {
  bool ismonthly = false;
  bool isyearly = false;

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
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              body: Container(
                height: height,
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: height / 3.4,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assetss/Vector (1).png"))),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: height / 50),
                          child: Text(
                            "You’re Now On Premium!",
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
                 
                          Padding(
                       padding:
             EdgeInsets.only(top: height / 35, bottom: height / 30,left: width/25,right: width/25),
                       child: 
                       GestureDetector(
                         onTap: () {
       
       Navigator.of(context).pushAndRemoveUntil(
  MaterialPageRoute(builder: (context) => MainScreen()), 
  (Route<dynamic> route) => false,
);
       
                         },
                         child: 
                         Container(
             height: height / 15,
             width: width,
             child: Center(
                 child: Text(
               "Go To Home",
               style: Theme.of(context).textTheme.bodySmall,
             )),
             decoration: BoxDecoration(
                 color: Color(0xff7905F5),
                 borderRadius: BorderRadius.circular(height / 10)),
                         ),
                       ),
                     ),
                 
                      ],
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
