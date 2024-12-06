import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/ambassdor/A_Mainscree.dart';
import 'package:datingapp/ambassdor/ambassdorshow.dart';
import 'package:datingapp/userchatpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class approve extends StatefulWidget {
  String name;
  String education;
  String image;

  String address;

  int age;
  String ID;
  String height;
  List<dynamic> iconss;
  List<dynamic> labels;
  List<dynamic> imagecollection;

  String useremail;

  approve(
      {required this.address,
      required this.education,
      required this.age,
      required this.height,
      required this.image,
      required this.name,
      required this.ID,
      required this.iconss,
      required this.labels,
      required this.imagecollection,
      required this.useremail,
      super.key});

  @override
  State<approve> createState() => _approveState();
}

class _approveState extends State<approve> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final curentuser = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        toolbarHeight: height / 400,
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Column(
        children: [
          Container(
            child: Padding(
              padding: EdgeInsets.only(left: width / 20, right: width / 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                  ]),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: width / 10, right: width / 10, top: height / 60),
            child: Container(
              height: height / 2.5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                      image: NetworkImage(widget.image), fit: BoxFit.cover)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: height / 8,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                      color: Colors.white
                          .withOpacity(0.2), // Optional for color overlay
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                        child: Container(
                          child: Container(
                            color: const Color.fromARGB(255, 124, 124, 124)
                                .withOpacity(0.2),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  widget.name,
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      fontFamily: "defaultfontsbold",
                                      fontWeight: FontWeight.w900,
                                      fontSize: 24),
                                ),
                                Text(
                                  widget.address,
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      fontFamily: "defaultfonts",
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: width / 20, right: width / 20, top: height / 40),
            child: Container(
              height: height / 3,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [],
                        ),
                        Row(
                          children: [
                            // Container(
                            // decoration: BoxDecoration(
                            // shape: BoxShape.circle,
                            // color: Color(0xff7905F5),
                            // ),
                            // child: IconButton(
                            // onPressed: () async {
                            // setState(() {
                            // widget.fav =
                            // !widget.fav; // Toggle the state
                            // });
                            // if (widget.fav) {
                            // FirebaseFirestore.instance
                            // .collection('users')
                            // .doc(widget.ID)
                            // .get()
                            // .then((DocumentSnapshot
                            // documentSnapshot) async {
                            // if (documentSnapshot.exists) {
                            // Map<String, dynamic> data =
                            // documentSnapshot.data()
                            // as Map<String, dynamic>;
                            // try {
                            // DocumentReference favDocRef =
                            // await FirebaseFirestore
                            // .instance
                            // .collection('Favourite')
                            // .doc(widget
                            // .useremail); // Add the data to the main document in Favourite
                            // print(
                            // "Favourite document created with ID: ${favDocRef.id}");
                            // await favDocRef
                            // .collection(
                            // "fav1") // Subcollection name
                            // .doc(widget
                            // .ID) // Use the same ID as in the "Sell" collection
                            // .set(
                            // data); // Add the data from the "Sell" collection
                            // print(
                            // "Subcollection 'fav1' created with document ID: ${widget.ID}");
                            // FirebaseFirestore.instance
                            // .collection(
                            // 'Favourite') // Replace with your collection name
                            // .doc(widget.useremail)
                            // .collection("fav1")
                            // .doc(widget
                            // .ID) // Replace with the document ID you want to update
                            // .update({'fav1': true})
                            // .then((_) => print(
                            // "Favorite updated to true"))
                            // .catchError((error) => print(
                            // "Failed to update favorite: $error"));
                            // } catch (error) {
                            // print(
                            // "Error during creation of Favourite document or subcollection: $error");
                            // }
                            // } else {
                            // print(
                            // "Document does not exist in Sell collection");
                            // }
                            // }).catchError((error) {
                            // print(
                            // "Failed to retrieve document from Sell collection: $error");
                            // });
                            // } else {}
                            // },
                            // icon: Icon(
                            // widget.fav
                            // ? Icons.favorite_rounded
                            // : Icons.favorite_border_outlined,
                            // color: Colors.white,
                            // size: height / 30,
                            // )),
                            // ),
                            SizedBox(
                              width: width / 40,
                            ),
                            // GestureDetector(
                            // onTap: () {
                            // Navigator.of(context).push(MaterialPageRoute(builder:(context) {
                            // return ChatPage(chatPartnerEmail: widget.ID, chatPartnername: widget.name,
                            // chatPartnerimage: widget.image, onlinecheck: widget.onlinecheck, statecolour: widget.statecolour);
                            // },));
                            // },
                            // child: Container(
                            // decoration: BoxDecoration(
                            // shape: BoxShape.circle,
                            // color: Color(0xff7905F5),
                            // ),
                            // child:         Padding(
                            //  padding: const EdgeInsets.all(10.0),
                            //  child: ClipRRect(
                            //
                            // child: Image.asset("images/Vector.png",height: height/30,),
                            //  ),
                            //  )
                            //
                            //
                            //
                            //
                            //
                            //
                            //
                            //
                            //
                            // ),
                            // )
                          ],
                        ),
                      ],
                    ),
                    // Description

                    // Interests
                    Text(
                      'Interest',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontFamily: "defaultfontsbold",
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Center(
                      child: Wrap(
                          spacing: width / 90,
                          runSpacing: height / 70,
                          children: List<Widget>.generate(
                            widget.labels.length,
                            (int index) {
                              return _buildInterestChip(
                                  context,
                                  widget.labels[index],
                                  widget.iconss[index],
                                  height);
                            },
                          )),
                    ),
                    SizedBox(height: height * 0.03),
                    // Achen's Info
                    Text(
                      "${widget.name.toUpperCase()}'s Info",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontFamily: "defaultfontsbold",
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    _buildInfoRow(context, 'Age', widget.age.toString()),
                    _buildInfoRow(context, 'Height', '${widget.height}'),
                    _buildInfoRow(context, 'Languages', 'English'),
                    SizedBox(height: height / 90),
                    Text(
                      'Education',
                      style: TextStyle(
                          color: const Color(0xff565656),
                          fontFamily: "defaultfonts",
                          fontSize: 18),
                    ),
                    SizedBox(height: height * 0.01),
                    Text(
                      widget.education,
                      style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontFamily: "defaultfonts",
                          fontSize: height / 50),
                    ),

                    SizedBox(height: height * 0.03),
                    // Gallery
                    Text(
                      'Gallery',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontFamily: "defaultfontsbold",
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    SizedBox(height: height * 0.01),
                    GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.imagecollection.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: width * 0.02,
                        mainAxisSpacing: height * 0.02,
                        childAspectRatio: 1.0,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return FullScreenImageView(
                                    imagePath: widget.imagecollection[index]);
                              },
                            ));
                          },
                          child: Container(
                            height: height / 10,
                            width: width / 10,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        widget.imagecollection[index]),
                                    fit: BoxFit.cover)),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: height / 30,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(height / 10)),
                                    backgroundColor: Color(0xffF5ECFF),
                                  ),
                                  onPressed: () async {
                                    final firestore =
                                        FirebaseFirestore.instance;
                                    try {
                                      // Step 1: Get the document data from the 'test' collection
                                      DocumentSnapshot testDoc = await firestore
                                          .collection('test')
                                          .doc(widget.ID)
                                          .get();
                                      if (testDoc.exists) {
                                        await firestore
                                            .collection('test')
                                            .doc(widget.ID)
                                            .delete();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'User removed successfully!')));
                                        Position position =
                                            await Geolocator.getCurrentPosition(
                                                desiredAccuracy:
                                                    LocationAccuracy.high);
                                        double latitude = position.latitude;
                                        double longitude = position.longitude;
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  A_MainScreen()),
                                          (Route<dynamic> route) => false,
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Document does not exist in the 'test' collection.")));
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Error transferring document: $e")));
                                    }
                                  },
                                  child: Text(
                                    "Decline",
                                    style: TextStyle(
                                        color: Color(0xff7905F5),
                                        fontFamily: "defaultfonts",
                                        fontWeight: FontWeight.w500,
                                        fontSize: height / 45),
                                  ))),
                          SizedBox(
                            width: width / 15,
                          ),
                          Expanded(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff7905F5),
                                ),
                                onPressed: () async {
                                  final firestore = FirebaseFirestore.instance;

                                  try {
                                    // Step 1: Get the document data from the 'test' collection
                                    DocumentSnapshot testDoc = await firestore
                                        .collection('test')
                                        .doc(widget.ID)
                                        .get();

                                    if (testDoc.exists) {
                                      // Step 2: Add the document data to the 'user' collection
                                      await firestore
                                          .collection('Partner')
                                          .doc(widget.ID)
                                          .set(testDoc.data()
                                              as Map<String, dynamic>);
                                      print(curentuser.email!);

                                      // Step 3: Delete the document from the 'test' collection
                                      await firestore
                                          .collection('test')
                                          .doc(widget.ID)
                                          .delete();
                                      FirebaseFirestore.instance
                                          .collection("Ambassdor")
                                          .doc(curentuser.email!)
                                          .update({
                                        'addedusers':
                                            FieldValue.arrayUnion([widget.ID]),
                                      });
                                      Position position =
                                          await Geolocator.getCurrentPosition(
                                              desiredAccuracy:
                                                  LocationAccuracy.high);
                                      double latitude = position.latitude;
                                      double longitude = position.longitude;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text('partner Added')),
                                      );
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                A_MainScreen()),
                                        (Route<dynamic> route) => false,
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Document does not exist in the 'test' collection.")));
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Error transferring document: $e")));
                                  }
                                },
                                child: Text(
                                  "Add Post",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "defaultfonts",
                                      fontWeight: FontWeight.w500,
                                      fontSize: height / 45),
                                )),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      // Name and Location
    );
  }

  // Build Interest Chip
  Widget _buildInterestChip(
      BuildContext context, String label, int iconname, final height) {
    return Chip(
        side: BorderSide(color: Colors.transparent),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        avatar: Icon(
          IconData(iconname, fontFamily: 'MaterialIcons'),
          color: Color(0xff565656),
        ), // Ensure the correct font family
        label: Text(
          label,
          style: TextStyle(
              color: const Color(0xff565656),
              fontFamily: "defaultfontsbold",
              fontSize: 15),
        ),
        backgroundColor: Color(0xffD9D9D9));
  }

  // Build Info Row
  Widget _buildInfoRow(BuildContext context, String title, String info) {
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(top: height / 90),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                color: const Color(0xff565656),
                fontFamily: "defaultfonts",
                fontSize: 16),
          ),
          Text(
            info,
            style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontFamily: "defaultfonts",
                fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class FullScreenImageView extends StatelessWidget {
  final String imagePath;

  const FullScreenImageView({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Hero(
          tag: imagePath, // Use a Hero widget for smooth transition
          child: Image.network(imagePath, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
