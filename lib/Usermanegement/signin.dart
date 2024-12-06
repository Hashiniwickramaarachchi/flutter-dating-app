import 'package:datingapp/Usermanegement/addemail.dart';
import 'package:datingapp/Usermanegement/gender.dart';
import 'package:datingapp/Usermanegement/signup.dart';
import 'package:datingapp/accountdelectionpage.dart';
import 'package:datingapp/ambassdor/newuser/signup.dart';
import 'package:datingapp/block.dart';
import 'package:datingapp/deactivepage.dart';
import 'package:datingapp/deleted.dart';
import 'package:datingapp/homepage.dart';
import 'package:datingapp/mainscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

class signin extends StatefulWidget {
  const signin({super.key});

  @override
  State<signin> createState() => _signinState();
}

class _signinState extends State<signin> {
  bool _password = true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final email = TextEditingController();
  final password = TextEditingController();
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
        height: height,
        width: width,
        color: Color.fromARGB(255, 255, 255, 255),
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
                SizedBox(
                  height: height / 200,
                ),
                Text(
                  "Sign in",
                  style: TextStyle(
                      color: const Color(0xff26150F),
                      fontFamily: "defaultfontsbold",
                      fontWeight: FontWeight.w500,
                      fontSize: 32),
                ),
                SizedBox(
                  height: height / 200,
                ),
                Text(
                  "Hi, Welcome Back!",
                  style: TextStyle(
                      color: const Color(0xff7D7676),
                      fontWeight: FontWeight.bold,
                      fontFamily: "defaultfontsbold",
                      fontSize: 20),
                ),
                SizedBox(
                  height: height / 15,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: height / 30,
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
                    border: UnderlineInputBorder(),
                    hintText: 'Password',
                    contentPadding:
                        EdgeInsets.only(left: width / 50, top: height / 50),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height / 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return Addemail();
                            },
                          ));
                        },
                        child: Text(
                          "Forget Password?",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: "mulish",
                              color: Color(0xff7905F5)),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: height / 20, bottom: height / 27),
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.of(context).push(MaterialPageRoute(builder:(context) {
                      //   return land();
                      // },));
                      signInWithEmail();
                    },
                    child: Container(
                      height: height / 15,
                      width: width,
                      child: Center(
                          child: Text(
                        "Sign in",
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
                      child: Text("or sign in with",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'mulish',
                            color: Color(0xff26150F),
                          )),
                    ),
                    Expanded(
                      child: Divider(
                        color: Color(0xff26150F),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: width / 10, right: width / 10, top: height / 90),
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
                              bottom: height / 30,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Dont't have an Account?  ",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'mulish',
                            color: Color(0xff26150F),
                          )),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return signup();
                            },
                          ));
                        },
                        child: Text("Sign up",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xff7905F5),
                              decorationThickness: 2,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'mulish',
                              color: Color(0xff7905F5),
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height / 50,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) {
                        return A_signup();
                      },
                    ));
                  },
                  child: Text(
                    "Are You Ambassador?",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xff7905F5),
                      decorationThickness: 2,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'mulish',
                      color: Color(0xff7905F5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signInWithEmail() async {
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      final userSnapshot =
          await _firestore.collection('users').doc(email.text.trim()).get();
      if (userSnapshot.exists) {
        final data = userSnapshot.data() as Map<String, dynamic>?;
        if (data!['statusType'] == 'active') {
          try {
            UserCredential userCredential =
                await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: email.text.trim(),
              password: password.text.trim(),
            );

            await FirebaseFirestore.instance
                .collection('users')
                .doc(email.text.trim())
                .update({'Logged': 'true'});

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Signin", style: TextStyle(color: Colors.white)),
            ));

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MainScreen()),
              (Route<dynamic> route) => false,
            );
          } on FirebaseAuthException catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text("${e.message}", style: TextStyle(color: Colors.red)),
            ));
          }
        } else if (data!['statusType'] == 'block') {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => block()),
            (Route<dynamic> route) => false,
          );
        } else if (data!['statusType'] == 'delete') {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) {
              return DeleteAccountPage(
                initiateDelete: true,
                who: 'users',
              );
            },
          ));
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => deactivepage()),
            (Route<dynamic> route) => false,
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Enter Valid Email for User Account",
              style: TextStyle(color: Colors.white)),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Fill the lines", style: TextStyle(color: Colors.white)),
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

        final DocumentSnapshot deleteDoc = await FirebaseFirestore.instance
            .collection('delete')
            .doc(user.email)
            .get();
        if (!userDoc.exists && !AmbassdorDoc.exists && !deleteDoc.exists) {
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
            "languages": [],
            'education': '',
            'profile': "standard",
            "description": '',
            'statusType': "active",
            'Logged': 'true'
          });
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) {
              return gender();
            },
          ));
        } else {
          final userSnapshot =
              await _firestore.collection('users').doc(user.email).get();
          if (userSnapshot.exists) {
            // Fetch the updated user document
            final updatedUserDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(user.email)
                .get();

            final data = updatedUserDoc.data() as Map<String, dynamic>?;
            if (data!['statusType'] == 'active') {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.email)
                  .update({'Logged': 'true'});
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MainScreen()),
                (Route<dynamic> route) => false,
              );
            } else if (data!['statusType'] == 'block') {
              await FirebaseAuth.instance.signOut();

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => block()),
                (Route<dynamic> route) => false,
              );
            } else if (data!['statusType'] == 'delete') {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) {
                  return DeleteAccountPage(
                    initiateDelete: true,
                    who: 'users',
                  );
                },
              ));
            } else {
              await FirebaseAuth.instance.signOut();

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => deactivepage()),
                (Route<dynamic> route) => false,
              );
            }
          } else {
                          await FirebaseAuth.instance.signOut();

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
