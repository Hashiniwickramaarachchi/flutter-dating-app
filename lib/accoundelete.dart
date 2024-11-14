import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/Usermanegement/signin.dart';
import 'package:datingapp/ambassdor/olduser/signin.dart';
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
  bool _isDeleting = false; // Loading state

  Future<void> _deleteAccount() async {
    setState(() {
      _isDeleting = true;
    });

    final currentUser = _auth.currentUser;
    final userEmail = currentUser?.email; // Store the email before deleting the user

    if (userEmail == null) {
      print("Error: currentUser email is null");
      return;
    }

    try {
      // Delete the main user document
      await _firestore.collection(widget.who).doc(userEmail).delete();

      // Delete the main chat document
      // final chatDocRef = _firestore.collection('chats').doc(userEmail);
      // final chatDocSnapshot = await chatDocRef.get();

      // if (chatDocSnapshot.exists) {
        // await chatDocRef.delete();
        // print("Deleted chat document for $userEmail in 'chats' collection.");
      // } else {
        // print("No chat document found for $userEmail in 'chats' collection.");
      // }

      await currentUser!.delete();
      print("Deleted Firebase Authentication user for $userEmail.");

      await _auth.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) {
          return widget.who == "Ambassador" ? A_signin() : signin();
        }),
      );
    } catch (e) {
      print("Error deleting account: $e");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Failed to delete account: ${e.toString()}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isDeleting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final currentUser = FirebaseAuth.instance.currentUser;

    // Check if currentUser is null before accessing its email
    if (currentUser == null) {
      return Center(child: Text("User not found."));
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection(widget.who).doc(currentUser.email).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userData = snapshot.data!.data() as Map<String, dynamic>?;
          if (userData == null) {
            return Center(child: Text("User data not found."));
          }

          return Stack(
            children: [
              Container(
                width: width,
                height: height / 2.5,
                decoration: BoxDecoration(
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
                      Icon(Icons.warning, color: Color(0xffE51C0B), size: 60),
                      SizedBox(height: height / 60),
                      Text(
                        "Are you sure?",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(height: height / 50),
                      Text(
                        "If you delete your account, you won’t be able to log in with it anymore. Are you sure you want to continue?",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xff565656), fontSize: 13),
                      ),
                      SizedBox(height: height / 50),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(width, 50),
                          backgroundColor: Color(0xffE51C0B),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: _deleteAccount,
                        child: Text("Delete Account", style: TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                    ],
                  ),
                ),
              ),
              if (_isDeleting)
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
