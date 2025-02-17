import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/ambassdor/share.dart';
import 'package:datingapp/userchatpage.dart';
import 'package:flutter/material.dart';

class A_viewpage extends StatefulWidget {
  String name;

  String image;

  String address;

  int distance;
  String description;
  int age;
  String ID;
  final String onlinecheck;
  final Color statecolour;
  String height;
  List<dynamic> iconss;
  List<dynamic> labels;
  List<dynamic> imagecollection;
  bool fav;
  List<dynamic> languaes;
  String education;

  String useremail;

  A_viewpage(
      {required this.address,
      required this.languaes,
      required this.age,
      required this.description,
      required this.distance,
      required this.education,
      required this.height,
      required this.image,
      required this.name,
      required this.ID,
      required this.iconss,
      required this.labels,
      required this.imagecollection,
      required this.fav,
      required this.onlinecheck,
      required this.statecolour,
      required this.useremail,
      super.key});

  @override
  State<A_viewpage> createState() => _A_viewpageState();
}

class _A_viewpageState extends State<A_viewpage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: height * 0.4,
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.image), // Replace with actual image
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  top: height / 15, left: width / 20, right: width / 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(width: 0, color: Colors.black)),
                      child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Color.fromARGB(255, 121, 5, 245),
                            size: height / 30,
                          )),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        color: Color.fromARGB(67, 0, 0, 0),
                        borderRadius: BorderRadius.circular(height / 10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: width / 15,
                            right: width / 15,
                            top: height / 70,
                            bottom: height / 70),
                        child: Text(
                          "${widget.distance}Km far away",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontFamily: "defaultfontsbold",
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: height / 3),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: width / 20, right: width / 20, top: height / 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.name,
                                  style: TextStyle(
                                    color: const Color(0xff26150F),
                                    fontFamily: "defaultfontsbold",
                                    fontWeight: FontWeight.w500,
                                    fontSize: height / 35,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow
                                      .visible, // You can also use TextOverflow.ellipsis if you want to truncate
                                ),
                                Text(
                                  widget.address,
                                  style: TextStyle(
                                      color: const Color(0xff565656),
                                      fontFamily: "defaultfontsbold",
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Container(
                                // decoration: BoxDecoration(
                                // shape: BoxShape.circle,
                                // color: Color(0xff7905F5),
                                // ),
                                // child: IconButton(
                                // onPressed: () async {
                                // setState(() {
                                // widget.fav =
                                // !widget.fav; // Toggle the state
                                // });
                                // if (widget.fav) {
                                // FirebaseFirestore.instance
                                // .collection('users')
                                // .doc(widget.ID)
                                // .get()
                                // .then((DocumentSnapshot
                                // documentSnapshot) async {
                                // if (documentSnapshot.exists) {
                                // Map<String, dynamic> data =
                                // documentSnapshot.data()
                                // as Map<String, dynamic>;
                                // try {
                                // DocumentReference favDocRef =
                                // await FirebaseFirestore
                                // .instance
                                // .collection('Favourite')
                                // .doc(widget
                                // .useremail); // Add the data to the main document in Favourite
                                // print(
                                // "Favourite document created with ID: ${favDocRef.id}");
                                // await favDocRef
                                // .collection(
                                // "fav1") // Subcollection name
                                // .doc(widget
                                // .ID) // Use the same ID as in the "Sell" collection
                                // .set(
                                // data); // Add the data from the "Sell" collection
                                // print(
                                // "Subcollection 'fav1' created with document ID: ${widget.ID}");
                                // FirebaseFirestore.instance
                                // .collection(
                                // 'Favourite') // Replace with your collection name
                                // .doc(widget.useremail)
                                // .collection("fav1")
                                // .doc(widget
                                // .ID) // Replace with the document ID you want to update
                                // .update({'fav1': true})
                                // .then((_) => print(
                                // "Favorite updated to true"))
                                // .catchError((error) => print(
                                // "Failed to update favorite: $error"));
                                // } catch (error) {
                                // print(
                                // "Error during creation of Favourite document or subcollection: $error");
                                // }
                                // } else {
                                // print(
                                // "Document does not exist in Sell collection");
                                // }
                                // }).catchError((error) {
                                // print(
                                // "Failed to retrieve document from Sell collection: $error");
                                // });
                                // } else {}
                                // },
                                // icon: Icon(
                                // widget.fav
                                // ? Icons.favorite_rounded
                                // : Icons.favorite_border_outlined,
                                // color: Colors.white,
                                // size: height / 30,
                                // )),
                                // ),
                            
                            
                            
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return ChatPage(
                                          chatPartnerEmail: widget.ID,
                                          chatPartnername: widget.name,
                                          chatPartnerimage: widget.image,
                                          onlinecheck: widget.onlinecheck,
                                          statecolour: widget.statecolour,
                                          who: 'Ambassdor',
                                        );
                                      },
                                    ));
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xff7905F5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: ClipRRect(
                                          child: Image.asset(
                                            "images/Vector.png",
                                            height: height / 30,
                                          ),
                                        ),
                                      )),
                                ),
                                     SizedBox(
       width: width / 40,
     ),
                                GestureDetector(
                                  onTap: () {
                                    
          showModalBottomSheet(
   isScrollControlled: true,
   shape: RoundedRectangleBorder(
     borderRadius: BorderRadius.only(
       topLeft: Radius.circular(50),
       topRight: Radius.circular(50),
     ),
   ),
   backgroundColor: Colors.transparent,
   context: context,
   builder: (context) {
     return sharepage(
       blockemail: widget.ID,
       blockname: widget.name,
       blockpic: widget.image,
     );
   },
 );                         },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xff7905F5),
                                    ),
                                    child:Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Icon(Icons.share,color: Colors.white,size: height/30,),
                                    )
                                   
                                   
                                   
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height / 25),
                      // Description
                      if (widget.description.isNotEmpty) ...[
                        Text(
                          'Description',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontFamily: "defaultfontsbold",
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        SizedBox(height: height / 150),
                        Text(
                          widget.description,
                          style: TextStyle(
                              color: const Color(0xff565656),
                              fontFamily: "defaultfonts",
                              fontSize: 16),
                        ),
                        SizedBox(height: height / 50),
                      ], // Interests
                      Text(
                        'Interest',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontFamily: "defaultfontsbold",
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      SizedBox(
                        height: height / 150,
                      ),
                      Center(
                        child: Wrap(
                            spacing: width / 90,
                            runSpacing: height / 70,
                            children: List<Widget>.generate(
                              widget.labels.length,
                              (int index) {
                                return _buildInterestChip(
                                    context,
                                    widget.labels[index],
                                    widget.iconss[index],
                                    height);
                              },
                            )),
                      ),
                      SizedBox(height: height * 0.03),
                      // Achen's Info
                      Text(
                        "${widget.name.toUpperCase()}'s Info",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontFamily: "defaultfontsbold",
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      _buildInfoRow(context, 'Age', widget.age.toString()),
                      _buildInfoRow(context, 'Height', '${widget.height}'),
                      _buildInfoRowlanugaes(
                          context, 'Languages', widget.languaes),
                      SizedBox(height: height / 90),
                      if (widget.education.isNotEmpty) ...[
                        Text(
                          'Education',
                          style: TextStyle(
                              color: const Color(0xff565656),
                              fontFamily: "defaultfonts",
                              fontSize: 16),
                        ),
                        SizedBox(height: height / 90),
                        Text(
                          widget.education,
                          style: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontFamily: "defaultfonts",
                              fontSize: 16),
                        ),

                        SizedBox(height: height / 50),
                        // Gallery
                      ],
                      Text(
                        'Gallery',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontFamily: "defaultfontsbold",
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.imagecollection.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: width * 0.02,
                          mainAxisSpacing: height * 0.02,
                          childAspectRatio: 1.0,
                        ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) {
                                  return FullScreenImageView(
                                      imagePath: widget.imagecollection[index]);
                                },
                              ));
                            },
                            child: Container(
                              height: height / 10,
                              width: width / 10,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          widget.imagecollection[index]),
                                      fit: BoxFit.cover)),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: height / 50,
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      // Name and Location
    );
  }

  Widget _buildInfoRowlanugaes(
      BuildContext context, String title, List<dynamic> info) {
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(top: height / 90),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                color: const Color(0xff565656),
                fontFamily: "defaultfonts",
                fontSize: 16),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...info
                  .map((hobby) => Text(
                        " ${hobby}",
                        style: TextStyle(
                            color: const Color(0xff565656),
                            fontFamily: "defaultfonts",
                            fontSize: 16),
                      ))
                  .toList(),
            ],
          ),
        ],
      ),
    );
  }

  // Build Interest Chip
  Widget _buildInterestChip(
      BuildContext context, String label, int iconname, final height) {
    return Chip(
        side: BorderSide(color: Colors.transparent),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        avatar: Icon(
          IconData(iconname, fontFamily: 'MaterialIcons'),
          color: Color(0xff565656),
        ), // Ensure the correct font family
        label: Text(
          label,
          style: TextStyle(
              color: const Color(0xff565656),
              fontFamily: "defaultfontsbold",
              fontSize: 15),
        ),
        backgroundColor: Color(0xffD9D9D9));
  }

  // Build Info Row
  Widget _buildInfoRow(BuildContext context, String title, String info) {
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(top: height / 90),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                color: const Color(0xff565656),
                fontFamily: "defaultfonts",
                fontSize: 16),
          ),
          Text(
            info,
            style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontFamily: "defaultfonts",
                fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class FullScreenImageView extends StatelessWidget {
  final String imagePath;

  const FullScreenImageView({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Hero(
          tag: imagePath, // Use a Hero widget for smooth transition
          child: Image.network(imagePath, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
