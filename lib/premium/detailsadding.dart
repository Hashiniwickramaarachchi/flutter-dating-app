import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/Usermanegement/manualadding.dart';
import 'package:datingapp/ambassdor/filterresult.dart';
import 'package:datingapp/ambassdor/interestpage.dart';
import 'package:datingapp/ambassdor/matchingfilter.dart';
import 'package:datingapp/premium/paymentpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class detailsadding extends StatefulWidget {

int Amount;
String dbemail;
String version;

   detailsadding({
    required this.dbemail,
    required this.Amount,
    required this.version,
    super.key});

  @override
  State<detailsadding> createState() => _detailsaddingState();
}

class _detailsaddingState extends State<detailsadding> {

  final firstname = TextEditingController();
    final lastname = TextEditingController();
  final middlename = TextEditingController();


  final phonenumber = TextEditingController();
  final email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final currentUser = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                                                   appBar: AppBar(
               toolbarHeight:height/400,
               foregroundColor: const Color.fromARGB(255, 255, 255, 255),
               automaticallyImplyLeading: false,
             backgroundColor: const Color.fromARGB(255, 255, 255, 255),
             surfaceTintColor:const Color.fromARGB(255, 255, 255, 255),
             ),
      body: Container(
        height: height,
        width: width,
        color: Color.fromARGB(255, 255, 255, 255),
        padding: EdgeInsets.only(
          bottom: height / 60,
          right: width / 20,
          left: width / 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress bar and back button
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
                  Expanded(
                    child: Center(
                      child: Text(
                        "Add your details",
                        style: TextStyle(
                            color: const Color(0xff26150F),
                            fontFamily: "defaultfontsbold",
                            fontWeight: FontWeight.w500,
                            fontSize: 24),
                      ),
                    ),
                  ),
                  SizedBox(width: width / 15),
                ],
              ),
              SizedBox(height: height / 60),
    
              // detailsadding chip
              Padding(
                padding: EdgeInsets.only(
                  bottom: height / 47,
                ),
                child: TextField(
                  style: Theme.of(context).textTheme.headlineSmall,
                  controller: firstname,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'FirstName',
                    contentPadding:
                        EdgeInsets.only(left: width / 50, top: height / 90),
                  ),
                ),
              ),
    
    
              Padding(
                padding: EdgeInsets.only(
                  bottom: height / 47,
                ),
                child: TextField(
                  controller: middlename,
                  style: Theme.of(context).textTheme.headlineSmall,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'MiddleName',
                    contentPadding:
                        EdgeInsets.only(left: width / 50, top: height / 50),
                  ),
                ),
              ),

                    Padding(
        padding: EdgeInsets.only(
          bottom: height / 47,
        ),
        child: TextField(
          controller: lastname,
          style: Theme.of(context).textTheme.headlineSmall,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            hintText: 'LastName',
            contentPadding:
                EdgeInsets.only(left: width / 50, top: height / 50),
          ),
        ),
      ),

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
         bottom: height / 47,
       ),
       child: TextField(
         controller: email,
         keyboardType: TextInputType.emailAddress,
         style: Theme.of(context).textTheme.headlineSmall,
         decoration: InputDecoration(
           border: UnderlineInputBorder(),
           hintText: 'Email',
           contentPadding:
               EdgeInsets.only(left: width / 50, top: height / 50),
         ),
       ),
     ),


              Padding(
                padding: EdgeInsets.only(
                    top: height / 30,
                    bottom: height / 30,
                    left: width / 22,
                    right: width / 22),
                child: GestureDetector(
                  onTap: () async {
                    if (firstname.text.isNotEmpty &&
                    middlename.text.isNotEmpty &&
                    lastname.text.isNotEmpty &&
                    phonenumber.text.isNotEmpty &&
                    email.text.isNotEmpty 
                        
                        ) {
                    
                    
                    
                    
                    
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentPage(firstname: firstname.text.trim(), lastname: lastname.text.trim(), middlename: middlename.text.trim(), number: phonenumber.text.trim(), amoount:widget.Amount, email: email.text.trim(), dbemail: widget.dbemail, version: widget.version,)
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Fill the lines')),
                      );
                    }
    
                    // return Singupcheck(currentUser);
                  },
                  child: Container(
                    height: height / 15,
                    width: width,
                    decoration: BoxDecoration(
                      color: const Color(0xff7905F5),
                      borderRadius: BorderRadius.circular(height / 10),
                    ),
                    child: Center(
                      child: Text(
                        "Process to pay",
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

  // Store selected detailsaddings and icon codePoints
}
