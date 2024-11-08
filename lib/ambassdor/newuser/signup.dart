import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/ambassdor/newuser/landingpage.dart';
import 'package:datingapp/ambassdor/olduser/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';

class A_signup extends StatefulWidget {
  const A_signup({super.key});

  @override
  State<A_signup> createState() => _A_signupState();
}

class _A_signupState extends State<A_signup> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  bool _password = true;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
          child: Scaffold(
        body: Container(
          color: Color.fromARGB(255, 255, 255, 255),
          height: height,
          width: width,
          child: Padding(
            padding: EdgeInsets.only(
                top: height / 40,
                bottom: height / 60,
                left: width / 18,
                right: width / 18),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      height: height / 12,
                      child: Image(
                          image: AssetImage(
                              "images/appex logo purple transparent.png")),
                    ),
                  ),
                  Text(
                    "Create Account",
                    style: TextStyle(
                        color: const Color(0xff26150F),
                        fontFamily: "defaultfontsbold",
                        fontWeight: FontWeight.w500,
                        fontSize: height / 28),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(top: height/80),
                    child: Text(
                      "Fill your valid information below",
                      style: TextStyle(
                          color: const Color(0xff7D7676),
                          fontWeight: FontWeight.bold,
                          fontFamily: "defaultfontsbold",
                          fontSize: height / 50),
                    ),
                  ),
                  SizedBox(
                    height: height / 15,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: height / 47,
                    ),
                    child: TextField(
                      style: Theme.of(context).textTheme.headlineSmall,
                      controller: name,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Name',
                        contentPadding:
                            EdgeInsets.only(left: width / 50, top: height / 90),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: height / 47,
                    ),
                    child: TextField(
                      controller: email,
                      style: Theme.of(context).textTheme.headlineSmall,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Email',
                        contentPadding:
                            EdgeInsets.only(left: width / 50, top: height / 90),
                      ),
                    ),
                  ),
                  TextField(
                    controller: password,
                    obscureText: _password,
                    style: Theme.of(context).textTheme.headlineSmall,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Password',
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _password = !_password;
                            });
                          },
                          icon: Icon(
                            _password ? Icons.visibility_off : Icons.visibility,
                            color: Color(0xff4D4D4D),
                            size: height / 40,
                          )),
                      contentPadding:
                          EdgeInsets.only(left: width / 50, top: height / 50),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        side: BorderSide(color: Color(0xff7905F5)),
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value ?? false;
                          });
                        },
                      ),
                      Row(
                        children: [
                          Text(
                            'Agree with ',
                            style: TextStyle(
                                fontSize: height / 58,
                                fontWeight: FontWeight.w600,
                                fontFamily: "mulish",
                                color: Color(0xff4D4D4D)),
                          ),
                          Text(
                            'Terms and Conditions',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xff4D4D4D),
                                decorationThickness: 2,
                                fontSize: height / 58,
                                fontWeight: FontWeight.w600,
                                fontFamily: "mulish",
                                color: Color(0xff4D4D4D)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: height / 35, bottom: height / 30),
                    child: 
                    GestureDetector(
                      onTap: () {
                        Singupcheck();
                      },
                      child: 
                      Container(
                        height: height / 15,
                        width: width,
                        child: Center(
                            child: Text(
                          "Sign up",
                          style: Theme.of(context).textTheme.bodySmall,
                        )),
                        decoration: BoxDecoration(
                            color: Color(0xff7905F5),
                            borderRadius: BorderRadius.circular(height / 10)),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Color.fromARGB(232, 0, 0, 0),
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: width / 30, left: width / 30),
                        child: Text("or continue with",
                            style: TextStyle(
                              fontSize: height / 54,
                              fontFamily: 'mulish',
                              color: Color(0xff26150F),
                            )),
                      ),
                      Expanded(
                        child: Divider(
                          color: Color.fromARGB(232, 0, 0, 0),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: width / 10, right: width / 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: height / 30,
                                bottom: height / 30,
                                left: height / 55,
                                right: height / 55),
                            child: GestureDetector(
                              onTap: () {
                                signInWithGoogle(context);
                              },
                              child: Container(
                                child: Image(
                                    image: AssetImage(
                                        "images/Auto Layout Horizontal.png")),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(height / 3),
                                    border: Border.all(color: Color(0xffCAC7C7))),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: height / 30,
                                bottom: height / 30,
                                left: height / 55,
                                right: height / 55),
                            child: Container(
                              child:
                                  Image(image: AssetImage("images/Group.png")),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(height / 3),
                                  border: Border.all(color: Color(0xffCAC7C7))),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: height / 30,
                                bottom: height / 30,
                                left: height / 55,
                                right: height / 55),
                            child: Container(
                              child: Image(
                                  image: AssetImage(
                                      "images/logos_microsoft-icon.png")),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(height / 3),
                                  border: Border.all(color: Color(0xffCAC7C7))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: height / 99),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account? ",
                              style: TextStyle(
                                fontSize: height / 53,
                                fontFamily: 'mulish',
                                color: Color(0xff26150F),
                              )),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) {
                                  return A_signin();
                                },
                              ));
                            },
                            child: Text("Sign in",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(0xff7905F5),
                                  decorationThickness: 2,
                                  fontSize: height / 53,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'mulish',
                                  color: Color(0xff7905F5),
                                )),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }

  Future Singupcheck() async {
    if (name.text.isNotEmpty &&
        password.text.isNotEmpty &&
        email.text.isNotEmpty &&
        isChecked == true) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email.text.trim(), password: password.text.trim());
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      double latitude = position.latitude;
      double longitude = position.longitude;
      
        FirebaseFirestore.instance
            .collection("Ambassdor")
            .doc(userCredential.user!.email!)
            .set({
          'name': name.text.trim(),
          'email': email.text.trim(),
          'addedusers':[],
          'Address': '',
          'Age': 10,
          'Gender': '',
          'Icon': [],
          'Interest': [],
          'Phonenumber': '',
          'X': latitude,
          'Y': longitude,
          'images': [],
          'profile_pic': '',
          'lastSeen': FieldValue.serverTimestamp(),
          'status': 'Online',
          'height': '150 cm',
          "languages": ['English'],
          'education': 'enter your education',
                    "match_count":0,
             'addedusers':[],
                       'created':FieldValue.serverTimestamp(),
                       "rating":[]


        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Account Created!!",
            style: TextStyle(color: Colors.white),
          ),
        ));
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return A_landingpage();
          },
        ));
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "${e.message}",
            style: TextStyle(color: Colors.red),
          ),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Fill the lines"),
      ));
    }
  }
    Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Create an instance of GoogleSignIn
      final GoogleSignIn _googleSignIn = GoogleSignIn();

      // Sign out of Google Sign-In to ensure the sign-in screen shows up
      await _googleSignIn.signOut();

      // Trigger Google sign-in
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // Add user to Firestore
         Position position = await Geolocator.getCurrentPosition(
     desiredAccuracy: LocationAccuracy.high);
 double latitude = position.latitude;
 double longitude = position.longitude;
        await FirebaseFirestore.instance
            .collection('Ambassdor')
            .doc(user.email)
            .set({
          'name': user.displayName,
          'email': user.email,
          'Address': '',
          'Age': 10,
          'Gender': '',
          'Icon': [],
          'Interest': [],
          'Phonenumber': '',
          'X': latitude,
          'Y': longitude,
          'images': [],
          'profile_pic': '',
          'lastSeen': FieldValue.serverTimestamp(),
          'status': 'Online',
          'height': '150 cm',
          "languages": ['English'],
          'education': 'enter your education',
          "match_count":0,
          'addedusers':[],
                    'created':FieldValue.serverTimestamp(),
                       "rating":[]


        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("Account Created!!", style: TextStyle(color: Colors.white)),
        ));
Navigator.of(context).push(MaterialPageRoute(builder:(context) {
  return A_landingpage();
},));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e", style: TextStyle(color: Colors.red)),
        ),
      );
    }
  }
}
