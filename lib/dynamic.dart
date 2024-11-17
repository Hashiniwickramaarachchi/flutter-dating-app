// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/material.dart';

// /// [DynamicLinkService]
// class DynamicLinkService {
//   static final DynamicLinkService _singleton = DynamicLinkService._internal();
//   DynamicLinkService._internal();
//   static DynamicLinkService get instance => _singleton;

//   // Create new dynamic link and return the link
//   Future<String> createDynamicLink() async {
//     try {
//       final dynamicLinkParams = DynamicLinkParameters(
//         link: Uri.parse("https://datingappapi.page.link.com"),
//         uriPrefix: "https://datingappapi.page.link",
//         androidParameters: const AndroidParameters(
//           packageName: "com.sarj33t.flutter_deeplink_demo",
//         ),
//         iosParameters: const IOSParameters(
//           bundleId: "com.sarj33t.flutterDeeplinkDemo",
//           appStoreId: "123456789",
//         ),
//       );

//       final dynamicLink =
//           await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
//       return dynamicLink.shortUrl.toString();
//     } catch (e) {
//       debugPrint("Error creating dynamic link: $e");
//       return "Error generating link.";
//     }
//   }
// }
