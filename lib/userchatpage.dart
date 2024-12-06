import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/ambassdor/chatpage.dart';
import 'package:datingapp/ambassdor/olduser/ambassdorshowchat.dart';
import 'package:datingapp/ambassdor/olduser/userprofile.dart';
import 'package:datingapp/chatpage.dart';
import 'package:datingapp/history.dart';
import 'package:datingapp/push_notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String chatPartnerEmail;
  final String chatPartnername;
  final String chatPartnerimage;
  final String onlinecheck;
  final Color statecolour;
  final String who;

  ChatPage(
      {required this.chatPartnerEmail,
      required this.who,
      required this.chatPartnername,
      required this.chatPartnerimage,
      required this.onlinecheck,
      required this.statecolour});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with AutomaticKeepAliveClientMixin {
    bool get wantKeepAlive => true;

  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   final ScrollController _scrollController = ScrollController();
     bool _hasScrolledToBottom = false;
final FocusNode _messageFocusNode = FocusNode();

 bool _userIsScrolling = false;
  void _sendMessage() async {
    final currentUser = _auth.currentUser!;
    if (_messageController.text.isNotEmpty) {
      final messageData = {
        'sender': currentUser.email,
        'receiver': widget.chatPartnerEmail,
        'message': _messageController.text,
        'isImage': false,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection("chats")
          .doc(currentUser.email)
          .set({
        "name": "",
      });

      await FirebaseFirestore.instance
          .collection("chats")
          .doc(widget.chatPartnerEmail)
          .set({
        "name": "",
      });

      await FirebaseFirestore.instance
          .collection("chats")
          .doc(currentUser.email)
          .collection('history')
          .doc(widget.chatPartnerEmail)
          .set({
        "name": "",
        'lastmessagetime': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance
          .collection("chats")
          .doc(widget.chatPartnerEmail)
          .collection('history')
          .doc(currentUser.email)
          .set({
        "name": "",
        'lastmessagetime': FieldValue.serverTimestamp(),
      });
      await _firestore
          .collection('chats')
          .doc(currentUser.email)
          .collection('history')
          .doc(widget.chatPartnerEmail)
          .collection('messages')
          .add(messageData);

      await _firestore
          .collection('chats')
          .doc(widget.chatPartnerEmail)
          .collection('history')
          .doc(currentUser.email)
          .collection('messages')
          .add(messageData);

      _messageController.clear();

      final userSnapshot = await _firestore
          .collection('users')
          .doc(widget.chatPartnerEmail)
          .get();
      final ambassadorSnapshot = await _firestore
          .collection('Ambassdor')
          .doc(widget.chatPartnerEmail)
          .get();
      if (userSnapshot.exists) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(widget.chatPartnerEmail)
            .update(
                {'deviceToken': await FirebaseMessaging.instance.getToken()});

        final userSnapshot =
            await _firestore.collection('users').doc(currentUser.email).get();
        final deviceToken = userSnapshot.data()?['deviceToken'];

        print("asas ${userSnapshot.data()?['deviceToken']}");

        if (deviceToken != null) {
          await PushNotificationService.sendNotificationToUser(
              deviceToken, context, widget.chatPartnerEmail);
        }
      } else if (ambassadorSnapshot.exists) {
       
               await FirebaseFirestore.instance
            .collection("Ambassdor")
            .doc(widget.chatPartnerEmail)
            .update(
                {'deviceToken': await FirebaseMessaging.instance.getToken()});

        final ambassadorSnapshot =
            await _firestore.collection('Ambassdor').doc(currentUser.email).get();
        final deviceToken = ambassadorSnapshot.data()?['deviceToken'];

        print("asas ${ambassadorSnapshot.data()?['deviceToken']}");

        if (deviceToken != null) {
          await PushNotificationService.sendNotificationToUser(
              deviceToken, context, widget.chatPartnerEmail);
        }
       
       
       
      }
    }
  }

  Future<void> _sendImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      File file = File(image.path);

      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref('chat_images/$fileName')
          .putFile(file);

      String downloadUrl = await snapshot.ref.getDownloadURL();
      final userSnapshot = await _firestore
          .collection('users')
          .doc(widget.chatPartnerEmail)
          .get();

      final ambassadorSnapshot = await _firestore
          .collection('Ambassdor')
          .doc(widget.chatPartnerEmail)
          .get();

      if (userSnapshot.exists) {
        print('Chat partner found in the user collection.');
      }

      final imageMessageData = {
        'sender': _auth.currentUser!.email,
        'receiver': widget.chatPartnerEmail,
        'message': downloadUrl,
        'isImage': true,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('chats')
          .doc(_auth.currentUser!.email)
          .collection('history')
          .doc(widget.chatPartnerEmail)
          .collection('messages')
          .add(imageMessageData);

      await _firestore
          .collection('chats')
          .doc(widget.chatPartnerEmail)
          .collection('history')
          .doc(_auth.currentUser!.email)
          .collection('messages')
          .add(imageMessageData);

     if (userSnapshot.exists) {
       await FirebaseFirestore.instance
           .collection("users")
           .doc(widget.chatPartnerEmail)
           .update(
               {'deviceToken': await FirebaseMessaging.instance.getToken()});
       final userSnapshot =
           await _firestore.collection('users').doc(_auth.currentUser!.email).get();
       final deviceToken = userSnapshot.data()?['deviceToken'];
       print("asas ${userSnapshot.data()?['deviceToken']}");
       if (deviceToken != null) {
         await PushNotificationService.sendNotificationToUser(
             deviceToken, context, widget.chatPartnerEmail);
       }
     } else if (ambassadorSnapshot.exists) {
      
              await FirebaseFirestore.instance
           .collection("Ambassdor")
           .doc(widget.chatPartnerEmail)
           .update(
               {'deviceToken': await FirebaseMessaging.instance.getToken()});
       final ambassadorSnapshot =
           await _firestore.collection('Ambassdor').doc(_auth.currentUser!.email).get();
       final deviceToken = ambassadorSnapshot.data()?['deviceToken'];
       print("asas ${ambassadorSnapshot.data()?['deviceToken']}");
       if (deviceToken != null) {
         await PushNotificationService.sendNotificationToUser(
             deviceToken, context, widget.chatPartnerEmail);
       }
      
      
      
     }
   }
  }

  @override
  void initState() {
    super.initState();
    _messageFocusNode.addListener(() {
    if (_messageFocusNode.hasFocus) {
      // Delay to ensure ListView stabilizes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  });
    // Listen for user scrolling

  }

  @override
  void dispose() {
      _messageFocusNode.dispose();

    super.dispose();
  }
  void _scrollToBottom() {
  // Make sure the scroll controller is attached to the ListView
  if (_scrollController.hasClients) {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent, // Scroll to the bottom
      duration: Duration(milliseconds: 300), // Duration of the scroll animation
      curve: Curves.easeInOut, // Smooth scrolling
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height / 400,
        foregroundColor: Color.fromARGB(255, 121, 5, 245),
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 121, 5, 245),
        surfaceTintColor: Color.fromARGB(255, 121, 5, 245),
      ),
      backgroundColor: Color.fromARGB(255, 121, 5, 245),
      body: Stack(
        children: [
          // Purple Top Section (Header)
          Container(
            height: height * 0.4, // Adjust height for header
            width: width,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 121, 5, 245),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: width / 20, right: width / 20),
              child: Column(
                children: [
                  // Row with Back button and Chat title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(widget.chatPartnerimage),
                            radius: 26,
                          ),
                          SizedBox(
                            width: width / 40,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.chatPartnername,
                                style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    fontFamily: "defaultfontsbold",
                                    fontSize: 20),
                              ),
                              Text(
                                widget.onlinecheck,
                                style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    fontFamily: "defaultfonts",
                                    fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (widget.onlinecheck == "Online") ...[
                        SizedBox(
                          width: width / 10,
                        )
                      ],
                      Container(
                        height: height / 10,
                        width: width / 10,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: PopupMenuButton<int>(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          offset: Offset(0, 100),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          icon: Icon(
                            Icons.more_vert,
                            size: 20,
                            color: Color(0xff7905F5),
                          ),
                          onSelected: (value) async {
                            // Handle actions based on the selected value
                            switch (value) {
                              case 1:
                                final userSnapshot = await _firestore
                                    .collection('users')
                                    .doc(widget.chatPartnerEmail)
                                    .get();
                                final ambassadorSnapshot = await _firestore
                                    .collection('Ambassdor')
                                    .doc(widget.chatPartnerEmail)
                                    .get();
                                if (userSnapshot.exists) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) {
                                      return userprofile(
                                          email: widget.chatPartnerEmail);
                                    },
                                  ));
                                } else if (ambassadorSnapshot.exists) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) {
                                      return ambassdorshowchat(
                                          useremail: widget.chatPartnerEmail);
                                    },
                                  ));
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Text(
                                    'This User not Available',
                                    style: TextStyle(color: Colors.red),
                                  )));
                                }
                                break;
                              case 2:
                                print("Option 2 selected");
                                break;
                              case 3:
                                print("Option 3 selected");
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<int>>[
                            PopupMenuItem<int>(
                                value: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.person_2_outlined,
                                      color: Color(0xff565656),
                                      size: 25,
                                    ),
                                    SizedBox(
                                      width: width / 30,
                                    ),
                                    Text(
                                      "View Profile",
                                      style: TextStyle(
                                        color: Color(0xff565656),
                                        fontSize: 18,
                                        fontFamily: "defaultfontsbold",
                                      ),
                                    )
                                  ],
                                )),
                            PopupMenuItem<int>(
                              value: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.call_outlined,
                                    color: Color(0xff565656),
                                    size: 25,
                                  ),
                                  SizedBox(
                                    width: width / 30,
                                  ),
                                  Text(
                                    "Voice Call",
                                    style: TextStyle(
                                      color: Color(0xff565656),
                                      fontSize: 18,
                                      fontFamily: "defaultfontsbold",
                                    ),
                                  )
                                ],
                              ),
                            ),
                            PopupMenuItem<int>(
                              value: 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.video_call_outlined,
                                    color: Color(0xff565656),
                                    size: 25,
                                  ),
                                  SizedBox(
                                    width: width / 30,
                                  ),
                                  Text(
                                    "Video Call",
                                    style: TextStyle(
                                      color: Color(0xff565656),
                                      fontSize: 18,
                                      fontFamily: "defaultfontsbold",
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // White Container for Chat Messages
          Padding(
            padding: EdgeInsets.only(top: height / 7),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffF4EBFD),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height / 40,
                  ),


Expanded(
  child: StreamBuilder<QuerySnapshot>(
    stream: _firestore
        .collection('chats')
        .doc(_auth.currentUser!.email)
        .collection('history')
        .doc(widget.chatPartnerEmail)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }

      final messages = snapshot.data!.docs;
      Map<String, List<QueryDocumentSnapshot>> groupedMessages = {};

      // Group messages by date
      for (var message in messages) {
        if (message['timestamp'] != null) {
          var dateTime = (message['timestamp'] as Timestamp).toDate().toLocal();
          var dateKey = DateFormat('yyyy-MM-dd').format(dateTime);
          if (!groupedMessages.containsKey(dateKey)) {
            groupedMessages[dateKey] = [];
          }
          groupedMessages[dateKey]!.add(message);
        }
      }

      List<String> sortedDates = groupedMessages.keys.toList()
        ..sort((a, b) => a.compareTo(b)); // Sort dates in ascending order

      // Check if we need to scroll to the bottom after new messages


 WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollToBottom();
      }
    });




      return NotificationListener<ScrollNotification>(
       
       
       
         onNotification: (scrollNotification) {
    if (scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent) {
      // The user is at the bottom, mark the scroll state
      _hasScrolledToBottom = true;
    }
    return false; // Allow other notifications to be handled normally
  },
       
       
       
        child: ListView.builder(
          key: PageStorageKey<String>('messageList'),
          controller: _scrollController,
          reverse: false, // Keeps the oldest messages at the top and newest at the bottom
          itemCount: sortedDates.fold(0, (sum, key) => sum! + groupedMessages[key]!.length + 1), // Headers + Messages
          itemBuilder: (context, index) {
            int currentIndex = 0;

            for (var date in sortedDates) {
              // Add date header
              if (currentIndex == index) {
                var today = DateTime.now();
                var yesterday = today.subtract(Duration(days: 1));
                var headerText = date == DateFormat('yyyy-MM-dd').format(today)
                    ? 'Today'
                    : date == DateFormat('yyyy-MM-dd').format(yesterday)
                        ? 'Yesterday'
                        : DateFormat('MMMM d, yyyy').format(DateTime.parse(date));

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      headerText,
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: "defaultfontsbold",
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }
              currentIndex++;

              // Add sorted messages under this date header
              final messagesForDate = groupedMessages[date]!;
              messagesForDate.sort((a, b) => (a['timestamp'] as Timestamp)
                  .toDate()
                  .compareTo((b['timestamp'] as Timestamp).toDate())); // Sort messages by time ascending

              if (index - currentIndex < messagesForDate.length) {
                final message = messagesForDate[index - currentIndex];
                bool isSender = message['sender'] == _auth.currentUser!.email;

                return Align(
                  alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 4,
                      bottom: 4,
                      left: isSender ? MediaQuery.of(context).size.width / 3 : 10,
                      right: isSender ? 10 : MediaQuery.of(context).size.width / 3,
                    ),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSender ? const Color(0xffEAEAEA) : const Color(0xffFFFFFF),
                      borderRadius: isSender
                          ? BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            )
                          : BorderRadius.only(
                              bottomRight: Radius.circular(15),
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                    ),
                    child: Column(
                      crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        message['isImage'] == true
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => FullScreenImagePage(imageUrl: message['message']),
                                  ));
                                },
                                child: Image.network(
                                  message['message'],
                                  fit: BoxFit.contain,
                                  width: MediaQuery.of(context).size.width / 2,
                                  height: MediaQuery.of(context).size.height / 5,
                                ),
                              )
                            : Text(
                                message['message'],
                                style: TextStyle(
                                  color: const Color(0xff565656),
                                  fontFamily: "defaultfonts",
                                  fontSize: 12,
                                ),
                              ),
                        SizedBox(height: 5),
                        Text(
                          message['timestamp'] != null
                              ? DateFormat('hh:mm a').format(
                                  (message['timestamp'] as Timestamp).toDate().toLocal())
                              : '',
                          style: TextStyle(
                            color: const Color(0xff979292),
                            fontFamily: "defaultfontsbold",
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              currentIndex += messagesForDate.length;
            }

            return SizedBox.shrink(); // Fallback for invalid index
          },
        ),
      );
    },
  ),
),

// Message Input Section
Padding(
  padding: EdgeInsets.only(
    left: width / 15,
    bottom: height / 60,
    right: width / 40,
    top: height / 60
  ),
  child: Row(
    children: [
      Expanded(
        child: TextField(
          focusNode: _messageFocusNode,
          maxLines: 1,
          controller: _messageController,
          style: TextStyle(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontFamily: "defaultfonts",
              fontSize: height / 50),
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: _sendImage,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff979292),
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),
            ),
            hintText: 'Type a message...',
            hintStyle: TextStyle(
                color: const Color(0xff979292),
                fontFamily: "defaultfontsbold",
                fontSize: 14),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff979292)),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff979292)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      IconButton(
        icon: Icon(
          size: 30,
          Icons.send,
          color: Color(0xff979292),
        ),
 onPressed: () {
    _sendMessage(); // Send the message
    _scrollToBottom(); // Scroll to the bottom after sending the message
  },      ),
    ],
  ),
),









                ]
              )

            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;

  FullScreenImagePage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
