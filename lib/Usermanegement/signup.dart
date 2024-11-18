import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/Usermanegement/addemail.dart';
import 'package:datingapp/Usermanegement/gender.dart';
import 'package:datingapp/Usermanegement/signin.dart';
import 'package:datingapp/mainscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height / 400,
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        height: height,
        width: width,
        child: Padding(
          padding: EdgeInsets.only(
              bottom: height / 60, left: width / 18, right: width / 18),
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
                      fontSize: 32),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height / 120),
                  child: Text(
                    "Fill your valid information below",
                    style: TextStyle(
                        color: const Color(0xff7D7676),
                        fontWeight: FontWeight.bold,
                        fontFamily: "defaultfontsbold",
                        fontSize: 16),
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
                SizedBox(
                  height: height / 90,
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
                              fontSize: 13,
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
                              fontSize: 13,
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
                      EdgeInsets.only(top: height / 35, bottom: height / 40),
                  child: GestureDetector(
                    onTap: () {
                      Singupcheck();
                    },
                    child: Container(
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
                      padding:
                          EdgeInsets.only(right: width / 30, left: width / 30),
                      child: Text("or continue with",
                          style: TextStyle(
                            fontSize: 15,
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
                  padding: EdgeInsets.only(left: width / 10, right: width / 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: height / 30,
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
                              left: height / 55,
                              right: height / 55),
                          child: Container(
                            child: Image(image: AssetImage("images/Group.png")),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(height / 3),
                                border: Border.all(color: Color(0xffCAC7C7))),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: height / 30,
                              left: height / 55,
                              right: height / 55),
                          child: Container(
                            child: Image(
                                image: AssetImage(
                                    "images/logos_microsoft-icon.png")),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(height / 3),
                                border: Border.all(color: Color(0xffCAC7C7))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: height / 40),
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
                                return signin();
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
        FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user!.email!)
            .set({
          'name': name.text.trim(),
          'email': email.text.trim(),
          'Address': '',
          'Age': 0,
          'Gender': '',
          'Icon': [],
          'Interest': [],
          'Phonenumber': '',
          'X': 0.0,
          'Y': 0.0,
          'images': [],
          'profile_pic': '',
          'lastSeen': FieldValue.serverTimestamp(),
          'status': 'Online',
          'height': '0 cm',
          'created': FieldValue.serverTimestamp(),
          "languages": ['None'],
          'education': '',
          'profile': "standard",
          "description": ''
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Account Created!!",
            style: TextStyle(color: Colors.white),
          ),
        ));
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) {
            return gender();
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
    Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      // Sign out of Google Sign-In to ensure the sign-in screen shows up
      await GoogleSignIn().signOut();

      // Trigger Google sign-in
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return null; // The user canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Check Firestore for the user document
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .get();
 final DocumentSnapshot AmbassdorDoc = await FirebaseFirestore.instance
     .collection('Ambassdor')
     .doc(user.email)
     .get();


        if (!userDoc.exists && !AmbassdorDoc.exists) {
              await FirebaseFirestore.instance
              .collection('users')
              .doc(user.email)
              .set({
            'name': user.displayName,
            'email': user.email,
            'Address': '',
            'Age': 0,
            'Gender': '',
            'Icon': [],
            'Interest': [],
            'Phonenumber': '',
            'X': 0.0,
            'Y': 0.0,
            'images': [],
            'profile_pic': '',
            'lastSeen': FieldValue.serverTimestamp(),
            'status': 'Online',
            'height': '0 cm',
            'created': FieldValue.serverTimestamp(),
            "languages": ['None'],
            'education': '',
            'profile': "standard",
            "description": ''
          });
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) {
              return gender();
            },
          ));











        } else {
          final userSnapshot =
              await FirebaseFirestore.instance.collection('users').doc(user.email).get();
          if (userSnapshot.exists) {
            // Fetch the updated user document
            final updatedUserDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(user.email)
                .get();

            final data = updatedUserDoc.data() as Map<String, dynamic>?;

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MainScreen()),
              (Route<dynamic> route) => false,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Enter Valid Email for User Account",
                  style: TextStyle(color: Colors.white)),
            ));
          }
        }
      }

      return user;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }
}
