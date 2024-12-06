// import 'package:flutter/material.dart';

// class PaymentCallbackPage extends StatelessWidget {
//   final Uri callbackUrl;

//   PaymentCallbackPage({required this.callbackUrl});

//   @override
//   Widget build(BuildContext context) {
//     // Extract the payment status and order ID from the callback URL query parameters
//     final status = callbackUrl.queryParameters['status'];
//     final orderId = callbackUrl.queryParameters['order_id'];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Payment Callback'),
//       ),
//       body: Center(
//         child: status == 'success'
//             ? PaymentSuccess(orderId: orderId)
//             : PaymentFailure(orderId: orderId),
//       ),
//     );
//   }
// }

// class PaymentSuccess extends StatelessWidget {
//   final String? orderId;

//   PaymentSuccess({this.orderId});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text('Payment Successful!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//         SizedBox(height: 16),
//         Text('Order ID: $orderId', style: TextStyle(fontSize: 18)),
//         SizedBox(height: 32),
//         ElevatedButton(
//           onPressed: () {
//             Navigator.pop(context); // Close the callback page and return to the main screen
//           },
//           child: Text('OK'),
//         ),
//       ],
//     );
//   }
// }

// class PaymentFailure extends StatelessWidget {
//   final String? orderId;

//   PaymentFailure({this.orderId});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text('Payment Failed!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)),
//         SizedBox(height: 16),
//         Text('Order ID: $orderId', style: TextStyle(fontSize: 18)),
//         SizedBox(height: 32),
//         ElevatedButton(
//           onPressed: () {
//             Navigator.pop(context); // Close the callback page and return to the main screen
//           },
//           child: Text('Try Again'),
//         ),
//       ],
//     );
//   }
// }
