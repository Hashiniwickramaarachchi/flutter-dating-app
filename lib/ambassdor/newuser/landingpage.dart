import 'package:datingapp/Usermanegement/signin.dart';
import 'package:datingapp/Usermanegement/signup.dart';
import 'package:datingapp/ambassdor/newuser/dashbordnew.dart';
import 'package:datingapp/ambassdor/newuser/homepage.dart';
import 'package:datingapp/ambassdor/newuser/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class A_landingpage extends StatefulWidget {
  const A_landingpage({super.key});

  @override
  State<A_landingpage> createState() => _A_landingpageState();
}

class _A_landingpageState extends State<A_landingpage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
                                                               appBar: AppBar(
           toolbarHeight:height/400,
           foregroundColor: const Color.fromARGB(255, 255, 255, 255),
           automaticallyImplyLeading: false,
         backgroundColor: const Color.fromARGB(255, 255, 255, 255),
         surfaceTintColor:const Color.fromARGB(255, 255, 255, 255),
         ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Container(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.only(left: width/20,right: width/20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: Image.asset("assetss/logo.png")),
                SizedBox(
                  height: height / 40,
                ),
                               Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text(
                   "Welcome to the Appexlove",
                   style: TextStyle(
                       color: const Color.fromARGB(255, 121, 5, 245),
                       fontSize: height / 32,
                       fontWeight: FontWeight.w900,
                       fontFamily: "defaultfontsbold"),
                 ),
                //  Text(
                  //  " Where",
                  //  style: TextStyle(
                      //  color: Colors.black,
                      //  fontSize: height / 32,
                      //  fontWeight: FontWeight.w900,
                      //  fontFamily: "defaultfontsbold"),
                //  )
               ],
             ),
             Text(
               " Ambassador Community!",
               style: TextStyle(
                   color: Colors.black,
                   fontSize: height / 32,
                   fontWeight: FontWeight.w900,
                   fontFamily: "defaultfontsbold"),
             ),
                     
                      SizedBox(
            height: height / 40,
                      ),   
                     
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  
             Center(
                   child: Image.asset("assetss/Image.png"),
             ),
                    // Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // children: [
                        // Text(
                          // "Find Your Match:",
                          // style: TextStyle(
                              // color: const Color.fromARGB(255, 121, 5, 245),
                              // fontSize: height / 32,
                              // fontWeight: FontWeight.w900,
                              // fontFamily: "defaultfontsbold"),
                        // ),
                        // Text(
                          // " Where",
                          // style: TextStyle(
                              // color: Colors.black,
                              // fontSize: height / 32,
                              // fontWeight: FontWeight.w900,
                              // fontFamily: "defaultfontsbold"),
                        // )
                      // ],
                    // ),
                    // Text(
                      // " Every Journey Starts.",
                      // style: TextStyle(
                          // color: Colors.black,
                          // fontSize: height / 32,
                          // fontWeight: FontWeight.w900,
                          // fontFamily: "defaultfontsbold"),
                    // ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width / 40,
                          right: width / 40,
                          top: height / 60,
                          bottom: height / 60),
                      child: Center(
                          child: Text(
                        "Thank you for joining us! As an ambassador, you’ll help grow our amazing community by referring friends and earning exclusive rewards!",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: height / 55,
                            fontFamily: 'defaultfonts'),
                        textAlign: TextAlign.center,
                      )),
                    ),
                    SizedBox(
                      height: height / 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: height / 60,
                          bottom: height / 30,
                          left: width / 22,
                          right: width / 22),
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) {
                              return A_homepage();
                            },
                          ));
                        },
                        child: Container(
                          height: height / 16,
                          width: width,
                          decoration: BoxDecoration(
                            color: Color(0xff7905F5),
                            borderRadius: BorderRadius.circular(height / 10),
                          ),
                          child: Center(
                            child: Text(
                              "Start Your Journey",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // children: [
                    // Text("Already Have an account?  ",
                        // style: TextStyle(
                          // fontSize: height / 53,
                          // fontFamily: 'mulish',
                          // color: Color(0xff26150F),
                        // )),
                    // GestureDetector(
                      // onTap: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                          // builder: (context) {
                            // return signin();
                          // },
                        // ));
                      // },
                      // child: Text(
                        // "Sign in",
                        // style: TextStyle(
                          // decoration: TextDecoration.underline,
                          // decorationColor: Color(0xff7905F5),
                          // decorationThickness: 2,
                          // fontSize: height / 53,
                          // fontWeight: FontWeight.w900,
                          // fontFamily: 'mulish',
                          // color: Color(0xff7905F5),
                        // ),
                        // textAlign: TextAlign.center,
                      // ),
                    // ),
                  // ],
                // ),
                SizedBox(
                  height: height / 90,
                ),
                // GestureDetector(
                  // onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(builder:(context) {
                      // return A_signup();
                    // },));
                  // },
                  // child: Text(
                    // "Are You Ambassador?",
                    // style: TextStyle(
                      // decoration: TextDecoration.underline,
                      // decorationColor: Color(0xff7905F5),
                      // decorationThickness: 2,
                      // fontSize: height / 55,
                      // fontWeight: FontWeight.w500,
                      // fontFamily: 'mulish',
                      // color: Color(0xff7905F5),
                    // ),
                    // textAlign: TextAlign.center,
                  // ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
