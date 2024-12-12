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
import 'package:firebase_remote_config/firebase_remote_config.dart';

class privacy extends StatefulWidget {
  String who;
   privacy({
    
    required this.who,
    super.key});

  @override
  State<privacy> createState() => _privacyState();
}

class _privacyState extends State<privacy> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(isInspectable: kDebugMode);
  PullToRefreshController? pullToRefreshController;
  PullToRefreshSettings pullToRefreshSettings = PullToRefreshSettings(color: Color.fromARGB(255, 4, 132, 32));
  bool pullToRefreshEnabled = true;
  String privacyPolicyUrl = ''; // Initialize an empty URL

  @override
  void initState() {
    super.initState();
    _fetchPrivacyPolicyUrl();
    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            settings: pullToRefreshSettings,
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                webViewController?.loadUrl(urlRequest: URLRequest(url: await webViewController?.getUrl()));
              }
            },
          );
  }

  // Fetch the privacy policy URL from Firebase Remote Config
  Future<void> _fetchPrivacyPolicyUrl() async {
    try {
      final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.fetchAndActivate();
      String fetchedUrl = remoteConfig.getString('privacy_policy_url');
      setState(() {
        privacyPolicyUrl = fetchedUrl;
      });
    } catch (e) {
      print('Error fetching remote config: $e');
      // Optionally, set a default URL if fetching fails
      setState(() {
        privacyPolicyUrl = 'https://default-url.com/privacy-policy';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final curentuser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection(widget.who)
            .doc(curentuser.email!)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userdataperson = snapshot.data!.data() as Map<String, dynamic>;

            return Scaffold(
              appBar: AppBar(
                toolbarHeight: height / 400,
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                automaticallyImplyLeading: false,
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
              ),
              backgroundColor: Colors.white,
              body: Container(
                child: Padding(
                  padding: EdgeInsets.only(right: width / 20, left: width / 20),
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
                              border: Border.all(width: 1, color: Colors.black),
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: const Color.fromARGB(255, 121, 5, 245),
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
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: width / 10),
                        ],
                      ),
                      SizedBox(height: height / 40),
                      Expanded(
                        child: privacyPolicyUrl.isNotEmpty
                            ? InAppWebView(
                                key: webViewKey,
                                initialUrlRequest: URLRequest(url: WebUri(privacyPolicyUrl)),
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
                              )
                            : Center(child: CircularProgressIndicator()),
                      ),
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
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}