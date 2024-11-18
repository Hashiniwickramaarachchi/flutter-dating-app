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
    this.who = 'users',
    this.initiateDelete = false,
  }) : super(key: key);

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

  // Prompt the user to enter their email and password
  Future<Map<String, String>> _getCredentialsFromUser() async {
    String email = '';
    String password = '';
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Reauthenticate'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Enter your email'),
                onChanged: (value) {
                  email = value;
                },
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Enter your password'),
                onChanged: (value) {
                  password = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
    return {'email': email, 'password': password};
  }
  Future<void> _deleteAccount() async {
  setState(() {
    _isDeleting = true;
  });

  // Small delay to ensure loading spinner displays before closing the bottom sheet
  await Future.delayed(Duration(milliseconds: 100));

  final currentUser = _auth.currentUser;
  final userEmail = currentUser?.email;

  if (userEmail == null) {
    print("Error: currentUser email is null");
    if (mounted) {
      setState(() {
        _isDeleting = false;
      });
    }
    return;
  }

  // Close the bottom sheet

  try {

        await currentUser!.delete();

    // Delete the main user document
    await _firestore.collection(widget.who).doc(userEmail).delete();
    print("Deleted main user document for $userEmail in '${widget.who}' collection.");

    // Fetch all documents in 'Favourite' collection
    final favouriteSnapshots = await _firestore.collection("Favourite").get();

    for (var favDoc in favouriteSnapshots.docs) {
      final fav1Collection = _firestore.collection("Favourite").doc(favDoc.id).collection('fav1');

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

    print("Deleted Firebase Authentication user for $userEmail.");

    await _auth.signOut();

    // Delay to ensure loading spinner displays briefly before navigating
    await Future.delayed(Duration(milliseconds: 300));

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
          return widget.who == "Ambassador" ? A_signin() : signin();
        }),
        (route) => false, // Removes all previous routes
      );
    }
  } catch (e) {
    print("Error deleting account: $e");
    if (mounted) {
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
    }
  } finally {
    if (mounted) {
      setState(() {
        _isDeleting = false;
      });
    }
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
            ? Center(child: CircularProgressIndicator())
            : Center(child: Text("Account deletion completed")),
      ),
    );
  }
}
