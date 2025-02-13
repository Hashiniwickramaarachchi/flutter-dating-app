import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class privacy extends StatefulWidget {
  final String who;

  privacy({required this.who, super.key});

  @override
  State<privacy> createState() => _privacyState();
}

class _privacyState extends State<privacy> {
  String privacyPolicyUrl = '';

  @override
  void initState() {
    super.initState();
    _fetchprivacyPolicyUrl();
  }

  Future<void> _fetchprivacyPolicyUrl() async {
    try {
      final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.fetchAndActivate();
      String url = remoteConfig.getString('privacy_policy_url');

      if (url.isNotEmpty) {
        _launchURL(url); // Launch the URL externally
      } else {
        _launchURL('https://appexlove.com/privacy-policy'); // Fallback URL
      }
    } catch (e) {
      print('Error fetching remote config: $e');
      _launchURL('https://appexlove.com/privacy-policy');
    }
  }

  Future<void> _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('Could not launch $url');
    }
    Navigator.pop(context); // Automatically close the page after launching the URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()), // Show loading until navigation occurs
    );
  }
}
