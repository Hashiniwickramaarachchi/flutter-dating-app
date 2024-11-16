import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/Usermanegement/signin.dart';
import 'package:datingapp/ambassdor/olduser/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeleteAccountPage extends StatefulWidget {
  final bool initiateDelete;
  String who;

  DeleteAccountPage({
    
    Key? key,
    
    
    this.who='users',
     this.initiateDelete = false}) : super(key: key);

  @override
  _DeleteAccountPageState createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isDeleting = false; // Loading state

  @override
  void initState() {
    super.initState();
    // Automatically start deletion if `initiateDelete` is true
    if (widget.initiateDelete) {
      _deleteAccount();
    }
  }

  Future<void> _deleteAccount() async {
    setState(() {
      _isDeleting = true;
    });
    final currentUser = _auth.currentUser;
    final userEmail = currentUser?.email;
    if (userEmail == null) {
      print("Error: currentUser email is null");
      setState(() {
        _isDeleting = false;
      });
      return;
    }
    try {
      // Delete the main user document
      await _firestore.collection(widget.who).doc(userEmail).delete();
      print("Deleted main user document for $userEmail in '${widget.who}' collection.");
      // Fetch all documents in 'Favourite' collection
if (widget.who=='users') {
  


      final favouriteSnapshots = await _firestore.collection("Favourite").get();
      for (var favDoc in favouriteSnapshots.docs) {
        final fav1Collection = _firestore.collection("Favourite").doc(favDoc.id).collection("fav1");
        try {
          final fav1DocSnapshot = await fav1Collection.doc(userEmail).get();
          if (fav1DocSnapshot.exists) {
            await fav1Collection.doc(userEmail).delete();
            print("Deleted $userEmail from ${favDoc.id}'s 'fav1' subcollection in Favourite.");
          } else {
            print("Document for $userEmail not found in ${favDoc.id}'s 'fav1' subcollection.");
          }
        } catch (e) {
          print("Error deleting $userEmail from ${favDoc.id}'s 'fav1' subcollection: $e");
        }
      }
}
      await currentUser!.delete();
      print("Deleted Firebase Authentication user for $userEmail.");
      print(widget.who);
      await _auth.signOut();
      await Future.delayed(Duration(milliseconds: 300));
      // Navigator.of(context).pushReplacement(
        // MaterialPageRoute(builder: (context) {
          // return widget.who == "Ambassador" ? A_signin() : signin();
        // }),
      // );
Navigator.of(context).pushAndRemoveUntil(
  MaterialPageRoute(builder: (context) => widget.who == "Ambassdor" ? A_signin() : signin()), 
  (Route<dynamic> route) => false,
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
    return WillPopScope(
       onWillPop: () async => false,
      child: Scaffold(
        
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
         appBar: AppBar(
         toolbarHeight: height / 400,
         foregroundColor: const Color.fromARGB(255, 255, 255, 255),
         automaticallyImplyLeading: false,
         backgroundColor: const Color.fromARGB(255, 255, 255, 255),
         surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
       ),
        body: _isDeleting
            ? Center(child: CircularProgressIndicator(),)
            : Center(child: Text("Account deletion completed")),
      ),
    );
  }
}
