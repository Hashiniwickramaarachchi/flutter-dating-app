import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/premium/welcompremiuum.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

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
   super.key});
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? orderTrackingId;
  String? merchantReference;
  String? redirectUrl;
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('success')) {
              _handleSuccessUrl(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    submitOrder();
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
        "middle_name":widget.middlename,
        "last_name": widget.lastname,
        "email_address": widget.email
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
        _webViewController.loadRequest(Uri.parse(redirectUrl!));
      }
    } else {
      // Handle error
      print('Failed to submit order: ${response.statusCode}');
    }
  }

 void _handleSuccessUrl(String url) async{
    final uri = Uri.parse(url);

    // Extract query parameters
    final successOrderTrackingId = uri.queryParameters['OrderTrackingId'];
    final successOrderMerchantReference = uri.queryParameters['OrderMerchantReference'];
          try {
            await FirebaseFirestore.instance
                .collection(widget.version)
                .doc(widget.dbemail)
                .set({
              'Buy Time':
                  FieldValue.serverTimestamp(),
              "User": widget.dbemail,
              'OrderID':orderTrackingId
            });
            await FirebaseFirestore.instance
                .collection('users')
                .doc(widget.dbemail)
                .update({'profile': 'premium'});
            setState(() {});
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(
                    content: Text(
                        'User upgraded to premium')));
        
        
        
        
          
          } catch (e) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(
                    content: Text(
                        'Error updating profile: $e')));
          }


    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => wlcomepremium()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Payment'))),
      body: redirectUrl == null
          ? Center(child: CircularProgressIndicator())
          : WebViewWidget(controller: _webViewController),
    );
  }
}

