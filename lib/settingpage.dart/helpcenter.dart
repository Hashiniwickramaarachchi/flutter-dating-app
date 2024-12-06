import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class helpcenter extends StatefulWidget {
  String mainname;
  List questions;

  helpcenter({required this.mainname, required this.questions, super.key});

  @override
  State<helpcenter> createState() => _helpcenterState();
}

class _helpcenterState extends State<helpcenter> {
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

        // Update the existing document with the new question
        await FirebaseFirestore.instance
            .collection('category')
            .doc(userEmail)
            .set({
          '${widget.mainname}': FieldValue.arrayUnion([
            {
              'issue': _questionController.text.trim(),
              'timestamp': DateTime.now().toUtc().toIso8601String(),
              // Use current UTC time
            }
          ]),
          'email': userEmail
        }, SetOptions(merge: true));

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
            .collection("users")
            .doc(curentuser.email!)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userdataperson =
                snapshot.data!.data() as Map<String, dynamic>;

            return Scaffold(
              appBar: AppBar(
                toolbarHeight: height / 400,
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                automaticallyImplyLeading: false,
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
              ),
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: width / 20, left: width / 20),
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
                                  color: const Color.fromARGB(255, 121, 5, 245),
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
                                      fontSize: 20),
                                ),
                              ),
                            ),
                            SizedBox(width: width / 10),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: width / 15, right: width / 15),
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
                                    fontSize: 16),
                              ),
                              SizedBox(
                                height: height / 60,
                              ),
                              StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection("faqs")
                                      .where('category',
                                          isEqualTo: '${widget.mainname}')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (!snapshot.hasData ||
                                        snapshot.data!.docs.isEmpty) {
                                      return Center(
                                          child:
                                              Text("No questions available."));
                                    }

                                    final data = snapshot.data!.docs;

                                    double containerHeight =
                                        height / 2 * data.length;

                                    return Container(
                                      height:
                                          containerHeight.clamp(0, height / 3),
                                      child: ListView.builder(
                                          itemCount: data.length,
                                          itemBuilder: (context, index) {
                                            return Card(
                                              color: Color(0xffF9F9F9),
                                              shadowColor: Colors.transparent,
                                              borderOnForeground: false,
                                              shape: BeveledRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              surfaceTintColor:
                                                  Colors.transparent,
                                              child: ExpansionTile(
                                                  expandedCrossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  childrenPadding:
                                                      EdgeInsets.only(
                                                          left: width / 25,
                                                          bottom: height / 90),
                                                  expandedAlignment:
                                                      Alignment.centerLeft,
                                                  children: [
                                                    Text(
                                                      data[index]['answer'],
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 10),
                                                    )
                                                  ],
                                                  collapsedBackgroundColor:
                                                      Color(0xffF9F9F9),
                                                  backgroundColor:
                                                      Color(0xffF9F9F9),
                                                  shape: BeveledRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  title: Text(
                                                      data[index]['question'],
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 11))),
                                            );
                                          }),
                                    );
                                  }),
                              SizedBox(
                                height: height / 30,
                              ),
                              Text(
                                "Your Question?",
                                style: TextStyle(
                                    color: const Color(0xff4D4D4D),
                                    fontFamily: "defaultfontsbold",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
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
                                  controller: _questionController,
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
                                          fontSize: 15,
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
