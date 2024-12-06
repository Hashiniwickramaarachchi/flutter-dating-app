import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/userchatpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatHistoryPage extends StatefulWidget {
  final String who;
  ChatHistoryPage({required this.who});

  @override
  _ChatHistoryPageState createState() => _ChatHistoryPageState();
}

class _ChatHistoryPageState extends State<ChatHistoryPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  Map<String, dynamic> usersStatusDetails = {};
  String lastSeenhistory = "Last seen: N/A";
  Color statecolour = Colors.white;

  @override
  void initState() {
    super.initState();
    fetchUsersStatus();
  }

  Future<void> fetchUsersStatus() async {
    DatabaseReference usersStatusRef = _databaseRef.child('status');
    usersStatusRef.once().then((DatabaseEvent event) {
      Map<dynamic, dynamic>? usersStatus =
          event.snapshot.value as Map<dynamic, dynamic>?;
      if (usersStatus != null) {
        Map<String, dynamic> statusMap = {};
        usersStatus.forEach((key, value) {
          String email = key.replaceAll(',', '.');
          statusMap[email] = value;
        });
        setState(() {
          usersStatusDetails = statusMap;
        });
      }
    });
  }

  String capitalizeFirstLetter(String name) {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      // Handle unauthenticated user state (e.g., redirect to login page or show a
      return Center(child: Text('No user is logged in.'));
    }
return FutureBuilder<DocumentSnapshot>(
  future: _firestore.collection('Blocked USers').doc(currentUser.email).get(),
  builder: (context, blockedSnapshot) {
    if (blockedSnapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (blockedSnapshot.hasError) {
      return Center(child: Text('Error: ${blockedSnapshot.error}'));
    }

    // Fetch the blocked users array
    List<String> blockedEmails = [];
    if (blockedSnapshot.hasData && blockedSnapshot.data!.exists) {
      final blockedData = blockedSnapshot.data!.data() as Map<String, dynamic>?;
      if (blockedData != null && blockedData["This Id blocked Users"] != null) {
        blockedEmails = List<String>.from(blockedData["This Id blocked Users"]);
      }
    }



        return StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('chats')
              .doc(currentUser.email)
              .collection('history')
              .orderBy('lastmessagetime', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
        
             final histories = snapshot.data?.docs.where((doc) {
          final chatPartnerEmail = doc.id;
          return !blockedEmails.contains(chatPartnerEmail);
        }).toList();

        if (histories == null || histories.isEmpty) {
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
        
                if (usersStatusDetails.containsKey(chatPartnerEmail)) {
                  final userStatus = usersStatusDetails[chatPartnerEmail];
                  isOnline = userStatus['status'] == 'online';
                  if (isOnline) {
                    lastSeen = "Online";
                    lastSeenhistory = "Online";
                    statecolour = const Color.fromARGB(255, 49, 255, 56);
                  } else {
                    var lastSeenDate =
                        DateTime.fromMillisecondsSinceEpoch(userStatus['lastSeen'])
                            .toLocal();
                    lastSeen =
                        "Last seen: ${DateFormat('MMM d, yyyy h:mm a').format(lastSeenDate)}";
                    lastSeenhistory = lastSeen;
                    statecolour = Colors.white;
                  }
                }
        
                return FutureBuilder<DocumentSnapshot>(
                  future: _firestore
                      .collection('users')
                      .doc(chatPartnerEmail)
                      .get()
                      .then((userSnapshot) async {
                    if (!userSnapshot.exists) {
                      return await _firestore
                          .collection('Ambassdor')
                          .doc(chatPartnerEmail)
                          .get();
                    }
                    return userSnapshot;
                  }),
                  builder: (context, userSnapshot) {
                    final userData = userSnapshot.data;
                    final chatPartnerProfilePic = userData != null &&
                            userData.exists
                        ? userData['profile_pic']
                        : 'https://tikkurila.com/sites/default/files/styles/scale_crop_extra_large_800_800/public/color_resources/%2390989E.png.webp?itok=IoWz-WwS';
                    final chatPartnerName = userData != null && userData.exists
                        ? capitalizeFirstLetter(userData['name'] ?? 'Unknown')
                        : 'Unknown';
        
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
                        final lastMessage =
                            (messageSnapshot.data?.docs.isNotEmpty ?? false)
                                ? messageSnapshot.data?.docs.first
                                : null;
                        final messageText = lastMessage?['isImage'] == true
                            ? 'Image'
                            : lastMessage?['message'] ?? '';
        
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
                                      backgroundImage:
                                          NetworkImage(chatPartnerProfilePic),
                                    ),
                                    if (isOnline)
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
                                              color: Colors.transparent,
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
                                  Flexible(
                                    child: Text(
                                      chatPartnerName,
                                      style: TextStyle(
                                        color: const Color(0xff565656),
                                        fontFamily: "defaultfontsbold",
                                        fontSize: 16,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    lastMessage?['timestamp'] != null
                                        ? DateFormat('hh:mm a').format(
                                            (lastMessage!['timestamp'] as Timestamp)
                                                .toDate()
                                                .toLocal())
                                        : '',
                                    style: TextStyle(
                                      color: const Color(0xff979292),
                                      fontFamily: "defaultfontsbold",
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                lastMessage == null
                                    ? 'No messages yet'
                                    : (lastMessage['isImage'] == true
                                        ? 'Image'
                                        : lastMessage['message'] ?? ''),
                                style: TextStyle(
                                  color: const Color(0xff979292),
                                  fontFamily: "defaultfontsbold",
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      chatPartnerEmail: chatPartnerEmail,
                                      chatPartnername: chatPartnerName,
                                      chatPartnerimage: chatPartnerProfilePic,
                                      onlinecheck: lastSeen,
                                      statecolour: Colors.white,
                                      who: widget.who,
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
    );
  }
}
