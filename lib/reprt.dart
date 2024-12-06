import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/Usermanegement/manualadding.dart';
import 'package:datingapp/filterrexultpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class reprt extends StatefulWidget {
  String reprtuser;
  reprt({
    required this.reprtuser,
    
    super.key});

  @override
  State<reprt> createState() => _reprtState();
}

class _reprtState extends State<reprt> {
      final prblem = TextEditingController();
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
    prblem.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final curentuser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
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
                    left: width / 15, right: width / 15, top: height / 20),
                child: SingleChildScrollView(
                  controller: _scrollController,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Why are you reporting this account?",
                        style: TextStyle(
                          color: const Color(0xff26150F),
                          fontFamily: "defaultfontsbold",
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                        softWrap: true,
                        overflow: TextOverflow
                            .visible, // You can also use TextOverflow.ellipsis if you want to truncate
                      ),
                      SizedBox(
                        height: height / 90,
                      ),
                      Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut diam orci, rutrum id arcu in, cursus commodo ex. Nunc massa felis, vestibulum placerat molestie suscipit, aliquam id felis.",
                        style: TextStyle(
                            color: const Color(0xff565656),
                            fontFamily: "defaultfonts",
                            fontWeight: FontWeight.w100,
                            fontSize: 16),
                      ),
                      SizedBox(
                        height: height / 20,
                      ),

                      Text(
                        'Problem',
                        style: TextStyle(
                            color: const Color(0xff4D4D4D),
                            fontFamily: "defaultfontsbold",
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      // ),

                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.transparent),
                        height: height / 6,
                        child: TextField(
                          focusNode: _problemFocusNode,

                          controller: prblem,
                          keyboardType: TextInputType.text,
                          maxLines: 10,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                left: width / 50, top: height / 90),
                            hintText: 'Enter Problem',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Color(0xff8F9DA6)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Color(0xff8F9DA6)),
                            ),
                          ),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(
                          top: height / 15,
                          bottom: height / 30,
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            await ReportAccount(userdataperson['email']);
                          },
                          child: Container(
                            height: height / 15,
                            width: width,
                            decoration: BoxDecoration(
                              color: Color(0xff7905F5),
                              borderRadius: BorderRadius.circular(height / 10),
                            ),
                            child: Center(
                              child: Text(
                                "Report Account",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height/5,)
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

  Future<void> ReportAccount(String useremail) async {
    try {
      FirebaseFirestore.instance
    .collection("Report Account")
    .doc(useremail)        .set({
      'Report': FieldValue.arrayUnion([
        {
          "reportEmail": widget.reprtuser,
          "reportProblem": prblem.text.trim(),
          'timestamp':
              DateTime.now().toUtc().toIso8601String(), // Use current UTC time
        }
      ]),
    }, SetOptions(merge: true));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
    "${widget.reprtuser} Reported",
    style: TextStyle(color: Colors.white),
    ),
    ));
    Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
    "${e.message}",
    style: TextStyle(color: Colors.red),
    ),
    ));
    }
//
  }
}
