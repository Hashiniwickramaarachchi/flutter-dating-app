import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/mainscreen.dart';
import 'package:datingapp/premium/welcompremiuum.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PaymentPage extends StatefulWidget {
  String firstname;
  String middlename;
  String lastname;
  String number;
  int amoount;
  String email;
  String dbemail;
  String version;

  PaymentPage({
    required this.firstname,
    required this.lastname,
    required this.middlename,
    required this.number,
    required this.amoount,
    required this.dbemail,
    required this.email,
    required this.version,
    super.key,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? orderTrackingId;
  String? merchantReference;
  String? redirectUrl;
  Timer? _checkTimer;
  int countdown = 20; // Countdown starts at 30 seconds

  @override
  void initState() {
    super.initState();
    submitOrder();
    startCountdown();
  }

  // void startCountdown() {
  //   Timer.periodic(Duration(seconds: 1), (timer) {
  //     if (countdown > 0) {
  //       setState(() {
  //         countdown--;
  //       });
  //     } else {
  //       timer.cancel();
  //     }
  //   });
  // }
Timer? _countdownTimer;
void startCountdown() {
  _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
    if (mounted) {
      setState(() {
        if (countdown > 0) {
          countdown--;
        } else {
          countdown = 20; // Restart the countdown
        }
      });
    }
  });
}

  Future<void> submitOrder() async {
    final url = Uri.parse('https://apexlovehost.com/api/orders/submit');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "amount": widget.amoount,
        "phone": widget.number,
        "first_name": widget.firstname,
        "middle_name": widget.middlename,
        "last_name": widget.lastname,
        "email_address": widget.email,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        orderTrackingId = responseData['order_tracking_id'];
        merchantReference = responseData['merchant_reference'];
        redirectUrl = responseData['redirect_url'];
      });

      if (redirectUrl != null) {
        await launchUrl(Uri.parse(redirectUrl!), mode: LaunchMode.externalApplication);
        startSubscriptionCheck();
      }
    } else {
      print('Failed to submit order: ${response.statusCode}');
    }
  }

  void startSubscriptionCheck() {
    _checkTimer = Timer.periodic(Duration(seconds: 30), (timer) async {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.dbemail).get();
      if (userDoc.exists && userDoc.data()?['subscriptionExpireAt'] != null) {
        timer.cancel();
        await _upgradeUserToPremium();
      }
    });
  }

  Future<void> _upgradeUserToPremium() async {
    try {
      await FirebaseFirestore.instance.collection(widget.version).doc(widget.dbemail).set({
        'Buy Time': FieldValue.serverTimestamp(),
        "User": widget.dbemail,
        'OrderID': orderTrackingId,
      });
      await FirebaseFirestore.instance.collection('users').doc(widget.dbemail).update({'profile': 'premium'});

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User upgraded to premium')));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => wlcomepremium()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
    }
  }

  @override
 void dispose() {
  // Cancel both countdown and subscription check timers
  _countdownTimer?.cancel();
  _checkTimer?.cancel();
  super.dispose();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Payment')),
        automaticallyImplyLeading: false,
      ),
      body: 
          Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 Stack(
            alignment: Alignment.center,
            children: [
              // Circular Progress Indicator for countdown
              SizedBox(
                width: 150,
                height: 150,
                child: CircularProgressIndicator(
                  value: countdown / 20, // Progress as a fraction
                  strokeWidth: 12,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                  backgroundColor: Colors.grey[300],
                ),
              ),
              // Countdown text inside the circle
              Text(
                '$countdown',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
                ],
              ),
               SizedBox(height: 20),
          Text(
            "Redirecting to payment in $countdown seconds...",
            style: TextStyle(fontSize: 16),
          ),
            ])),
          
    );
  }
}
