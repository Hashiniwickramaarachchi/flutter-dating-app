import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/Landingpages/ladingpage.dart';
import 'package:datingapp/accountdelectionpage.dart';
import 'package:datingapp/ambassdor/A_Mainscree.dart';
import 'package:datingapp/ambassdor/newuser/homepage.dart';
import 'package:datingapp/ambassdor/newuser/landingpage.dart';
import 'package:datingapp/ambassdor/olduser/signin.dart';
import 'package:datingapp/block.dart';
import 'package:datingapp/blockpage.dart';
import 'package:datingapp/deactivepage.dart';
import 'package:datingapp/deleted.dart';
import 'package:datingapp/termandcondition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
  bool isLoading = false; // Add a loading state

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
                  padding: EdgeInsets.only(top: height / 80),
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
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return termandcondition();
                              },
                            ));
                          },
                          child: Text(
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
                        child: isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              ) // Show loader when loading
                            : Text(
                                "Sign up",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                      ),
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
                  padding: EdgeInsets.only(left: width / 5, right: width / 5),
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
                          child: GestureDetector(
                            onTap: () async {
                              final user = await signInWithApple(context);
                              if (user != null) {
                                print("Signed in as: ${user.email}");
                              } else {
                                print("Apple Sign-In canceled or failed");
                              }
                            },
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
    );
  }

  // Future Singupcheck() async {
  // if (name.text.isNotEmpty &&
  // password.text.isNotEmpty &&
  // email.text.isNotEmpty &&
  // isChecked == true) {
  // setState(() {
  // isLoading = true; // Start loading
  // });
  // try {
  // UserCredential userCredential = await FirebaseAuth.instance
  // .createUserWithEmailAndPassword(
  // email: email.text.trim(), password: password.text.trim());
  //
  // Position position = await Geolocator.getCurrentPosition(
  // desiredAccuracy: LocationAccuracy.high);
  // double latitude = position.latitude;
  // double longitude = position.longitude;
