import 'package:datingapp/accoundelete.dart';
import 'package:datingapp/settingpage.dart/password.dart';
import 'package:datingapp/settingpage.dart/personalinfo.dart';
import 'package:flutter/material.dart';

class settings extends StatefulWidget {
  const settings({super.key});

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height / 400,
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(
            bottom: height / 60, right: width / 20, left: width / 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: height / 10,
                      width: width / 10,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(width: 1, color: Colors.black)),
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
                          "Settings",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontFamily: "defaultfontsbold",
                              fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(width: width / 15)
                  ],
                ),
                SizedBox(height: height / 20),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return UpdateProfilePage();
                      },
                    ));
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person_2_outlined,
                              color: Color(0xff565656),
                              size: height / 30,
                            ),
                            SizedBox(
                              width: width / 25,
                            ),
                            Text(
                              'Personal information',
                              style: TextStyle(
                                  color: const Color(0xff565656),
                                  fontFamily: "defaultfontsbold",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xff565656),
                          size: height / 40,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: width / 90, right: width / 90, top: height / 30),
                  child: Container(
                    width: width,
                    child: Divider(
                      height: 1,
                      color: const Color(0xffCAC7C7),
                    ),
                  ),
                ),
                SizedBox(
                  height: height / 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return passwordsequrity();
                      },
                    ));
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.shield_outlined,
                              color: Color(0xff565656),
                              size: height / 30,
                            ),
                            SizedBox(
                              width: width / 25,
                            ),
                            Text(
                              'Password and security',
                              style: TextStyle(
                                  color: const Color(0xff565656),
                                  fontFamily: "defaultfontsbold",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xff565656),
                          size: height / 40,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: width / 90, right: width / 90, top: height / 30),
                  child: Container(
                    width: width,
                    child: Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  height: height / 30,
                ),
                GestureDetector(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    // builder: (context) {
                    // return passwordsequrity();
                    // },
                    // ));
                    showModalBottomSheet(
                      //  isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      context: context,
                      builder: (context) {
                        return accountdelete(who: 'users',);
                      },
                    );
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              color: Color(0xffBF1506),
                              size: height / 30,
                            ),
                            SizedBox(
                              width: width / 25,
                            ),
                            Text(
                              'Delete Account',
                              style: TextStyle(
                                  color: const Color(0xffBF1506),
                                  fontFamily: "defaultfontsbold",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xffBF1506),
                          size: height / 40,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: width / 90, right: width / 90, top: height / 30),
                  child: Container(
                    width: width,
                    child: Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
