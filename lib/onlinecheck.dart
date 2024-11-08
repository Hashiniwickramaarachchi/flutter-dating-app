import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';

class OnlineStatusService with WidgetsBindingObserver {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  // Helper function to sanitize the email for valid database paths
  String sanitizeEmail(String email) {
    return email.replaceAll('.', ','); // Replace '.' with ','
  }

  void startTracking() {
    WidgetsBinding.instance.addObserver(this);
    updateUserStatus(); // Initially mark user as online
  }

  void stopTracking() {
    WidgetsBinding.instance.removeObserver(this);
    setUserOffline(); // Mark user as offline when stop tracking (log out or exit)
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      // App is going to background or closed, set user as offline in Firestore
      setUserOffline();
    } else if (state == AppLifecycleState.resumed) {
      // App is back to foreground, set user as online
      updateUserStatus();
    }
  }

  Future<void> updateUserStatus() async {
    User? user = _auth.currentUser;
    
    if (user != null) {
      String sanitizedEmail = sanitizeEmail(user.email.toString());  // Sanitize the email

      // Mark the user online in Firestore
      await _firestore.collection('users').doc(user.email).set({
        'status': 'online',
        'lastSeen': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)); // Use merge to avoid overwriting other fields.

      // Use the sanitized email in the Firebase Realtime Database path
      DatabaseReference userStatusRef = _databaseRef.child('status/$sanitizedEmail');

      // Automatically set the user as offline in the Realtime Database when disconnected
      userStatusRef.onDisconnect().set({
        'status': 'offline',
        'lastSeen': ServerValue.timestamp // Use Firebase server timestamp
      });

      // Set the user as online in the Realtime Database
      userStatusRef.set({
        'status': 'online',
        'lastSeen': DateTime.now().millisecondsSinceEpoch
      });
    }
  }

  Future<void> setUserOffline() async {
    User? user = _auth.currentUser;

    if (user != null) {
      String sanitizedEmail = sanitizeEmail(user.email.toString());  // Sanitize the email

      // Mark user offline in Firestore
      await _firestore.collection('users').doc(user.email).set({
        'status': 'offline',
        'lastSeen': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Update the user's status in Firebase Realtime Database
      DatabaseReference userStatusRef = _databaseRef.child('status/$sanitizedEmail');
      userStatusRef.set({
        'status': 'offline',
        'lastSeen': ServerValue.timestamp // Use Firebase server timestamp to ensure accurate time
      });
    }
  }
}
