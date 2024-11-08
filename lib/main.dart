import 'package:datingapp/Landingpages/ladingpage.dart';
import 'package:datingapp/Usermanegement/gender.dart';
import 'package:datingapp/Usermanegement/locationadding.dart';
import 'package:datingapp/Usermanegement/manualadding.dart';
import 'package:datingapp/firebase_options.dart';
import 'package:datingapp/Usermanegement/signin.dart';
import 'package:datingapp/homepage.dart';
import 'package:datingapp/onlinecheck.dart';
import 'package:datingapp/splashscreen.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main()async{

WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform);   

  EmailOTP.config(
    appName: 'Appexlove',
    otpType: OTPType.numeric, 
    otpLength: 4,
    emailTheme: EmailTheme.v3,
  );
runApp(MyApp());



}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
final height=MediaQuery.of(context).size.height;
final width=MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Appexlove",
      home: splashscreen(),
 theme: ThemeData(
  fontFamily: "defaultfonts",
  textTheme:  TextTheme(
  headlineSmall: TextStyle(fontFamily: "fieldfonts", fontSize: height / 55,color: Color(0xff464646)),
  bodySmall:TextStyle(fontFamily: "button",  color: Color(0xffFFFFFF),fontSize: height / 42,), 
    
    
    
     // Customize bodyText1 for general text
    // You can add more text styles here
  ),
)
 
 
 
 

 
      // home: homepage(),
      // home: loactionadding(),
      // home: manual(),
    );
  }
}