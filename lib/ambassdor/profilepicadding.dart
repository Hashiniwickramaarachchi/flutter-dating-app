import 'dart:io';

import 'package:datingapp/ambassdor/approve.dart';
import 'package:datingapp/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class profilepicadding extends StatefulWidget {
  String email;
  profilepicadding({required this.email, super.key});

  @override
  State<profilepicadding> createState() => _profilepicaddingState();
}

class _profilepicaddingState extends State<profilepicadding> {
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
      if (widget.email.isEmpty) {
        throw Exception("User not logged in");
      }
      String userEmail = widget.email;
      if (_image.toString().isNotEmpty) {
        // Upload the image to Firebase Storage
        final file = File(_image!.path);
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_pics/${userEmail}.jpg');

        UploadTask uploadTask = storageRef.putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Save the image URL in Firestore
        await FirebaseFirestore.instance
            .collection('test')
            .doc(userEmail)
            .update({
          'profile_pic': downloadUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile picture uploaded successfully!')),
        );
        final userDoc = await FirebaseFirestore.instance
            .collection('test')
            .doc(widget.email)
            .get();
        if (userDoc.exists) {
          final userData = userDoc.data()!;
          setState(() {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return approve(
                  address: userData['Address'],
                  age: userData['Age'],
                  height: userData['height'],
                  image: userData['profile_pic'],
                  name: userData['name'],
                  ID: widget.email,
                  iconss: userData['Icon'],
                  labels: userData['Interest'],
                  imagecollection: userData['images'],
                  useremail: widget.email,
                  education: userData['education'],
                );
              },
            ));
          });
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
               toolbarHeight:height/400,
               foregroundColor: const Color.fromARGB(255, 255, 255, 255),
               automaticallyImplyLeading: false,
             backgroundColor: const Color.fromARGB(255, 255, 255, 255),
             surfaceTintColor:const Color.fromARGB(255, 255, 255, 255),
             ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(
              bottom: height / 60,
              right: width / 20,
              left: width / 20),
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
                  SizedBox(
                    width: width / 10,
                  ),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: 1.0, // Shows progress from 0.0 to 1.0
                      minHeight: 10.0, // Adjust height of progress bar
                      color: const Color.fromARGB(255, 121, 5, 245),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(
                    width: width / 20,
                  ),
                  Text(
                    "4/4",
                    style: TextStyle(
                        color: Colors.black, fontSize: height / 50),
                  ),
                  SizedBox(width: width/10,)
                ],
              ),
              SizedBox(height: height / 60),
              Center(
                child: Text(
                  "Complete Partner profile",
                  style: TextStyle(
                      color: const Color(0xff26150F),
                      fontFamily: "defaultfontsbold",
                      fontWeight: FontWeight.w500,
                      fontSize: 24),
                ),
              ),
              SizedBox(height: height / 100),
              // Center(
              // child: Text(
              // "Only you can see your personal data",
              // style: TextStyle(
              // color: Colors.grey,
              // fontWeight: FontWeight.bold,
              // fontSize: height / 50,
              // ),
              // textAlign: TextAlign.center,
              // ),
              // ),
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
                              color:
                                  const Color.fromARGB(255, 255, 255, 255),
                              size: height / 50,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height / 80),
              // TextField(
              // controller: name,
              // style: Theme.of(context).textTheme.headlineSmall,
              // decoration: InputDecoration(
              // focusedBorder: UnderlineInputBorder(
              // borderSide: BorderSide(color: Color(0xff8F9DA6)),
              // ),
              // enabledBorder: UnderlineInputBorder(
              // borderSide: BorderSide(color: Color(0xff8F9DA6)),
              // ),
              // hintText: "Name",
              // contentPadding:
              // EdgeInsets.only(left: width / 50, top: height / 90),
              // ),
              // ),
              // TextField(
              // controller: phonenumber,
              // style: Theme.of(context).textTheme.headlineSmall,
              // decoration: InputDecoration(
              // focusedBorder: UnderlineInputBorder(
              // borderSide: BorderSide(color: Color(0xff8F9DA6)),
              // ),
              // enabledBorder: UnderlineInputBorder(
              // borderSide: BorderSide(color: Color(0xff8F9DA6)),
              // ),
              // hintText: "Phone Number",
              // contentPadding:
              // EdgeInsets.only(left: width / 50, top: height / 90),
              // ),
              // ),
              Padding(
                padding: EdgeInsets.only(
                    top: height / 3,
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
    );
  }
}
