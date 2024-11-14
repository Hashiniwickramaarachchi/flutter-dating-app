import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/userchatpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatHistoryPage extends StatefulWidget {
  String who;
  ChatHistoryPage({
required this.who
  }
  );

  @override
  _ChatHistoryPageState createState() => _ChatHistoryPageState();
}

class _ChatHistoryPageState extends State<ChatHistoryPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  Map<String, dynamic> usersStatusDetails = {}; // Change from List to Map
String lastSeenhistory = "Last seen: N/A";
Color statecolour = Colors.white;
  @override
  void initState() {
    super.initState();
    fetchUsersStatus(); // Call the function in initState
  }
  Future<void> fetchUsersStatus() async {
    DatabaseReference usersStatusRef = _databaseRef.child('status');

    usersStatusRef.once().then((DatabaseEvent event) {
      Map<dynamic, dynamic>? usersStatus =
          event.snapshot.value as Map<dynamic, dynamic>?;

      if (usersStatus != null) {
        Map<String, dynamic> statusMap = {};
        usersStatus.forEach((key, value) {
          // Revert sanitized email (replace ',' back with '.')
          String email = key.replaceAll(',', '.');
          statusMap[email] = value;
        });

        setState(() {
          usersStatusDetails = statusMap; // Store status based on email
        });
      }
    });
  }
  // Future<void> fetchUsersStatus() async {
    // DatabaseReference usersStatusRef = _databaseRef.child('status');
// 
    // usersStatusRef.once().then((DatabaseEvent event) {
      // Map<dynamic, dynamic>? usersStatus =
          // event.snapshot.value as Map<dynamic, dynamic>?;
// 
      // if (usersStatus != null) {
        // List<String> userEmails = [];
// 
        // usersStatus.forEach((key, value) {
          // String email = key.replaceAll(',', '.');
          // userEmails.add(email);
        // });
// 
        // fetchUserDetailsFromFirestore(userEmails, usersStatus);
      // }
    // });
  // }
// 
  // Future<void> fetchUserDetailsFromFirestore(
      // List<String> userEmails, Map<dynamic, dynamic> usersStatus) async {
    // List<Map<String, dynamic>> userDetails = [];
// 
    // for (String email in userEmails) {
      // DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          // await _firestore.collection('users').doc(email).get();
// 
      // if (!userSnapshot.exists) {
      // userSnapshot = await _firestore.collection('Ambassdor').doc(email).get();
    // }    
// 
      // if (userSnapshot.exists) {
        // Map<String, dynamic> userData = userSnapshot.data()!;
        // userData['status'] = usersStatus[email.replaceAll('.', ',')]['status'];
        // userData['lastSeen'] =
            // usersStatus[email.replaceAll('.', ',')]['lastSeen'];
        // userDetails.add(userData);
      // }
    // }
