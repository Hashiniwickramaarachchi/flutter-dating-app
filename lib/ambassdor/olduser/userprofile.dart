import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/bootmnavbar.dart';
import 'package:datingapp/settingpage.dart/setting&activitypage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class userprofile extends StatefulWidget {
  String email;
  userprofile({required this.email, super.key});

  @override
  State<userprofile> createState() => _userprofileState();
}

class _userprofileState extends State<userprofile> {
  XFile? _image;
  final List<Map<String, dynamic>> _interests = [
    {'icon': Icons.music_note, 'label': 'Music'},
    {'icon': Icons.directions_bike, 'label': 'Dance'},
    {'icon': Icons.book, 'label': 'Books'},
    {'icon': Icons.language, 'label': 'Languages'},
    {'icon': Icons.photo_camera, 'label': 'Photography'},
    {'icon': Icons.checkroom, 'label': 'Fashion'},
    {'icon': Icons.nature, 'label': 'Nature'},
    {'icon': Icons.fitness_center, 'label': 'Gym'},
    {'icon': Icons.pets, 'label': 'Animal'},
  ];
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(widget.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Check if data exists before casting to Map<String, dynamic>
            final userdataperson =
                snapshot.data!.data() as Map<String, dynamic>?;
            if (userdataperson == null) {
              return Center(
                child: Text("User data not found."),
              );
            }

            return Scaffold(
              appBar: AppBar(
                toolbarHeight: height / 400,
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                automaticallyImplyLeading: false,
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
              ),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              body: Container(
                height: height,
                width: width,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: height / 60,
                          right: width / 20,
                          left: width / 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: height / 10,
                                width: width / 10,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 1, color: Colors.black)),
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color: Color.fromARGB(255, 121, 5, 245),
                                    )),
                              ),
                              Expanded(
                                child: Center(
                                    child: Text(
                                  "Profile",
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontFamily: "defaultfontsbold",
                                      fontSize: 20),
                                )),
                              ),
                              // GestureDetector(
                              // onTap: () {
                              // Navigator.of(context)
                              // .push(MaterialPageRoute(
                              // builder: (context) {
                              // return settingactivity();
                              // },
                              // ));
                              // },
                              // child: Image(
                              // image: AssetImage(
                              // "images/heroicons-outline_menu-alt-2.png")))

                              SizedBox(
                                width: width / 15,
                              )
                            ],
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: height / 30),
                              child: Container(
                                height: height / 5,
                                width: width / 2.5,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color.fromARGB(255, 121, 5, 245)),
                                  shape: BoxShape.circle,
                                  color:
                                      const Color.fromARGB(255, 206, 206, 206),
                                ),
                                child: _image == userdataperson['profile_pic']
                                    ? Icon(
                                        Icons.person,
                                        color: const Color.fromARGB(
                                            255, 66, 66, 66),
                                        size: height / 15,
                                      )
                                    : Container(
                                        height: height / 6,
                                        width: width / 3,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  userdataperson[
                                                      "profile_pic"]),
                                              fit: BoxFit.cover),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height / 50,
                          ),
                          Center(
                              child: Text(
                            userdataperson['name'],
                            style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontFamily: "defaultfontsbold",
                                fontSize: 20),
                          )),
                          SizedBox(
                            height: height / 60,
                          ),
                          Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 3,
                              children: List<Widget>.generate(
                                userdataperson['Interest'].length,
                                (int index) {
                                  return _buildInterestChip(
                                      widget.email,
                                      context,
                                      userdataperson['Interest'][index],
                                      userdataperson['Icon'][index],
                                      height);
                                },
                              )),
                          SizedBox(
                            height: height / 30,
                          ),
                          Expanded(
                            child: GridView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: userdataperson['images'].length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: width * 0.02,
                                mainAxisSpacing: height * 0.02,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              userdataperson['images'][index]),
                                          fit: BoxFit.cover)),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Padding(
                    // padding: EdgeInsets.only(
                    // top: height / 1.23,
                    // left: width / 20,
                    // right: width / 20),
                    // child: BottomNavBar(
                    // selectedIndex2: 4,
                    // ),
                    // )
                  ],
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

  Widget _buildInterestChip(String email, BuildContext context, String label,
      int iconname, final height) {
    return Chip(
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(30)),
        avatar: Icon(
          size: 18,
          IconData(iconname, fontFamily: 'MaterialIcons'),
          color: Color(0xff565656),
        ), // Ensure the correct font family
        label: Text(
          label,
          style: TextStyle(
              color: const Color(0xff565656),
              fontFamily: "defaultfontsbold",
              fontSize: 10),
        ),
        backgroundColor: Color(0xffD9D9D9));
  }
}
