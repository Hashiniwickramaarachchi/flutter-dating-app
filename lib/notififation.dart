import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService{


FirebaseMessaging messaging = FirebaseMessaging.instance;



void requestNotificationPermition()async{

NotificationSettings settings =await  messaging.requestPermission(
alert: true,
announcement:  true,
badge: true,
carPlay: true,
criticalAlert:  true,
provisional:  true,

sound: true,
);

if (settings.authorizationStatus==AuthorizationStatus.authorized) {
  print("user granted permission");


} else if(settings.authorizationStatus==AuthorizationStatus.authorized){
    print("user granted provisional permission");

}else{

  print("User denied permission");
}
}





}