import 'package:datingapp/Usermanegement/signin.dart';
import 'package:datingapp/Usermanegement/signup.dart';
import 'package:datingapp/ambassdor/newuser/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class landingpage extends StatefulWidget {
  const landingpage({super.key});

  @override
  State<landingpage> createState() => _landingpageState();
}

class _landingpageState extends State<landingpage> {
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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Container(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: Image.asset("assetss/logo.png")),
              SizedBox(
                height: height / 15,
              ),
              Center(
                child: Image.asset("assetss/Image.png"),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Find Your Match:",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 121, 5, 245),
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            fontFamily: "defaultfontsbold"),
                      ),
                      Text(
                        " Where",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            fontFamily: "defaultfontsbold"),
                      )
                    ],
                  ),
                  Text(
                    " Every Journey Starts.",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        fontFamily: "defaultfontsbold"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: width / 40,
                        right: width / 40,
                        top: height / 60,
                        bottom: height / 60),
                    child: Center(
                        child: Text(
                      "",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: height / 55,
                          fontFamily: 'defaultfonts'),
                      textAlign: TextAlign.center,
                    )),
                  ),
                  SizedBox(
                    height: height / 30,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: height / 60,
                        bottom: height / 30,
                        left: width / 22,
                        right: width / 22),
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) {
                            return signup();
                          },
                        ));
                      },
                      child: Container(
                        height: height / 16,
                        width: width,
                        decoration: BoxDecoration(
                          color: Color(0xff7905F5),
                          borderRadius: BorderRadius.circular(height / 10),
                        ),
                        child: Center(
                          child: Text(
                            "Let’s Get Started",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already Have an account?  ",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'mulish',
                        color: Color(0xff26150F),
                      )),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) {
                          return signin();
                        },
                      ));
                    },
                    child: Text(
                      "Sign in",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xff7905F5),
                        decorationThickness: 2,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'mulish',
                        color: Color(0xff7905F5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height / 50,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context) {
                    return A_signup();
                  },));
                },
                child: Text(
                  "Are You Ambassador?",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xff7905F5),
                    decorationThickness: 2,
      
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'mulish',
                    color: Color(0xff7905F5),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
