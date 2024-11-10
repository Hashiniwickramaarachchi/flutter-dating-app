import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/Usermanegement/interespage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:numberpicker/numberpicker.dart';

class gender extends StatefulWidget {
  const gender({super.key});

  @override
  State<gender> createState() => _genderState();
}

class _genderState extends State<gender> {
  String _selectedIconIndex = "Not Selected";
  var year = 0;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final curentuser = FirebaseAuth.instance.currentUser!;
   return Scaffold(
                             appBar: AppBar(
       toolbarHeight:height/400,
       foregroundColor: const Color.fromARGB(255, 255, 255, 255),
       automaticallyImplyLeading: false,
     backgroundColor: const Color.fromARGB(255, 255, 255, 255),
     surfaceTintColor:const Color.fromARGB(255, 255, 255, 255),
     ),
     body: Container(
       color: Color.fromARGB(255, 255, 255, 255),
       height: height,
       width: width,
       child: Padding(
         padding: EdgeInsets.only(
             bottom: height / 60,
             right: width / 40,
             left: width / 40),
         child: SingleChildScrollView(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Padding(
                 padding:
                     EdgeInsets.only(left: width / 6, right: width / 6),
                 child:
                  Row(
                   children: [
                     Expanded(
                       child: LinearProgressIndicator(
                         value: 0.5, // Shows progress from 0.0 to 1.0
                         minHeight: 10.0, // Adjust height of progress bar
                         
                         color: const Color.fromARGB(255, 121, 5, 245),
                         borderRadius: BorderRadius.circular(10),
                       ),
                     ),
                     SizedBox(
                       width: width / 40,
                     ),
                     Text(
                       "2/4",
                       style: TextStyle(
                           color: Colors.black, fontSize: 14),
                     )
                   ],
                 ),
               ),
               SizedBox(
                 height: height / 15,
               ),
               Center(
                   child: Text(
                 "Tell Us About Yourself!",
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
                 "To give you better experience we need to know about you",
                 style: TextStyle(
                     color: const Color(0xff7D7676),
                     fontWeight: FontWeight.bold,
                     fontFamily: "defaultfontsbold",
                     fontSize: 16),
                 textAlign: TextAlign.center,
               )),
               SizedBox(
                 height: height / 20,
               ),
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Padding(
                     padding: EdgeInsets.only(
                         left: width / 22, bottom: height / 25),
                     child: Text(
                       "Your gender?",
                       style: TextStyle(
                           color: const Color(0xff464646),
                           fontFamily: "defaultfonts",
                           fontWeight: FontWeight.w900,
                           fontSize: 18),
                     ),
                   ),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       Column(children: [
                         buildSelectableIcon("Male", 'images/men.png'),
                         Center(
                           child: Text(
                             "Male",
                             style: TextStyle(
                                 color: const Color(0xff000000),
                                 fontFamily: "defaultfonts",
                                 fontSize: 15),
                             textAlign: TextAlign.center,
                           ),
                         )
                       ]),
                       Column(children: [
                         buildSelectableIcon("Female", 'images/female.png'),
                         Center(
                           child: Text(
                             "Female",
                             style: TextStyle(
                                 color: const Color(0xff000000),
                                 fontFamily: "defaultfonts",
                                 fontSize: 15),
                             textAlign: TextAlign.center,
                           ),
                         )
                       ]),
                       Column(children: [
                         buildSelectableIcon("Other", 'images/other.png'),
                         Center(
                           child: Text(
                             "Other",
                             style: TextStyle(
                                 color: const Color(0xff000000),
                                 fontFamily: "defaultfonts",
                                 fontSize: 15),
                             textAlign: TextAlign.center,
                           ),
                         )
                       ]),
                     ],
                   )
                 ],
               ),
               Padding(
                 padding: EdgeInsets.only(
                     left: width / 22,
                     bottom: height / 150,
                     top: height / 15),
                 child: Text(
                   "How old are you?",
                   style: TextStyle(
                       color: const Color(0xff464646),
                       fontFamily: "defaultfonts",
                       fontWeight: FontWeight.w900,
                       fontSize: 18),
                 ),
               ),
               Center(
                 child: NumberPicker(
                   minValue: 0,
                   maxValue: 100,
                   value: year,
                   zeroPad: false,
                   infiniteLoop: true,
                   itemWidth: 60,
                   itemHeight: 60,
                   onChanged: (value) {
                     setState(() {
                       year = value;
                     });
                   },
                   textStyle: TextStyle(
                       fontSize: 16,
                       color: Color.fromARGB(129, 86, 86, 86)),
                   selectedTextStyle: TextStyle(
                       fontSize: 32,
                       fontFamily: "defaultfonts",
                       color: Color(0xff464646),
                       fontWeight: FontWeight.w900),
                   decoration: BoxDecoration(
                       border: Border(
                           top: BorderSide(
                               color: const Color.fromARGB(255, 86, 86, 86)),
                           bottom: BorderSide(
                               color:
                                   const Color.fromARGB(255, 86, 86, 86)))),
                 ),
               ),
               Padding(
                 padding: EdgeInsets.only(
                     top: height / 55,
                     bottom: height / 30,
                     left: width / 22,
                     right: width / 22),
                 child: GestureDetector(
                   onTap: () async {
                     print(_selectedIconIndex);
                     print(year);
         
                     try {
                       // Update Firestore only if there are fields to update
                       if (year != 0 &&
                           _selectedIconIndex != "Not Selected") {
                         await FirebaseFirestore.instance
                             .collection('users')
                             .doc(curentuser.email!)
                             .update({
                           "Gender": _selectedIconIndex,
                           "Age": year
                         });
         
                         // Show success message
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                               content:
                                   Text('Profile updated successfully!')),
                         );
                         Navigator.of(context).push(MaterialPageRoute(
                           builder: (context) {
                             return Interest();
                           },
                         ));
                       } else {
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                               content: Text('Select the Gender or Age')),
                         );
                       }
         
                       // Handle password change if necessary
                     } catch (e) {
                       print('Error updating profile: $e');
                       ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(
                             content: Text('Failed to update profile.')),
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
                       child: Text(
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
       ),
     ),
   );
  }

  Widget buildSelectableIcon(String gender, String imagePath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIconIndex = gender;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: _selectedIconIndex == gender
                ? Color.fromARGB(255, 121, 5, 245)
                : const Color(0xffD9D9D9),
            width: 2,
          ),
        ),
        padding: EdgeInsets.all(15),
        child: Image.asset(
          imagePath,
          width: 45,
          height: 45,
        ),
      ),
    );
  }
}
