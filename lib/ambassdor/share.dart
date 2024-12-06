import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/Usermanegement/manualadding.dart';
import 'package:datingapp/filterrexultpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class sharepage extends StatefulWidget {
  String blockemail;
  String blockpic;
  String blockname;
  sharepage(
      {required this.blockemail,
      required this.blockname,
      required this.blockpic,
      super.key});

  @override
  State<sharepage> createState() => _sharepageState();
}

class _sharepageState extends State<sharepage> {
TextEditingController email=TextEditingController();
       final FocusNode _problemFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
   @override
  void initState() {
    super.initState();
    _problemFocusNode.addListener(() {
      if (_problemFocusNode.hasFocus) {
        Future.delayed(Duration(milliseconds: 100), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _problemFocusNode.dispose();
    _scrollController.dispose();
    email.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final curentuser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Ambassdor")
            .doc(curentuser.email!)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userdataperson =
                snapshot.data!.data() as Map<String, dynamic>;
            return Container(
              width: width,
              height: height / 1.3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    left: width / 15, right: width / 15, top: height / 50),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: height / 30),
                          child: Container(
                            height: height / 5,
                            width: width / 4,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromARGB(255, 121, 5, 245)),
                              shape: BoxShape.circle,
                              color: const Color.fromARGB(255, 206, 206, 206),
                            ),
                            child: Container(
                              height: height / 6,
                              width: width / 3,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(widget.blockpic),
                                    fit: BoxFit.cover),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height / 60,
                      ),
                      Text(
                        "Want to add this user ${widget.blockname} ?",
                  
                        style: TextStyle(
                          color: const Color(0xff26150F),
                          fontFamily: "defaultfontsbold",
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                        ),
                        softWrap: true,
                        overflow: TextOverflow
                            .visible, // You can also use TextOverflow.ellipsis if you want to truncate
                      ),
                  SizedBox(height: height/30,),
                                        Text(
                        'Enter the User\'s email to add this partner',
                        style: TextStyle(
                            color: const Color(0xff4D4D4D),
                            fontFamily: "defaultfontsbold",
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      SizedBox(height: 10),
                    
                    
                    
                    
                    
                    
                    
                    
              
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        focusNode: _problemFocusNode,
                        controller: email,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: width / 50,
                              top: height / 90),
                          // hintText: 'Enter Education',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Color(0xff8F9DA6)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Color(0xff8F9DA6)),
                          ),
                        ),
                        style:
                            Theme.of(context).textTheme.headlineSmall,
                      ),

                                  Padding(
              padding: EdgeInsets.only(
                  top: height / 15,
                  bottom: height / 30,
                  ),
              child: GestureDetector(
             onTap: () async {
  String enteredEmail = email.text.trim();

  if (enteredEmail.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please enter a valid email.")),
    );
    return;
  }

  try {
    // Reference to the Firestore collection
    final usersCollection = FirebaseFirestore.instance.collection('users');

    // Check if the document with the entered email already exists
    final docSnapshot = await usersCollection.doc(enteredEmail).get();

    if (docSnapshot.exists) {
      // Document exists: Update the array field
      await usersCollection.doc(enteredEmail).update({
        'partners': FieldValue.arrayUnion([widget.blockemail])
      });
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User successfully added to partners list.")),
      );
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("This email address didnt have a user")),
      );
    }

    // Clear the text field after adding
    email.clear();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: ${e.toString()}")),
    );
  }
},

             
                child: Container(
                  height: height / 15,
                  width: width,
                  decoration: BoxDecoration(
                    color: Color(0xff7905F5),
                    borderRadius: BorderRadius.circular(height / 10),
                  ),
                  child: Center(
                    child:
                        Text(
                            "Add",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                  ),
                ),
              ),
            ),
                                  SizedBox(height: height/3,)

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
            return CircularProgressIndicator();
          }
        });
  }



   }

