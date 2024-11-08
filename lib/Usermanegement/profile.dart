import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/bootmnavbar.dart';
import 'package:datingapp/premium/allpremiumusers.dart';
import 'package:datingapp/settingpage.dart/setting&activitypage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
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

            return SafeArea(
              child: Scaffold(
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                body: Container(
                  height: height,
                  width: width,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: height / 30,
                            bottom: height / 60,
                            right: width / 30,
                            left: width / 30),
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
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        fontFamily: "defaultfontsbold",
                                        fontSize: height / 32),
                                  )),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) {
                                          return settingactivity();
                                        },
                                      ));
                                    },
                                    child: Image(
                                        image: AssetImage(
                                            "images/heroicons-outline_menu-alt-2.png")))
                              ],
                            ),
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: height / 50),
                                child: Container(
                                  height: height / 5,
                                  width: width / 2.5,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color:
                                            Color.fromARGB(255, 121, 5, 245)),
                                    shape: BoxShape.circle,
                                    color: const Color.fromARGB(
                                        255, 206, 206, 206),
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
                                                        "profile_pic"])),
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  userdataperson['name'],
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontFamily: "defaultfontsbold",
                                      fontSize: height / 32),
                                ),
         if (userdataperson['profile'] == "premium") ...[
                 
            Padding(
              padding:  EdgeInsets.only(left: width/50),
              child: 
              Container(
                    height: height / 20,
                    width: width / 20,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                image:
                    AssetImage("assetss/Vector.png",),)),
                  ),
            ),
         ],
                              ],
                            )),
                            if (userdataperson['profile'] == "standard") ...[
                              SizedBox(
                                height: height / 60,
                              ),
                            ],
                            if (userdataperson['profile'] == "premium") ...[
                              SizedBox(
                                height: height / 90,
                              ),
                              GestureDetector(
                                onTap: () {
Navigator.of(context).push(MaterialPageRoute(builder:(context) {
  return allpremium(userLatitude: userdataperson['X'], userLongitude: userdataperson["Y"], useremail: userdataperson['email']);
},));

                                },
                                child: Center(
                                    child: Text(
                                  "See Premium Users",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 121, 5, 245),
                                      fontFamily: "defaultfontsbold",
                                      fontSize: height / 50),
                                )),
                              ),
                            ],
                            Padding(
                              padding: EdgeInsets.only(
                                  left: width / 70,
                                  right: width / 70,
                                  top: height / 60),
                              child: Container(
                                height:
                                    height / 8.5, // Adjust based on your design
                                color: Colors.transparent,
                                width: width,
                                child: GridView.builder(
                                  physics:
                                      ScrollPhysics(), // Prevents extra scrolling
                                  shrinkWrap: true,
                                  itemCount: userdataperson['Interest'].length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        3, // Number of items per row
                                    crossAxisSpacing: width / 90,
                                    mainAxisSpacing: height * 0.01,
                                    childAspectRatio:
                                        3, // Ensures the grid items are square
                                  ),
                                  itemBuilder: (context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xffD9D9D9),
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              IconData(
                                                userdataperson['Icon'][index],
                                                fontFamily: 'MaterialIcons',
                                              ),
                                              color: Color(0xff565656),
                                              size: height / 42,
                                            ),
                                            Text(
                                              userdataperson['Interest'][index],
                                              style: TextStyle(
                                                  color:
                                                      const Color(0xff565656),
                                                  fontFamily:
                                                      "defaultfontsbold",
                                                  fontSize: height / 62),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height / 60,
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
                                                userdataperson['images']
                                                    [index]),
                                            fit: BoxFit.cover)),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: height / 1.23,
                            left: width / 20,
                            right: width / 20),
                        child: BottomNavBar(
                          selectedIndex2: 4,
                        ),
                      )
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
