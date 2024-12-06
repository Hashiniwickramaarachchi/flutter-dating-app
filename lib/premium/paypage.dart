// import 'dart:async';
// import 'package:datingapp/premium/paymentcalling.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:uni_links/uni_links.dart';

// class paypage extends StatefulWidget {
//   @override
//   _paypageState createState() => _paypageState();
// }

// class _paypageState extends State<paypage> {
//   late StreamSubscription _sub;

//   @override
//   void initState() {
//     super.initState();
//     _initDeepLinkListener();
//   }

//   Future<void> _initDeepLinkListener() async {
//     _sub = getUriLinksStream().listen((Uri? uri) {
//       if (uri != null) {
//         // When callback URL is triggered, check if it's the callback URL
//         if (uri.scheme == 'your-app' && uri.host == 'payment' && uri.path == 'callback') {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => PaymentCallbackPage(callbackUrl: uri),
//             ),
//           );
//         }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _sub.cancel();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text('Pesapal Payment')),
//         body: Center(
//           child: ElevatedButton(
//             onPressed: () {
//               // Call the function to initiate the payment
//               createPesapalPayment(context);
//             },
//             child: Text('Make Payment'),
//           ),
//         ),
//       ),
//     );
//   }

//   // Function to initiate Pesapal Payment
//   void createPesapalPayment(BuildContext context) async {
//     String consumerKey = 'KJcJmdz8sLclrC8ucZmXwGcQIARR3CUh'; // Replace with your Pesapal Consumer Key
//     String consumerSecret = '2j0EstmCB0Q+7p687k8unmdxWEU='; // Replace with your Pesapal Consumer Secret
//     String amount = '10.00';  // Amount to charge
//     String email = 'customer@example.com';  // Customer email
//     String phone = '254712345678';  // Customer phone number
//     String callbackUrl = 'your-app://payment/callback';  // Deep link to handle callback in the app

//     // Pesapal API endpoint for payment creation
//     final String apiUrl = "https://www.pesapal.com/api/PostPesapalDirectOrderV4";

//     // Create payment request body
//     Map<String, String> body = {
//       'amount': amount,
//       'email': email,
//       'phonenumber': phone,
//       'currency': 'USD', // or 'KES' depending on the region
//       'callback_url': callbackUrl,
//       'order_id': 'ORDER123456',
//       'description': 'Payment for goods/services',
//     };

//     // Set the headers with Pesapal credentials
//     Map<String, String> headers = {
//       'Authorization': 'Bearer $consumerKey:$consumerSecret',
//       'Content-Type': 'application/json',
//     };

//     // Make the POST request to Pesapal API
//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: headers,
//         body: json.encode(body),
//       );

//       if (response.statusCode == 200) {
//         // Handle successful response
//         print('Payment initiated successfully: ${response.body}');
//         // Optionally, you can extract the payment URL from the response
//         // and show it in a WebView or use the data as needed.
//       } else {
//         print('Failed to initiate payment: ${response.body}');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
// }