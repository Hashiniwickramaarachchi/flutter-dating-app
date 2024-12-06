import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/Usermanegement/signin.dart';
import 'package:datingapp/accountdelectionpage.dart';
import 'package:datingapp/ambassdor/olduser/signin.dart';
import 'package:datingapp/userdeleted.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class accountdelete extends StatefulWidget {
  final String who;

  accountdelete({required this.who, Key? key}) : super(key: key);

  @override
  State<accountdelete> createState() => _accountdeleteState();
}

class _accountdeleteState extends State<accountdelete> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // bool _isDeleting = false; // Loading state
// 
  // Future<void> _deleteAccount() async {
    // setState(() {
      // _isDeleting = true;
    // });
// 
    // final currentUser = _auth.currentUser;
    // final userEmail = currentUser?.email;
// 
    // if (userEmail == null) {
      // print("Error: currentUser email is null");
      // setState(() {
        // _isDeleting = false;
      // });
      // return;
    // }
// 
    // try {
      // await _firestore.collection(widget.who).doc(userEmail).delete();
      // print("Deleted main user document for $userEmail in '${widget.who}' collection.");
// 
      // final favouriteSnapshots = await _firestore.collection("Favourite").get();
// 
      // for (var favDoc in favouriteSnapshots.docs) {
        // final fav1Collection = _firestore.collection("Favourite").doc(favDoc.id).collection('fav1');
// 
        // try {
          // final fav1DocSnapshot = await fav1Collection.doc(userEmail).get();
// 
          // if (fav1DocSnapshot.exists) {
            // await fav1Collection.doc(userEmail).delete();
            // print("Deleted $userEmail from ${favDoc.id}'s 'fav1' subcollection in Favourite.");
          // } else {
            // print("Document for $userEmail not found in ${favDoc.id}'s 'fav1' subcollection.");
          // }
        // } catch (e) {
          // print("Error deleting $userEmail from ${favDoc.id}'s 'fav1' subcollection: $e");
        // }
      // }
// 
      // await currentUser!.delete();
      // print("Deleted Firebase Authentication user for $userEmail.");
// 
      // await _auth.signOut();
// 
      // await Future.delayed(Duration(milliseconds: 300));
// 
      // Navigator.of(context).pushReplacement(
        // MaterialPageRoute(builder: (context) {
          // return widget.who == "Ambassador" ? A_signin() : signin();
        // }),
      // );
    // } catch (e) {
      // print("Error deleting account: $e");
      // showDialog(
        // context: context,
        // builder: (context) => AlertDialog(
          // title: Text("Error"),
          // content: Text("Failed to delete account: ${e.toString()}"),
          // actions: [
            // TextButton(
              // onPressed: () => Navigator.of(context).pop(),
              // child: Text("OK"),
            // ),
          // ],
        // ),
      // );
    // } finally {
      // setState(() {
        // _isDeleting = false;
      // });
    // }
  // }
// 
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final currentUser = FirebaseAuth.instance.currentUser;

    // Check if currentUser is null before accessing its email
    if (currentUser == null) {
      return const Center(child: Text("User not found."));
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection(widget.who).doc(currentUser.email).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userData = snapshot.data!.data() as Map<String, dynamic>?;
          if (userData == null) {
            return const Center(child: Text("User data not found."));
          }

          return Stack(
            children: [
              Container(
                width: width,
                height: height / 1.5,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 15, vertical: height / 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.warning, color: Color(0xffE51C0B), size: 60),
                      SizedBox(height: height / 60),
                      const Text(
                        "Are you sure?",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(height: height / 50),
                      const Text(
                        "If you delete your account, you won’t be able to log in with it anymore. Are you sure you want to continue?",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xff565656), fontSize: 13),
                      ),
                      SizedBox(height: height / 50),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(width, 50),
                          backgroundColor: const Color(0xffE51C0B),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed:() {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context) {
                            return userdeleted(initiateDelete: true,who: widget.who,);
                          },));
                        },
                        child: const Text("Delete Account", style: TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
