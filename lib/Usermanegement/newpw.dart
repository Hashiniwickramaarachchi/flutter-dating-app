import 'package:datingapp/Usermanegement/signin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Newpw extends StatefulWidget {
  final String email;

  Newpw({required this.email, Key? key}) : super(key: key);

  @override
  State<Newpw> createState() => _NewpwState();
}

class _NewpwState extends State<Newpw> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _newpassword = true;
  bool _confirmpassword = true;

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
         surfaceTintColor:const Color.fromARGB(255, 255, 255, 255),

     ),
      body: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        height: height,
        width: width,
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
                      border: Border.all(
                        color: Color(0xff26150F),
                      )),
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Color(0xffBF1506),
                      )),
                ),
                SizedBox(height: height / 20),
                Center(
                  child: Text(
                    "New Password",
                    style: TextStyle(
                        color: const Color(0xff26150F),
                        fontFamily: "defaultfontsbold",
                        fontWeight: FontWeight.w500,
                        fontSize: 24),
                  ),
                ),
                SizedBox(height: height / 50),
                Center(
                  child: Text(
                    "Your new password must be different from the previous one.",
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
                      EdgeInsets.only(bottom: height / 30, top: height / 15),
                  child: TextField(
                    style: Theme.of(context).textTheme.headlineSmall,
                    controller: newPasswordController,
                    obscureText: _newpassword,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'New Password',
                      contentPadding:
                          EdgeInsets.only(left: width / 50, top: height / 50),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _newpassword = !_newpassword;
                            });
                          },
                          icon: Icon(
                            _newpassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Color(0xff4D4D4D),
                            size: height / 40,
                          )),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: height / 47),
                  child: TextField(
                    style: Theme.of(context).textTheme.headlineSmall,
                    controller: confirmPasswordController,
                    obscureText: _confirmpassword,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Confirm Password',
                      contentPadding:
                          EdgeInsets.only(left: width / 50, top: height / 50),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _confirmpassword = !_confirmpassword;
                            });
                          },
                          icon: Icon(
                            _confirmpassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Color(0xff4D4D4D),
                            size: height / 40,
                          )),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: height / 15,),
                  child: GestureDetector(
                    onTap: () async {
                      if (newPasswordController.text ==
                          confirmPasswordController.text) {
                        try {
                          await _auth.sendPasswordResetEmail(
                              email: widget.email);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Password reset email sent! update it using the link')));
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => signin()));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Error: ${e.toString()}')));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Passwords do not match!')));
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
                          "Create New Password",
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
}
