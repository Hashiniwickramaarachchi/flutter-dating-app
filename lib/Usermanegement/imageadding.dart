import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/Usermanegement/locationadding.dart';
import 'package:datingapp/Usermanegement/manualadding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class imageadding extends StatefulWidget {
  const imageadding({super.key});

  @override
  State<imageadding> createState() => _imageaddingState();
}

class _imageaddingState extends State<imageadding> {
  bool _isLoading = false;

  List<File?> images = List<File?>.filled(6, null);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _pickImage(int index) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        images[index] = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImagesToFirebase() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      return; // Handle the case if the user is not logged in.
    }
    setState(() {
      _isLoading = true;
    });
    List<String> downloadUrls = [];

    for (int i = 0; i < images.length; i++) {
      if (images[i] != null) {
        String fileName = 'users/${user.email}/image$i.jpg';
        try {
          // Upload to Firebase Storage
          Reference storageReference =
              FirebaseStorage.instance.ref().child(fileName);
          UploadTask uploadTask = storageReference.putFile(images[i]!);
          TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});

          // Get download URL
          String downloadUrl = await taskSnapshot.ref.getDownloadURL();
          downloadUrls.add(downloadUrl);
        } catch (e) {
          print("Error uploading image $i: $e");
        }
      }
    }

    // Save URLs to Firestore under the user's document (user email is doc ID)
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .update({'images': downloadUrls}).then((_) {
      print("Images uploaded and URLs stored in Firestore successfully.");
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return loactionadding();
        },
      ));
    }).catchError((error) {
      print("Failed to store image URLs: $error");
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
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
      body: Container(
          height: height,
          width: width,
          color: Color.fromARGB(255, 255, 255, 255),
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
                      SizedBox(
                        width: width / 10,
                      )
                    ],
                  ),
                  SizedBox(
                    height: height / 60,
                  ),
                  Center(
                      child: Text(
                    "Upload your photos",
                    style: TextStyle(
                        color: const Color(0xff26150F),
                        fontFamily: "defaultfontsbold",
                        fontWeight: FontWeight.w500,
                        fontSize: 24),
                  )),
                  SizedBox(
                    height: height / 100,
                  ),
                  Center(
                      child: Text(
                    "Enhance your daily match potential by adding your photos",
                    style: TextStyle(
                        color: const Color(0xff7D7676),
                        fontWeight: FontWeight.bold,
                        fontFamily: "defaultfontsbold",
                        fontSize: 16),
                    textAlign: TextAlign.center,
                  )),
                  SizedBox(
                    height: height / 30,
                  ),
                  Column(
                    children: [
                      Container(
                        width: width,
                        height: height / 3,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () => _pickImage(0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xffD9D9D9),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: images[0] == null
                                      ? Center(
                                          child: CircleAvatar(
                                            backgroundColor: Colors.grey[700],
                                            radius: 20,
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      : Image.file(
                                          images[0]!,
                                          fit: BoxFit.contain,
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width / 20,
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: GestureDetector(
                                      onTap: () => _pickImage(1),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xffD9D9D9),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: images[1] == null
                                            ? Center(
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.grey[700],
                                                  radius: 20,
                                                  child: Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
                                            : Image.file(
                                                images[1]!,
                                                fit: BoxFit.contain,
                                              ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height / 40,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: GestureDetector(
                                      onTap: () => _pickImage(2),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xffD9D9D9),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: images[2] == null
                                            ? Center(
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.grey[700],
                                                  radius: 20,
                                                  child: Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
                                            : Image.file(
                                                images[2]!,
                                                fit: BoxFit.contain,
                                              ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 40,
                      ),
                      Container(
                        height: height / 7,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: GestureDetector(
                                      onTap: () => _pickImage(3),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Color(0xffD9D9D9),
                                        ),
                                        child: images[3] == null
                                            ? Center(
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.grey[700],
                                                  radius: 20,
                                                  child: Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
                                            : Image.file(
                                                images[3]!,
                                                fit: BoxFit.contain,
                                              ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width / 20,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: GestureDetector(
                                      onTap: () => _pickImage(4),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xffD9D9D9),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: images[4] == null
                                            ? Center(
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.grey[700],
                                                  radius: 20,
                                                  child: Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
                                            : Image.file(
                                                images[4]!,
                                                fit: BoxFit.contain,
                                              ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: width / 20,
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () => _pickImage(5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xffD9D9D9),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: images[5] == null
                                      ? Center(
                                          child: CircleAvatar(
                                            backgroundColor: Colors.grey[700],
                                            radius: 20,
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      : Image.file(
                                          images[5]!,
                                          fit: BoxFit.contain,
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: height / 15,
                        bottom: height / 30,
                        left: width / 22,
                        right: width / 22),
                    child: GestureDetector(
                      onTap: () async {
                        _uploadImagesToFirebase();

                        //
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
                                  "Next",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
