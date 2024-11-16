import 'package:datingapp/ambassdor/newuser/landingpage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiveLocationPage extends StatefulWidget {
  final String email;

  LiveLocationPage({required this.email});

  @override
  State<LiveLocationPage> createState() => _LiveLocationPageState();
}

class _LiveLocationPageState extends State<LiveLocationPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getAndSaveLocation();
  }

  Future<void> _getAndSaveLocation() async {
    try {
      // Get the user's location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Update Firestore
      await FirebaseFirestore.instance.collection('Ambassdor').doc(widget.email).update({
        'X': position.latitude,
        'Y': position.longitude,
      });

      // Navigate to A_landingpage
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => A_landingpage(),
      ));
    } catch (e) {
      print("Error getting location: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to get location. Please try again."),
      ));
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : Text("Retry to get your location."),
        ),
      ),
    );
  }
}
