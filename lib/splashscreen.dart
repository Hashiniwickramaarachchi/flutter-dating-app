import 'dart:async';

import 'package:datingapp/Landingpages/ladingpage.dart';
import 'package:datingapp/Usermanegement/signin.dart';
import 'package:flutter/material.dart';

class splashscreen extends StatefulWidget {
  const splashscreen({super.key});

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {


  void initState(){
    super.initState();
    Timer(const Duration(seconds: 5),() {
      Navigator.of(context).push(MaterialPageRoute(builder:(context) {
        return landingpage();
      },));
    });
  }


  @override
  Widget build(BuildContext context) {

final height=MediaQuery.of(context).size.height;
final width=MediaQuery.of(context).size.width;



    return SafeArea(
      child: Scaffold(
        body: Container(
          color: const Color.fromARGB(255, 125, 5, 245),
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           Image.asset("images/logo white.png")
        
          ],
        ),
        
        
        ),
      ),
    );
  }
}