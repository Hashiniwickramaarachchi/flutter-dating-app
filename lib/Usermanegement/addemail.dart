import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/otp.dart';
import 'package:datingapp/Usermanegement/verifycode.dart';
import 'package:flutter/material.dart';
import 'package:email_otp/email_otp.dart';

class Addemail extends StatefulWidget {
  const Addemail({super.key});

  @override
  State<Addemail> createState() => _AddemailState();
}

class _AddemailState extends State<Addemail> {
  final otpemail = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> checkEmailExists(String email) async {
    try {
      final QuerySnapshot result = await _firestore
          .collection('users') // Replace with your Firestore collection name
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      final List<DocumentSnapshot> documents = result.docs;
      return documents.isNotEmpty;
    } catch (e) {
      print(e);
      return false;
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
   ),
      body: Container(
        height: height,
        width: width,
        color: Color.fromARGB(255, 255, 255, 255),
        child: Padding(
          padding: EdgeInsets.only(
              bottom: height / 60,
              left: width / 18,
              right: width / 18),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
        
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border:Border.all(color: Color(0xff26150F),)
          ),
          child: IconButton(onPressed:() {
            Navigator.of(context).pop();
          }, icon:Icon(Icons.arrow_back,color: Color(0xffBF1506),)),
        ),
        
        
        
        
                SizedBox(
                  height: height / 15,
                ),

                Center(
                    child: Text(
                  "Add your Email Address",
                  style: TextStyle(
                      color: const Color(0xff26150F),
                      fontFamily: "defaultfontsbold",
                      fontWeight: FontWeight.w500,
                      fontSize: 24),
                )),
                SizedBox(
                  height: height / 50,
                ),
                Center(
                  child: Text(
                    "Enter your email address related to this profile",
                    style: TextStyle(
                        color: const Color(0xff7D7676),
                        fontWeight: FontWeight.bold,
                        fontFamily: "defaultfontsbold",
                        fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(bottom: height / 47, top: height / 10),
                  child: TextField(
                    controller: otpemail,
                    keyboardType: TextInputType.emailAddress,
                    style: Theme.of(context).textTheme.headlineSmall,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Email',
                      contentPadding:
                          EdgeInsets.only(left: width / 50, top: height / 90),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: height / 35, bottom: height / 30),
                  child: GestureDetector(
                    onTap: () async {
                      // Check if the email exists in Firestore
                      bool emailExists =
                          await checkEmailExists(otpemail.text.trim());
    
                      if (emailExists) {
                        if (await EmailOTP.sendOTP(email: otpemail.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("OTP has been sent"),
                            ),
                          );
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Verifycode(otpemail: otpemail.text)));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Failed to send OTP"),
                            ),
                          );
                        }
                      } else {
                        // Send OTP if email doesn't exist
    
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Email not registered"),
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: height / 15,
                      width: width,
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Next",
                    style: Theme.of(context).textTheme.bodySmall,
    
                      
                      
                      
                      
                          ),
                          SizedBox(width: width/30,),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          )
                        ],
                      )),
                      decoration: BoxDecoration(
                          color: Color(0xff7905F5),
                          borderRadius: BorderRadius.circular(height / 10)),
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
