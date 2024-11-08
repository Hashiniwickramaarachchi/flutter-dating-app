import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class A_helpcenter extends StatefulWidget {
  String mainname;
  List questions;

  A_helpcenter({required this.mainname, required this.questions, super.key});

  @override
  State<A_helpcenter> createState() => _A_helpcenterState();
}

class _A_helpcenterState extends State<A_helpcenter> {
  bool _showTextFields = false;
    final TextEditingController _questionController = TextEditingController();

  void _toggleTextFields() {
    setState(() {
      _showTextFields = !_showTextFields;
    });
  }
Future<void> _submitQuestion() async {
  final curentuser = FirebaseAuth.instance.currentUser!;
  final String userEmail = curentuser.email!;

  if (curentuser != null) {
    try {
      // Check if the document exists
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection(widget.mainname)
          .doc(userEmail)
          .get();

      if (docSnapshot.exists) {
        // Update the existing document with the new question
        await FirebaseFirestore.instance
            .collection(widget.mainname)
            .doc(userEmail)
            .update({
          'Question': FieldValue.arrayUnion([
            _questionController.text.trim(),
          ]),
        });
      } else {
        // Create the document if it does not exist
        await FirebaseFirestore.instance
            .collection(widget.mainname)
            .doc(userEmail)
            .set({
          'Question': [
            _questionController.text.trim(),
          ],
        });
      }

      // Clear the text field after submission
      _questionController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Your question has been sent successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send question: $e")),
      );
    }
  }
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

            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: height / 30,
                              right: width / 30,
                              left: width / 30),
                          child: Row(
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
                                    color:
                                        const Color.fromARGB(255, 121, 5, 245),
                                  ),
                                ),
                              ),
                              SizedBox(width: width / 20),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "FAQs & Help Center",
                                    style: TextStyle(
                                        color: const Color(0xff26150F),
                                        fontFamily: "defaultfontsbold",
                                        fontWeight: FontWeight.w500,
                                        fontSize: height / 35),
                                  ),
                                ),
                              ),
                              SizedBox(width: width / 10),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: width / 15, right: width / 15),
                        child: Container(
                          height: height / 22,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: TextField(
                            style: Theme.of(context).textTheme.headlineSmall,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: width / 20,
                                  top: height / 5,
                                  bottom: height / 100),
                              hintText: "Search for help...",
                              border: InputBorder.none,
                              suffixIcon: Icon(
                                Icons.search,
                                color: Color(0xff565656),
                                size: height / 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height / 40),
                      Padding(
                          padding: EdgeInsets.only(
                              left: width / 20,
                              right: width / 20,
                              top: height / 60),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.mainname,
                                  style: TextStyle(
                                      color: const Color(0xff4D4D4D),
                                      fontFamily: "defaultfontsbold",
                                      fontWeight: FontWeight.bold,
                                      fontSize: height / 45),
                                ),
                                SizedBox(
                                  height: height / 60,
                                ),
                                Container(
                                  height: height / 3.2,
                                  child: ListView.builder(
                                      itemCount: widget.questions.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  widget.questions[index],
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12),
                                                ),
                                                IconButton(
                                                  onPressed: _toggleTextFields,
                                                  icon: Icon(
                                                      Icons.arrow_drop_down,
                                                      color: Colors.black,
                                                      size: height / 40),
                                                ),
                                              ],
                                            ),
                                            if (_showTextFields)
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [])
                                          ],
                                        );
                                      }),
                                ),
                                Text(
                                  "Your Question?",
                                  style: TextStyle(
                                      color: const Color(0xff4D4D4D),
                                      fontFamily: "defaultfontsbold",
                                      fontWeight: FontWeight.bold,
                                      fontSize: height / 45),
                                ),
                                SizedBox(
                                  height: height / 60,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xffF9F9F9),
                                      borderRadius: BorderRadius.circular(10)),
                                  height: height / 5,
                                  child: TextField(
                                    maxLines: null,
                                    controller:_questionController ,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      fillColor: Color(0xffF9F9F9),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height / 60,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: width / 1.7),
                                  child: GestureDetector(
                                    onTap: () {
                                     _submitQuestion();
                                    },
                                    child: Container(
                                      height: height / 26,
                                      width: width / 3,
                                      child: Center(
                                          child: Text(
                                        "Send",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: height / 50,
                                            fontWeight: FontWeight.bold),
                                      )),
                                      decoration: BoxDecoration(
                                          color: Color(0xff7905F5),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))
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
}
