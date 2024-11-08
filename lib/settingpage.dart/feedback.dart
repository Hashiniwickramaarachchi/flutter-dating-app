import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  double rating = 0;
  String feedbackType = 'General Feedback';
  String feedbackText = '';
  List<String> feedbackTypes = ['General Feedback', 'Bug Report', 'Feature Request'];
 File? _screenshot;
  final picker = ImagePicker();
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserRating(); // Load user's previous rating if available
  }

  Future<void> _loadUserRating() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final DocumentSnapshot ratingDoc = await FirebaseFirestore.instance
        .collection("Ratings")
        .doc(currentUser.email!)
        .get();

    if (ratingDoc.exists) {
      final data = ratingDoc.data() as Map<String, dynamic>;
      setState(() {
        rating = data['rating'] ?? 0;
      });
    }
  }
  Future<void> _pickScreenshot() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _screenshot = File(pickedFile.path);
      });
    }
  }
    Future<String?> _uploadScreenshot() async {
    if (_screenshot == null) return null;

    try {
      final currentUser = FirebaseAuth.instance.currentUser!;
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("screenshots/${currentUser.email!}_${DateTime.now().millisecondsSinceEpoch}.jpg");

      final uploadTask = storageRef.putFile(_screenshot!);
      final snapshot = await uploadTask;

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Failed to upload screenshot: $e");
      return null;
    }
  }
  Future<void> _submitFeedback() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    String? screenshotUrl;

    if (_screenshot != null) {
      screenshotUrl = await _uploadScreenshot();
    }
    await FirebaseFirestore.instance
    
        .collection("Ratings")
        .doc(currentUser.email!)
        .set({
      'rating': rating,
      'feedbackType': feedbackType,
      'feedbackText': feedbackText,
            'screenshotUrl': screenshotUrl,

      'timestamp': FieldValue.serverTimestamp(),
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Feedback submitted successfully!")),
    );

_feedbackController.clear();
setState(() {
  _screenshot=null;

});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    children: [
                      Container(
                        height: height / 10,
                        width: width / 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 1, color: Colors.black),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: const Color.fromARGB(255, 121, 5, 245),
                          ),
                        ),
                      ),
                                            SizedBox(width: width / 10),

                      Expanded(
                        child: Center(
                          child: Text(
                            "FAQs & Help Center",
                            style: TextStyle(
                                color: const Color(0xff26150F),
                                fontFamily: "defaultfontsbold",
                                fontWeight: FontWeight.w500,
                                fontSize: height / 35),
                          ),
                        ),
                      ),
                      SizedBox(width: width / 10),
                    ],
                  ),
                ),
                SizedBox(height: height / 30),
                Text(
                  'We Value Your Feedback',
                  style: TextStyle(
                    color: Color(0xff4D4D4D),
                    fontWeight: FontWeight.bold,
                    fontSize: height / 45,
                  ),
                ),
                SizedBox(height: height / 80),
                // RatingBar.builder(
                  // initialRating: rating,
                  // itemSize: height / 30,
                  // glowColor: Colors.black,
                  // minRating: 1,
                  // direction: Axis.horizontal,
                  // allowHalfRating: false,
                  // itemCount: 5,
                  // itemBuilder: (context, _) => Icon(
                    // Icons.star,
                    // color: Colors.amber,
                  // ),
                  // onRatingUpdate: (ratingValue) {
                    // setState(() {
                      // rating = ratingValue;
                    // });
                  // },
                // ),
                SizedBox(height: 20),
                Container(
                  height: height / 3,
                  decoration: BoxDecoration(
                    color: Color(0xffF9F9F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _feedbackController,
                    maxLines: null,
                    onChanged: (value) {
                      feedbackText = value;
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fillColor: Color(0xffF9F9F9),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  dropdownColor: Colors.white,
                  value: feedbackType,
                  items: feedbackTypes.map((String category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      feedbackType = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xff8F9DA6)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xff8F9DA6)),
                    ),
                    contentPadding: EdgeInsets.only(left: width / 50, top: height / 50),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: width / 1.7),
                  child: GestureDetector(
                    onTap: () {
_pickScreenshot();                    },
                    child: Container(
                      height: height / 20,
                      width: width / 2,
                      decoration: BoxDecoration(
                        color: Color(0xff565656),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "Attach Screenshot",
                            style: TextStyle(
                                color: Colors.white, fontSize: height / 60, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                  if (_screenshot != null) // Show a preview if a screenshot is selected
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Image.file(_screenshot!, height: height / 5),
                  ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: _submitFeedback,
                  child: Container(
                    height: height / 20,
                    width: width,
                    decoration: BoxDecoration(
                      color: Color(0xff7905F5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Submit Feedback",
                        style: TextStyle(
                            color: Colors.white, fontSize: height / 60, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
