import 'dart:io';

import 'package:datingapp/homepage.dart';
import 'package:datingapp/mainscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class completeprofile extends StatefulWidget {
  const completeprofile({super.key});

  @override
  State<completeprofile> createState() => _completeprofileState();
}

class _completeprofileState extends State<completeprofile> {
  final name = TextEditingController();
  final phonenumber = TextEditingController();
  XFile? _image;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
      });
    }
  }

  Future<void> _uploadProfilePic() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image first.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get the logged-in user's email (this will be the document ID in Firestore)
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }
      String userEmail = user.email!;
      if (name.text.trim().isNotEmpty &&
          phonenumber.text.trim().isNotEmpty &&
          _image.toString().isNotEmpty) {
        // Upload the image to Firebase Storage
        final file = File(_image!.path);
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_pics/${userEmail}.jpg');

        UploadTask uploadTask = storageRef.putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        if (phonenumber.text.length == 10) {
          // Save the image URL in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userEmail)
              .update({
            'profile_pic': downloadUrl,
            'name': name.text.trim(),
            'Phonenumber': phonenumber.text.trim()
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile picture uploaded successfully!')),
          );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MainScreen()),
            (Route<dynamic> route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            'Check your Phonenumber again!!',
            style: TextStyle(color: Colors.red),
          )));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fill the lines')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(
              bottom: height / 60, right: width / 30, left: width / 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: height / 10,
                      width: width / 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 1,
                          color: Colors.black,
                        ),
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
                    SizedBox(width: width / 20),
                  ],
                ),
                SizedBox(height: height / 60),
                Center(
                  child: Text(
                    "Complete your profile",
                    style: TextStyle(
                        color: const Color(0xff26150F),
                        fontFamily: "defaultfontsbold",
                        fontWeight: FontWeight.w500,
                        fontSize: 24),
                  ),
                ),
                SizedBox(height: height / 100),
                Center(
                  child: Text(
                    "Only you can see your personal data",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: height / 20),
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () => _pickImage(),
                          child: Container(
                            height: height / 6,
                            width: width / 3,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xffEDEDED),
                            ),
                            child: _image == null
                                ? Icon(
                                    Icons.person,
                                    color: const Color(0xff565656),
                                    size: height / 15,
                                  )
                                : Container(
                                    height: height / 6,
                                    width: width / 3,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: FileImage(File(_image!.path)),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        Positioned(
                          top: height / 8,
                          left: width / 4,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xff7D7676),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(
                                Icons.edit_sharp,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                size: height / 50,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: height / 20),
                TextField(
                  controller: name,
                  style: Theme.of(context).textTheme.headlineSmall,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff8F9DA6)),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff8F9DA6)),
                    ),
                    hintText: "Name",
                    contentPadding:
                        EdgeInsets.only(left: width / 50, top: height / 90),
                  ),
                ),
                SizedBox(height: height / 47),
                TextField(
                  controller: phonenumber,
                  maxLength: 10,
                  buildCounter: (BuildContext context,
                      {int? currentLength, bool? isFocused, int? maxLength}) {
                    return null; // Hides the counter
                  },
                  keyboardType: TextInputType.number,
                  style: Theme.of(context).textTheme.headlineSmall,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff8F9DA6)),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff8F9DA6)),
                    ),
                    hintText: "Phone Number",
                    contentPadding:
                        EdgeInsets.only(left: width / 50, top: height / 90),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: height / 10,
                      bottom: height / 30,
                      left: width / 22,
                      right: width / 22),
                  child: GestureDetector(
                    onTap: () async {
                      await _uploadProfilePic();
                    },
                    child: Container(
                      height: height / 15,
                      width: width,
                      decoration: BoxDecoration(
                        color: Color(0xff7905F5),
                        borderRadius: BorderRadius.circular(height / 10),
                      ),
                      child: Center(
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                "Complete Profile",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
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
