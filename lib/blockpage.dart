import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/Usermanegement/manualadding.dart';
import 'package:datingapp/filterrexultpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class blockpage extends StatefulWidget {
  String blockemail;
  String blockpic;
  String blockname;
  blockpage(
      {required this.blockemail,
      required this.blockname,
      required this.blockpic,
      super.key});

  @override
  State<blockpage> createState() => _blockpageState();
}

class _blockpageState extends State<blockpage> {
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
              height: height / 1.5,
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
                        "Want block ${widget.blockname} ?",
                  
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
                           Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                              Icon(Icons.block,color: const Color(0xff565656),),
                              SizedBox(width: width/20,),
                               Expanded(
                                 child: Text(
                                        "They won’t able to message or find your account.",
                                        style: TextStyle(
                                            color: const Color(0xff565656),
                                            fontFamily: "defaultfontsbold",
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                               ),
                             ],
                           ),
                                    SizedBox(height: height/20,),

                               Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                         Icon(Icons.settings,color:const Color(0xff565656) ,),
                         SizedBox(width: width/20,),
                          Expanded(
                            child: Text(
                   "You can unblock them at any time.",
                   style: TextStyle(
                       color: const Color(0xff565656),
                       fontFamily: "defaultfontsbold",
                       fontWeight: FontWeight.w500,
                       fontSize: 16),
                                 ),
                          ),
                        ],
                      ),
                                  Padding(
              padding: EdgeInsets.only(
                  top: height / 15,
                  bottom: height / 30,
                  ),
              child: GestureDetector(
                onTap: () async {
                  await _Blockuser(userdataperson['email']);
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
                            "Block",
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
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
   Future<void> _Blockuser(String useremail) async {

      try {
        FirebaseFirestore.instance
            .collection("Blocked USers")
            .doc(widget.blockemail)
            .set({
              "This Id blocked Users":[useremail]
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "${widget.blockemail} Blaocked",
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


   }
}