//
  // FirebaseFirestore.instance
  // .collection("Ambassdor")
  // .doc(userCredential.user!.email!)
  // .set({
  // 'name': name.text.trim(),
  // 'email': email.text.trim(),
  // 'addedusers': [],
  // 'Address': '',
  // 'Age': 10,
  // 'Gender': '',
  // 'Icon': [],
  // 'Interest': [],
  // 'Phonenumber': '',
  // 'X': latitude,
  // 'Y': longitude,
  // 'images': [],
  // 'profile_pic': '',
  // 'lastSeen': FieldValue.serverTimestamp(),
  // 'status': 'Online',
  // 'height': '150 cm',
  // "languages": ['English'],
  // 'education': '',
  // "match_count": 0,
  // 'addedusers': [],
  // 'created': FieldValue.serverTimestamp(),
  // "rating": [],
  // 'description': ''
  // });
  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  // content: Text(
  // "Account Created!!",
  // style: TextStyle(color: Colors.white),
  // ),
  // ));
  // Navigator.of(context).pushReplacement(MaterialPageRoute(
  // builder: (context) {
  // return A_landingpage();
  // },
  // ));
  // } on FirebaseAuthException catch (e) {
  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  // content: Text(
  // "${e.message}",
  // style: TextStyle(color: Colors.red),
  // ),
  // ));
  // }
  // } else {
  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  // content: Text("Fill the lines"),
  // ));
  // }
  // }
  Future Singupcheck() async {
    if (name.text.isNotEmpty &&
        password.text.isNotEmpty &&
        email.text.isNotEmpty &&
        isChecked == true) {
      setState(() {
        isLoading = true; // Start loading
      });

      // Request location permission
      LocationPermission permission = await Geolocator.requestPermission();
      double latitude = 37.7749; // Example: San Francisco
    double  longitude = -122.4194;// Default longitude
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
     try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        latitude = position.latitude;
        longitude = position.longitude;
      } catch (e) {
        print("Error getting location: $e");
      }
      } else {
      // User denied location permission - use default coordinates
      latitude = 37.7749; // Example: San Francisco
      longitude = -122.4194;
    }


      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email.text.trim(), password: password.text.trim());

        // Get user location
      

        // Save user data in Firestore
        FirebaseFirestore.instance
            .collection("Ambassdor")
            .doc(userCredential.user!.email!)
            .set({
          'name': name.text.trim(),
          'email': email.text.trim(),
          'addedusers': [],
          'Address': '',
          'Age': 18,
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
          'height': '0 cm',
          "languages": [],
          'education': '',
          "match_count": 0,
          'created': FieldValue.serverTimestamp(),
          "rating": [],
          'description': '',
          'statusType': "active",
          'Logged': 'true',
          'deviceToken': await FirebaseMessaging.instance.getToken()
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Account Created!!",
            style: TextStyle(color: Colors.white),
          ),
        ));

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => A_landingpage()),
          (Route<dynamic> route) => false,
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false; // Stop loading
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "${e.message}",
            style: TextStyle(color: Colors.red),
          ),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please fill in all the required fields."),
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
      PermissionStatus locationPermission = await Permission.location.request();

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Normalize the email to avoid case sensitivity issues
        final String normalizedEmail = user.email!.toLowerCase().trim();

        // Check if the user exists in the Ambassdor collection
        final DocumentSnapshot ambassadorDoc = await FirebaseFirestore.instance
            .collection('Ambassdor')
            .doc(normalizedEmail)
            .get();

        if (ambassadorDoc.exists) {
          await FirebaseFirestore.instance
              .collection("Ambassdor")
              .doc(user.email)
              .update(
                  {'deviceToken': await FirebaseMessaging.instance.getToken()});
          // Ambassdor account exists, check the account's status
          final data = ambassadorDoc.data() as Map<String, dynamic>?;
          if (data != null) {
            switch (data['statusType']) {
              case 'active':
                // Update user's login status and navigate to the main screen
                await FirebaseFirestore.instance
                    .collection('Ambassdor')
                    .doc(normalizedEmail)
                    .update({'Logged': 'true'});

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => A_MainScreen()),
                  (Route<dynamic> route) => false,
                );
                break;

              case 'block':
                // Handle blocked account
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => block()),
                  (Route<dynamic> route) => false,
                );
                break;

              case 'delete':
                // Navigate to account deletion page
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) {
                    return DeleteAccountPage(
                      initiateDelete: true,
                      who: 'Ambassdor',
                    );
                  }),
                );
                break;

              default:
                // Handle other statuses (e.g., deactivated)
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => deactivepage()),
                  (Route<dynamic> route) => false,
                );
            }
          }
        } else {
          // New user; check if the user exists in other collections
          PermissionStatus locationPermission =
              await Permission.location.request();

          final DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(normalizedEmail)
              .get();
          final DocumentSnapshot deleteDoc = await FirebaseFirestore.instance
              .collection('delete')
              .doc(normalizedEmail)
              .get();

          if (!userDoc.exists && !deleteDoc.exists) {
            // Register the new Ambassdor account

            if (locationPermission.isGranted) {
              // Get user's current location
              Position position = await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.high);
              double latitude = position.latitude;
              double longitude = position.longitude;

              await FirebaseFirestore.instance
                  .collection('Ambassdor')
                  .doc(normalizedEmail)
                  .set({
                'name': user.displayName,
                'email': normalizedEmail,
                'Address': '',
                'Age': 18,
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
                'height': '0 cm',
                "languages": [],
                'education': '',
                "match_count": 0,
                'addedusers': [],
                "rating": [],
                'description': '',
                'statusType': "active",
                'Logged': 'true',
                'deviceToken': await FirebaseMessaging.instance.getToken()
              });

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => A_landingpage()),
                (Route<dynamic> route) => false,
              );
            } else if (locationPermission.isDenied ||
                locationPermission.isPermanentlyDenied) {
              // Handle denied location permissions
              await FirebaseFirestore.instance
                  .collection('Ambassdor')
                  .doc(normalizedEmail)
                  .set({
                'name': user.displayName,
                'email': normalizedEmail,
                'Address': '',
                'Age': 18,
                'Gender': '',
                'Icon': [],
                'Interest': [],
                'Phonenumber': '',
                'X': 37.7749,
                'Y': -122.4194,
                'images': [],
                'profile_pic': '',
                'lastSeen': FieldValue.serverTimestamp(),
                'status': 'Online',
                'height': '0 cm',
                "languages": [],
                'education': '',
                "match_count": 0,
                'addedusers': [],
                "rating": [],
                'description': '',
                'statusType': "active",
                'Logged': 'true',
                'deviceToken': await FirebaseMessaging.instance.getToken()
              });

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => A_landingpage()),
                (Route<dynamic> route) => false,
              );
            }
          } else {
            // User email is invalid for registration
            await FirebaseAuth.instance.signOut();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "This Email Not Valid in the Ambassador Account",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }
        }
      }

      return user;
    } catch (e) {
      print('Error during Google Sign-In: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "An error occurred during Google Sign-In. Please try again.",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return null;
    }
  }

  Future<User?> signInWithApple(BuildContext context) async {
    try {
      // Sign in with Apple
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create Firebase Auth Credential
      final AuthCredential credential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final String? email = user.email;
        final String? displayName =
            user.displayName ?? appleCredential.givenName;

        // Firestore references
        final userDoc =
            FirebaseFirestore.instance.collection('Ambassdor').doc(email);
        final ambassadorDoc =
            FirebaseFirestore.instance.collection('users').doc(email);
        final deleteDoc =
            FirebaseFirestore.instance.collection('delete').doc(email);

        // Check Firestore for user document
        final userSnapshot = await userDoc.get();
        final ambassadorSnapshot = await ambassadorDoc.get();
        final deleteSnapshot = await deleteDoc.get();

        if (!userSnapshot.exists &&
            !ambassadorSnapshot.exists &&
            !deleteSnapshot.exists) {
          // Request location permission
          PermissionStatus locationPermission =
              await Permission.location.request();

          if (locationPermission.isGranted) {
            // Get user's current location
            Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high);
            double latitude = position.latitude;
            double longitude = position.longitude;

            // Create new ambassador document
            await userDoc.set({
              'name': displayName ?? 'Unknown User',
              'email': email,
              'Address': '',
              'Age': 18,
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
              'height': '0 cm',
              "languages": [],
              'education': '',
              "match_count": 0,
              'addedusers': [],
              "rating": [],
              'description': '',
              'statusType': "active",
              'Logged': 'true',
              'deviceToken': await FirebaseMessaging.instance.getToken(),
            });

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      A_landingpage()), // Replace with your landing page widget
              (Route<dynamic> route) => false,
            );
          } else {
            // Handle denied location permissions
             await userDoc.set({
              'name': displayName ?? 'Unknown User',
              'email': email,
              'Address': '',
              'Age': 18,
              'Gender': '',
              'Icon': [],
              'Interest': [],
              'Phonenumber': '',
              'X': 37.7749,
              'Y': -122.4194,
              'images': [],
              'profile_pic': '',
              'lastSeen': FieldValue.serverTimestamp(),
              'status': 'Online',
              'height': '0 cm',
              "languages": [],
              'education': '',
              "match_count": 0,
              'addedusers': [],
              "rating": [],
              'description': '',
              'statusType': "active",
              'Logged': 'true',
              'deviceToken': await FirebaseMessaging.instance.getToken(),
            });

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      A_landingpage()), // Replace with your landing page widget
              (Route<dynamic> route) => false,
            );
          }
        } else if (userSnapshot.exists) {
          // Update device token
          await userDoc.update(
              {'deviceToken': await FirebaseMessaging.instance.getToken()});

          // Fetch updated user document
          final updatedUserDoc = await userDoc.get();
          final data = updatedUserDoc.data() as Map<String, dynamic>?;

          if (data!['statusType'] == 'active') {
            Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high);
            double latitude = position.latitude;
            double longitude = position.longitude;

            await userDoc.update({'Logged': 'true'});
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      A_MainScreen()), // Replace with your main screen widget
              (Route<dynamic> route) => false,
            );
          } else if (data!['statusType'] == 'block') {
            await FirebaseAuth.instance.signOut();

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      block()), // Replace with your block page widget
              (Route<dynamic> route) => false,
            );
          } else if (data!['statusType'] == 'delete') {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => DeleteAccountPage(
                initiateDelete: true,
                who: 'Ambassdor',
              ), // Replace with your delete account page widget
            ));
          } else {
            await FirebaseAuth.instance.signOut();

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      deactivepage()), // Replace with your deactivation page widget
              (Route<dynamic> route) => false,
            );
          }
        } else {
          await FirebaseAuth.instance.signOut();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("This Email Not Valid in the Ambassador Account",
                style: TextStyle(color: Colors.white)),
          ));
        }
      }

      return user;
    } catch (e) {
      print('Error signing in with Apple: $e');
      return null;
    }
  }
}
