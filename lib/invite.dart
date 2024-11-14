import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class invite extends StatefulWidget {
  const invite({super.key});

  @override
  State<invite> createState() => _inviteState();
}

class _inviteState extends State<invite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

backgroundColor: Colors.white,
body: Center(
  child: Text("Invite"),
),



    );
  }
}