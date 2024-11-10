import 'package:datingapp/Usermanegement/newpw.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Verifycode extends StatefulWidget {
  final String otpemail;

  Verifycode({required this.otpemail, super.key});

  @override
  State<Verifycode> createState() => _VerifycodeState();
}

class _VerifycodeState extends State<Verifycode> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
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
        height: height,
        width: width,
        color: Color.fromARGB(255, 255, 255, 255),
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
                SizedBox(
                  height: height / 20,
                ),
                Center(
                    child: Text(
                  "Verification Code",
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
                    "Please enter the code we just sent to email\n${widget.otpemail}",
                    style: TextStyle(
                        color: const Color(0xff7D7676),
                        fontWeight: FontWeight.bold,
                        fontFamily: "defaultfontsbold",
                        fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: height / 20,
                ),
                Padding(
                  padding: EdgeInsets.all(height / 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      return Container(
                        width: width / 7,
                        height: height / 12,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(85, 164, 161, 161)
                              .withOpacity(0.3),
                          borderRadius: BorderRadius.circular(height / 77),
                        ),
                        child: Stack(
                          children: [
                            TextField(
                              controller: _controllers[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              style:
                                  Theme.of(context).textTheme.headlineSmall,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(top: height / 90),
                                counterText: '',
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: height / 28, bottom: height / 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Didn’t received email?",
                          style: TextStyle(
                              fontFamily: "fieldfonts",
                              fontSize:15,
                              color: Color(0xff4D4D4D)),
                        ),
                        GestureDetector(
                            onTap: () async {
                              if (await EmailOTP.sendOTP(
                                  email: widget.otpemail)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("OTP has been sent"),
                                  ),
                                );
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Verifycode(
                                            otpemail: widget.otpemail)));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Failed to send OTP"),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              "Resend Code",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(0xff4D4D4D),
                                  decorationThickness: 2,
                                  fontFamily: "fieldfonts",
                                  fontSize: 15,
                                  color: Color(0xff4D4D4D),
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: height / 45, bottom: height / 30),
                  child: GestureDetector(
                    onTap: () async {
                      bool isVerified = await EmailOTP.verifyOTP(
                          otp: _controllers[0].text +
                              _controllers[1].text +
                              _controllers[2].text +
                              _controllers[3].text);
                      if (isVerified) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("OTP Verified Successfully"),
                          ),
                        );
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return Newpw(
                              email: widget.otpemail,
                            );
                          },
                        ));
    
                        // Perform actions after successful OTP verification
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Invalid OTP"),
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: height / 15,
                      width: width,
                      child: Center(
                        child: Text(
                          "Verify",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Color(0xff7905F5),
                          borderRadius: BorderRadius.circular(height / 10)),
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
