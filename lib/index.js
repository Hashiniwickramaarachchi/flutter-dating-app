const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendChatNotification = functions.firestore
  .document("chats/{userId}/history/{chatPartnerId}/messages/{messageId}")
  .onCreate(async (snapshot, context) => {
    const messageData = snapshot.data();

    if (!messageData) {
      console.log("No message data found.");
      return null;
    }

    const sender = messageData.sender;
    const receiver = messageData.receiver;
    const message = messageData.message;
    const isImage = messageData.isImage;

    try {
      // Get the receiver's FCM token from the users collection
      const userDoc = await admin.firestore().collection("users").doc(receiver).get();
      const fcmToken = userDoc.data()?.fcmToken;

      if (!fcmToken) {
        console.log("No FCM token found for the receiver.");
        return null;
      }

      // Build the notification payload
      const payload = {
        notification: {
          title: `New message from ${sender}`,
          body: isImage ? "📷 Photo" : message,
          click_action: "FLUTTER_NOTIFICATION_CLICK",
        },
        data: {
          sender: sender,
          receiver: receiver,
        },
      };

      // Send the notification
      await admin.messaging().sendToDevice(fcmToken, payload);
      console.log("Notification sent successfully.");
    } catch (error) {
      console.error("Error sending notification:", error);
    }

    return null;
  });
