import 'dart:ffi';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/userchatpage.dart';
import 'package:datingapp/viewpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class person extends StatefulWidget {
  String ID;
  String profileimage;
  String name;
  String location;
  double distance;
  double startLatitude;
  double startLongitude;
  double endLatitude;
  double endLongitude;
  int age;
  String education;
  String height;
  List<dynamic> languages;

  final String onlinecheck;
  final Color statecolour;
  String description;
  List<dynamic> iconss;
  List<dynamic> labels;
  List<dynamic> imagecollection;
  String useremail;

  person(
      {required this.ID,
      required this.languages,
      required this.education,
      required this.description,
      required this.onlinecheck,
      required this.statecolour,
      required this.profileimage,
      required this.name,
      required this.location,
      required this.distance,
      required this.startLongitude,
      required this.startLatitude,
      required this.endLongitude,
      required this.endLatitude,
      required this.age,
      required this.height,
      required this.iconss,
      required this.labels,
      required this.imagecollection,
      required this.useremail,
      super.key});

  @override
  State<person> createState() => _personState();
}

class _personState extends State<person> {
  bool fav = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color.fromARGB(255, 245, 236, 255)),
      child: Padding(
        padding: EdgeInsets.only(
            left: width / 30,
            right: width / 30,
            top: height / 60,
            bottom: height / 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 5,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return viewpage(
                          image: widget.profileimage,
                          name: widget.name,
                          address: widget.location,
                          distance: calculateDistance(
                                  widget.startLatitude,
                                  widget.startLongitude,
                                  widget.endLatitude,
                                  widget.endLongitude)
                              .toInt(),
                          age: widget.age,
                          height: widget.height,
                          labels: widget.labels,
                          iconss: widget.iconss,
                          imagecollection: widget.imagecollection,
                          fav: fav,
                          ID: widget.ID,
                          useremail: widget.useremail,
                          onlinecheck: widget.onlinecheck,
                          statecolour: widget.statecolour,
                          languages: widget.languages,
                          education: widget.education,
                          description: widget.description,
                        );
                      },
                    ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                            image: NetworkImage(widget.profileimage),
                            fit: BoxFit.cover)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: height / 60,
                              left: width / 50,
                              right: width / 3),
                          child: Container(
                            height: height / 16,
                            width: width,
                            decoration: BoxDecoration(
                              color: Color(0xff7905F5),
                              borderRadius: BorderRadius.circular(height / 10),
                            ),
                            child: Center(
                              child: Text(
                                "${calculateDistance(widget.startLatitude, widget.startLongitude, widget.endLatitude, widget.endLongitude).toInt()}Km far away",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ),
                        ),
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
                              filter:
                                  ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                              child: Container(
                                child: Container(
                                  color:
                                      const Color.fromARGB(255, 124, 124, 124)
                                          .withOpacity(0.2),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          widget.name,
                                          style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontFamily: "defaultfontsbold",
                                              fontWeight: FontWeight.w900,
                                              fontSize: 24),
                                          maxLines: 1, // Limit to one line
                                          overflow: TextOverflow
                                              .ellipsis, // Adds "..." if the text is too long
                                        ),
                                      ),
                                      Text(
                                        textAlign: TextAlign.center,
                                        widget.location,
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
                )),
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff7905F5),
                      ),
                      child: IconButton(
                          onPressed: () async {
                            setState(() {
                              fav = !fav; // Toggle the state
                            });
                            // Update Firestore collection
                            if (fav) {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.ID)
                                  .get()
                                  .then((DocumentSnapshot
                                      documentSnapshot) async {
                                if (documentSnapshot.exists) {
                                  // Get the document data from the "Sell" collection
                                  Map<String, dynamic> data = documentSnapshot
                                      .data() as Map<String, dynamic>;
                                  try {
                                    // Step 2: Create a new document in the "Favourite" collection with a generated ID
                                    DocumentReference favDocRef =
                                        await FirebaseFirestore.instance
                                            .collection('Favourite')
                                            .doc(widget.useremail);

                                    // Add the data to the main document in Favourite

                                    await FirebaseFirestore.instance
                                        .collection('Favourite')
                                        .doc(widget.useremail)
                                        .set({"name": ''});
                                    print(
                                        "Favourite document created with ID: ${favDocRef.id}");
                                    // Step 3: Create a subcollection under the newly created document
                                    await favDocRef
                                        .collection(
                                            "fav1") // Subcollection name
                                        .doc(widget
                                            .ID) // Use the same ID as in the "Sell" collection
                                        .set(
                                            data); // Add the data from the "Sell" collection
                                    print(
                                        "Subcollection 'fav1' created with document ID: ${widget.ID}");
                                    FirebaseFirestore.instance
                                        .collection(
                                            'Favourite') // Replace with your collection name
                                        .doc(widget.useremail)
                                        .collection("fav1")
                                        .doc(widget
                                            .ID) // Replace with the document ID you want to update
                                        .update({'fav1': true})
                                        .then((_) =>
                                            print("Favorite updated to true"))
                                        .catchError((error) => print(
                                            "Failed to update favorite: $error"));
                                  } catch (error) {
                                    print(
                                        "Error during creation of Favourite document or subcollection: $error");
                                  }
                                } else {
                                  print(
                                      "Document does not exist in Sell collection");
                                }
                              }).catchError((error) {
                                print(
                                    "Failed to retrieve document from Sell collection: $error");
                              });
                            } else {
                              try {
                                DocumentReference favDocRef = FirebaseFirestore
                                    .instance
                                    .collection('Favourite')
                                    .doc(widget.useremail)
                                    .collection("fav1")
                                    .doc(widget.ID);

                                await favDocRef.delete();
                                print(
                                    "Favorite removed with document ID: ${widget.ID}");
                              } catch (error) {
                                print("Error removing from Favourite: $error");
                              }
                            }
                          },
                          icon: Icon(
                            fav
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_outlined,
                            color: Colors.white,
                            size: height / 30,
                          )),
                    ),
                    SizedBox(
                      width: width / 40,
                    ),
                    GestureDetector(
                      onTap: () {

 return  checkInterestMatch();
                        // Navigator.of(context).push(MaterialPageRoute(
                          // builder: (context) {
                            // return ChatPage(
                              // chatPartnerEmail: widget.ID,
                              // chatPartnername: widget.name,
                              // chatPartnerimage: widget.profileimage,
                              // onlinecheck: widget.onlinecheck,
                              // statecolour: widget.statecolour,
                              // who: 'user',
                            // );
                          // },
                        // ));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff7905F5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ClipRRect(
                              child: Image.asset(
                                "images/Vector.png",
                                height: height / 30,
                              ),
                            ),
                          )),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  double calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    double distanceInMeters = Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );

    // Convert meters to kilometers
    double distanceInKilometers = distanceInMeters / 1000;

    return distanceInKilometers;
  }
   void checkInterestMatch() async {
    try {
      // Get logged-in user's email

      // Fetch interests from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.useremail)
          .get();
      final targetDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.ID)
          .get();

      // Extract interests
      List<dynamic> userInterests = userDoc.data()?['Interest'] ?? [];
      List<dynamic> targetInterests = targetDoc.data()?['Interest'] ?? [];

      // Calculate match percentage
      if (userInterests.isNotEmpty && targetInterests.isNotEmpty) {
        final commonInterests = userInterests
            .where((interest) => targetInterests.contains(interest))
            .toList();
        final matchPercentage =
            (commonInterests.length / targetInterests.length) * 100;

        // Navigate or show message
        if (matchPercentage >= 60) {
      
            Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return ChatPage(
            chatPartnerEmail: widget.ID,
            chatPartnername: widget.name,
            chatPartnerimage: widget.profileimage,
            onlinecheck: widget.onlinecheck,
            statecolour: widget.statecolour,
            who: 'user',
          );
        },
      ));
      
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Your interests match ${matchPercentage.toStringAsFixed(1)}% with ${widget.ID}. Please try again later!'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No interests found to compare.')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to check match. Try again.')),
      );
    }
  }

}
