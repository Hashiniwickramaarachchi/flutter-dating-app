import 'dart:io';

import 'package:datingapp/Usermanegement/addemail.dart';
import 'package:datingapp/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:image_picker/image_picker.dart';

class A_privacy extends StatefulWidget {
  const A_privacy({super.key});

  @override
  State<A_privacy> createState() => _A_privacyState();
}

class _A_privacyState extends State<A_privacy> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings =
      InAppWebViewSettings(isInspectable: kDebugMode);
  PullToRefreshController? pullToRefreshController;
  PullToRefreshSettings pullToRefreshSettings = PullToRefreshSettings(
    color: Color.fromARGB(255, 4, 132, 32),
  );
  bool pullToRefreshEnabled = true;

  @override
  void initState() {
    super.initState();

    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            settings: pullToRefreshSettings,
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                webViewController?.loadUrl(
                    urlRequest:
                        URLRequest(url: await webViewController?.getUrl()));
              }
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final curentuser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Ambassdor")
            .doc(curentuser.email!)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userdataperson =
                snapshot.data!.data() as Map<String, dynamic>;

            return Scaffold(
                                                                    appBar: AppBar(
                      toolbarHeight:height/400,
                      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                      automaticallyImplyLeading: false,
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  surfaceTintColor:const Color.fromARGB(255, 255, 255, 255),
                  ),
              backgroundColor: Colors.white,
              body: Container(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: width / 20,
                      left: width / 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                                color: const Color.fromARGB(
                                    255, 121, 5, 245),
                              ),
                            ),
                          ),
                          SizedBox(width: width / 20),
                          Expanded(
                            child: Center(
                              child: Text(
                                "Privacy policy",
                                style: TextStyle(
                                    color: const Color(0xff26150F),
                                    fontFamily: "defaultfontsbold",
                                    fontWeight: FontWeight.w500,
                                    fontSize:20),
                              ),
                            ),
                          ),
                          SizedBox(width: width / 10),
                        ],
                      ),
                      SizedBox(height: height/40,),
                                               Expanded(
                              child: InAppWebView(
                            key: webViewKey,
                            initialUrlRequest:
            URLRequest(url: WebUri("https://dating-app-nu-two.vercel.app/A_privacy-policy")),
                            initialSettings: settings,
                            pullToRefreshController: pullToRefreshController,
                            onWebViewCreated: (InAppWebViewController controller) {
                              webViewController = controller;
                            },
                            onLoadStop: (controller, url) {
                              pullToRefreshController?.endRefreshing();
                            },
                            onReceivedError: (controller, request, error) {
                              pullToRefreshController?.endRefreshing();
                            },
                            onProgressChanged: (controller, progress) {
                              if (progress == 100) {
            pullToRefreshController?.endRefreshing();
                              }
                            },
                          )),
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error${snapshot.error}"),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Future<void> updateinfo(
      final userEmail,
      TextEditingController currentpassword,
      TextEditingController password,
      TextEditingController confirmpassword) async {
    try {
      // Handle password change if necessary
      if (password.text.isNotEmpty && confirmpassword.text.isNotEmpty) {
        if (password.text == confirmpassword.text) {
          await changePassword(currentpassword.text, password.text);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Passwords do not match!')),
          );
        }
      }
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile.')),
      );
    }
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    final user = FirebaseAuth.instance.currentUser!;
    final cred = EmailAuthProvider.credential(
        email: user.email!, password: currentPassword);

    try {
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password updated successfully!')),
      );
    } catch (e) {
      print('Error changing password: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update password.')),
      );
    }
  }
}
