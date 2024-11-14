import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class A_ProfileUpdatePage extends StatefulWidget {
  @override
  _A_ProfileUpdatePageState createState() => _A_ProfileUpdatePageState();
}

class _A_ProfileUpdatePageState extends State<A_ProfileUpdatePage> {
  String? selectedgender;
  XFile? _image;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool _isInitialized = false;

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

  Future<String?> _uploadImage(File imageFile) async {
    try {
      // Generate a unique file name for the image
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pics/${DateTime.now().toIso8601String()}');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get the image URL after upload
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _updateProfile(String userEmail) async {
    try {
      String? imageUrl;

      if (_image != null) {
        // Upload the image to Firebase Storage and get the download URL
        imageUrl = await _uploadImage(File(_image!.path));
      }
if (phoneController.text.length==10) {

      // Update Firestore with new data
      await FirebaseFirestore.instance
          .collection('Ambassdor')
          .doc(userEmail)
          .update({
        'name': nameController.text,
        'Phonenumber': phoneController.text,
        'email': emailController.text,
        'profile_pic': imageUrl ?? (await _fetchCurrentProfilePic(userEmail)),
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')));
}else{

   ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Check your Phonenumber again!!',style: TextStyle(color: Colors.red),)));

}
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
    }
  }
  Future<String?> _fetchCurrentProfilePic(String userEmail) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Ambassdor')
        .doc(userEmail)
        .get();
    return snapshot['profile_pic'];
  }
  void _initializeFields(Map<String, dynamic> userData) {
    if (!_isInitialized) {
      nameController.text = userData['name'] ?? '';
      phoneController.text = userData['Phonenumber'] ?? '';
      emailController.text = userData['email'] ?? '';
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;

    final curentuser = FirebaseAuth.instance.currentUser!;
    return Container(
      width: deviceWidth,
      height: deviceHeight,
      color: const Color.fromARGB(255, 255, 255, 255),
      child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Ambassdor")
              .doc(curentuser.email!)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userdataperson =
                  snapshot.data!.data() as Map<String, dynamic>;                _initializeFields(userdataperson);
    
              _initializeFields(userdataperson);
    
    
              return Scaffold(
                      appBar: AppBar(
        toolbarHeight: deviceHeight / 400,
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
      ),
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                body: Padding(
                  padding: EdgeInsets.only(
                      bottom: deviceHeight / 60,
                      right: deviceWidth / 20,
                      left: deviceWidth / 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: deviceHeight / 10,
                              width: deviceWidth / 10,
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
                                  color:
                                      const Color.fromARGB(255, 121, 5, 245),
                                ),
                              ),
                            ),
                            SizedBox(width: deviceWidth / 20),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "Edit Your Profile",
                                  style: TextStyle(
                                      color: const Color(0xff26150F),
                                      fontFamily: "defaultfontsbold",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                            SizedBox(width: deviceWidth / 15)
                          ],
                        ),
    
                        // Profile picture section
                        Center(
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: () => _pickImage(),
                                child: Container(
                                  height: deviceHeight / 6,
                                  width: deviceWidth / 3,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(0xff7905F5),
                                    ),
                                    shape: BoxShape.circle,
                                                   color: (userdataperson['profile_pic'] ??
                         '') ==
                     ''
                 ? const Color.fromARGB(
                     255, 221, 219, 219)
                 : Colors.transparent,
             image: _image != null
                 ? DecorationImage(
                     image:
                         FileImage(File(_image!.path)),
                     fit: BoxFit.cover,
                   )
                 : (userdataperson['profile_pic'] ??
                             '') !=
                         ''
                     ? DecorationImage(
                         image: NetworkImage(
                             userdataperson[
                                     'profile_pic'] ??
                                 ''),
                         fit: BoxFit.cover,
                       )
                     : null,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: deviceWidth / 4,
                                top: deviceHeight / 8,
                                child: Container(
                                  height: deviceHeight / 20,
                                  width: deviceWidth / 20,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              AssetImage("assetss/red.png"))),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
    
                        Text(
                          'Name',
                          style: TextStyle(
                              color: const Color(0xff4D4D4D),
                              fontFamily: "defaultfontsbold",
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        customTextField('Name', nameController,
                            false, deviceHeight, deviceWidth),
    
                        Text(
                          'Phone Number',
                          style: TextStyle(
                              color: const Color(0xff4D4D4D),
                              fontFamily: "defaultfontsbold",
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        customTextField2(
                            'Phone number',
                            phoneController,
                            false,
                            deviceHeight,
                            deviceWidth),
    
                        Text(
                          'Email',
                          style: TextStyle(
                              color: const Color(0xff4D4D4D),
                              fontFamily: "defaultfontsbold",
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        customTextField('Email', emailController,
                            true, deviceHeight, deviceWidth),
    
                        // Update Button
                        Padding(
                          padding: EdgeInsets.only(
                              top: deviceHeight / 50,
                              bottom: deviceHeight / 30,
                              ),
                          child: GestureDetector(
                            onTap: () => _updateProfile(curentuser.email!),
                            child: Container(
                              height: deviceHeight / 15,
                              width: deviceWidth,
                              decoration: BoxDecoration(
                                color: Color(0xff7905F5),
                                borderRadius:
                                    BorderRadius.circular(deviceHeight / 10),
                              ),
                              child: Center(
                                child: Text(
                                  "Update",
                                  style:
                                      Theme.of(context).textTheme.bodySmall,
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
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  // Custom Text Field Widget
  Widget customTextField(String labelText, TextEditingController controller,
      bool check, double height, double width) {
    return Padding(
      padding: EdgeInsets.only(top: height / 60, bottom: height / 40),
      child: TextField(
        readOnly: check,
        controller: controller,
        style: TextStyle(color: Colors.black),
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
    );
  }
     Widget customTextField2(String labelText, TextEditingController controller,
     bool check, double height, double width) {
   return Padding(
     padding: EdgeInsets.only(top: height / 60, bottom: height / 40),
     child: TextField(
                             maxLength: 10,
buildCounter: (BuildContext context,
 {int? currentLength, bool? isFocused, int? maxLength}) {
   return null; // Hides the counter
 },
       readOnly: check,
       controller: controller,
       keyboardType: TextInputType.number,
       style: TextStyle(color: Colors.black),
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
   );
 }
}