// 
    // if (mounted) {
      // setState(() {
        // usersStatusDetails = userDetails;
      // });
    // }
  // }

  String capitalizeFirstLetter(String name) {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final currentUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('chats')
          .doc(currentUser.email)
          .collection('history')
          .orderBy('lastmessagetime', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final histories = snapshot.data!.docs;

        if (histories.isEmpty) {
          return Center(child: Text('No chat history'));
        }

        return ListView.builder(
          itemCount: histories.length,
          itemBuilder: (context, index) {
            final history = histories[index];
            final chatPartnerEmail = history.id;
                               bool isOnline = false;
                               String lastSeen = "Last seen: N/A";
                               lastSeenhistory = "Last seen: N/A";
       
                               if (usersStatusDetails
                                   .containsKey(chatPartnerEmail)) {
                                 final userStatus =
                                     usersStatusDetails[chatPartnerEmail];
                                 isOnline =
                                     userStatus['status'] == 'online';
       
                                 if (isOnline) {
                                   lastSeen = "Online";
                                   lastSeenhistory = "Online";
                                   statecolour = const Color.fromARGB(
                                       255, 49, 255, 56);
                                 } else {
                                   var lastSeenDate = DateTime
                                           .fromMillisecondsSinceEpoch(
                                               userStatus['lastSeen'])
                                       .toLocal();
                                   lastSeen =
                                       "Last seen: ${DateFormat('MMM d, yyyy h:mm a').format(lastSeenDate)}";
                                   lastSeenhistory = lastSeen;
                                   statecolour = Colors.white;
                                 }
                               }
            // Check if the user's status exists in the usersStatusDetails list
            // Map<String, dynamic>? userStatus = usersStatusDetails.firstWhere(
            //   (element) =>
            //       element.containsKey('email') &&
            //       element['email'] == chatPartnerEmail,
            //   orElse: () => {},
            // );

            // bool isOnline = false;
            // String lastSeen = "Last seen: N/A";

            // if (userStatus.isNotEmpty) {
            //   isOnline = userStatus['status'] == 'online';

            //   if (isOnline) {
            //     lastSeen = "Online";
            //   } else if (userStatus['lastSeen'] != null) {
            //     var lastSeenDate =
            //         DateTime.fromMillisecondsSinceEpoch(userStatus['lastSeen'])
            //             .toLocal();
            //     lastSeen =
            //         "Last seen: ${DateFormat('MMM d, yyyy h:mm a').format(lastSeenDate)}";
            //   }
            // }

            return FutureBuilder<DocumentSnapshot>(
        
      
   future: _firestore.collection('users').doc(chatPartnerEmail).get().then((userSnapshot) async {
    if (!userSnapshot.exists) {
      // If user not found in "users", look in "ambassadors" collection
      return await _firestore.collection('Ambassdor').doc(chatPartnerEmail).get();
    }
    return userSnapshot;
  }),
  builder: (context, userSnapshot) {
    if (!userSnapshot.hasData || userSnapshot.data == null) {
      return SizedBox(); // Skip if user data is not available
    } 
      
      
    

                final userData = userSnapshot.data!;
                final chatPartnerProfilePic =
                    userData['profile_pic'] ?? 'url_to_default_image';
                final chatPartnerName = userData['name'] ??
                    'Unknown'; // Assume 'name' field in the user document

                // Fetch the last message in the chat history
                return StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('chats')
                      .doc(currentUser.email)
                      .collection('history')
                      .doc(chatPartnerEmail)
                      .collection('messages')
                      .orderBy('timestamp', descending: true)
                      .limit(1)
                      .snapshots(),
                  builder: (context, messageSnapshot) {
                    if (!messageSnapshot.hasData ||
                        messageSnapshot.data!.docs.isEmpty) {
                      return SizedBox(); // Skip if no messages
                    }

                    final lastMessage = messageSnapshot.data!.docs.first;

                    return Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 30),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Color(0xffAFAFAF)),
                        ),
                        child: ListTile(
                          leading: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Color(0xff7905F5), width: 2),
                            ),
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundImage: NetworkImage(
                                    chatPartnerProfilePic,
                                  ),
                                ),
                                if (isOnline) // Conditionally show the green dot
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      height: 12,
                                      width: 12,
                                      decoration: BoxDecoration(
                                        color: Color(0xff00D215),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors
                                              .transparent, // Add a white border to match the profile pic e
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                capitalizeFirstLetter(chatPartnerName),
                                style: TextStyle(
                                    color: const Color(0xff565656),
                                    fontFamily: "defaultfontsbold",
                                    fontSize: 16),
                              ),
                              Text(
                                lastMessage['timestamp'] != null
                                    ? DateFormat('hh:mm a').format(
                                        (lastMessage['timestamp'] as Timestamp)
                                            .toDate()
                                            .toLocal())
                                    : '',
                                style: TextStyle(
                                    color: const Color(0xff979292),
                                    fontFamily: "defaultfontsbold",
                                    fontSize: 14),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            lastMessage['isImage']
                                ? 'Image'
                                : lastMessage['message'],
                            style: TextStyle(
                                color: const Color(0xff979292),
                                fontFamily: "defaultfontsbold",
                                fontSize:14),
                          ),
                          onTap: () {
                            // Open the chat page with this chat partner
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  chatPartnerEmail: chatPartnerEmail,
                                  chatPartnername: chatPartnerName,
                                  chatPartnerimage: chatPartnerProfilePic,
                                  onlinecheck: lastSeen, // Use fetched status
                                  statecolour: Colors
                                      .white, who: widget.who, // Update with online state color
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
