import 'dart:convert';

import 'package:datingapp/userchatpage.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/admin/directory_v1.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;
import 'package:provider/provider.dart';

class PushNotificationService {





static Future<String> getAccessToken()async{
final serviceAccountJson=
{
  "type": "service_account",
  "project_id": "appexlove-e7972",
  "private_key_id": "c0e09705abd6802a5446d7b125978b92b493cf95",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDPxOA2b9f1o/wC\nOqrPPsTPud4izA591j3bjZw9WmTLWMCZunRDGgoxDlxGJwy2m/C/m2zDUzzsze+l\n8XlOg+AoatjE39Lc1vi3KzIqXStmmQ2vwRTA64tknpMfjRvFKsSK+vtTcLLBCdyd\nj3wGfrYU8dH+csYDc9HeNCaH12YJSJ4gyzXA6sYRfbYwLv0U/0fdbQ75A7qsfzvr\niCWTn5YpmpGMxbpoPbwiNjVAQdsqnhw/0bDb9lP52vjPE0IDnYxP9ok+9UidfZQJ\nBse27oyf3tAS4cK+aQHED7lHyOgOL33Mg8DBuA957QNmRXb6YeSwXD8FtlTPRl95\nxsoCWwx/AgMBAAECggEAXq+fas+fwO+hyrZH37kAYpaXOI58UDbR6/vmZ0OJye5B\noA2MLIRyfpbH0KS9M39vwTKo539ItbbIb3zTxsds4Z6H+XjzlPdXU8qYyxu4ysIX\nrbA1sBHobcuiyu8456ss9RWachVbMYQ4CYo5gJBAlNz70ZUmzq36x+RGZwPwGWwu\nkfaDqX4ksQc6NWpHaE/qLzV4fSdWRIjkZrvLqo7rqL2fpyqMnS2ODjcLThD2jZar\nRbotH+UKZxs4cVB5EcOeabN9d6z8PnSkrEmQzPp3LYBhfjNe1atshRtGFdXcggGY\n7tI/YiFqApfhtZdXJA9J/Z98vwieP7aHYHRm16GwUQKBgQD9skkTc958nDjfVenc\nh02zqqe6p+QQHe7slMv+nUpATlWwYGxSxl+55pwO0FH0NWjbB8AxCR8MzKoSjsIu\nKvPz5VShw+olkRiFiV5Ke1uGaWMamSJkqMQXqFBOaP2LLQFMwXTVd763hIz6wXuZ\nQn9uq/aKErvfqVDgFfcVNnRf5wKBgQDRp9Uq7qdQqBJnTL6cNQDZ1K18i52v2uYM\nrJeiiDiRcFJ2Np/hVJYtz7snZXO7h97Fba2ebDKjJ3xZINOMDHYzPN701VavcW0P\nqAkhVbS+GAqpYF51sI068tsMv19RdrcKwF/szYdPMtLuDScU5akRIiK+kf2XoL7H\nB3ucP3a7qQKBgQCS7uBeENzKJRzXVQYGgKLjLTLJ65UuNHf9s8xWYjjv966vYZk7\nc8NbgxHdjo/4tbpOKTYJ8HN4UU0rRF14qc3y817J9hM1wMyIAuCGmN2Qgpcwf4Ko\n9AnmfchNMYevRNic4OrO+/SMi4uva8IvKJFvws8edu0zA/hgYLhjI8/Q/wKBgDDf\n/VPK2vp0lAW84FquCIq/h8oXCiWq1CJ0Qc1EEFvnYXHpfhAblf8MBEdE4VwAarB/\nxw+9jXh3hgeJHYfyh8OeFyPgcBrqSFB0DdzVjBMcq6+cpaiuBd6OKv6nxmLJWBaL\njlE4AKk34fBY5Jl8iJNT7+GZSxMECDWByxE7wkQxAoGAS6M3JbML+SJupo1jX1fN\n/9wIs3m4SdEYO44wxmhQLgqKPK0nQEz/vqVDfghxfXXgVWxDqbFkhu2ZUPlqVWt6\nTfCDdz8OGXyhOvvZIc0j8al4IAWGJM12W4++KBosQTc0Wyk0NjuDM9XcuTq2fwPa\nPciDNYOSaao16YaTbhSkCM8=\n-----END PRIVATE KEY-----\n",
  "client_email": "appexlovecloud@appexlove-e7972.iam.gserviceaccount.com",
  "client_id": "115579784969038889688",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/appexlovecloud%40appexlove-e7972.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
};

List<String> scopes=[
'https://www.googleapis.com/auth/firebase.database',
'https://www.googleapis.com/auth/userinfo.email',
'https://www.googleapis.com/auth/firebase.messaging'


];

http.Client client =await auth.clientViaServiceAccount(

auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
scopes,


);

auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(
  auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
  scopes,
  client

); 
client.close();
return credentials.accessToken.data;
}

static sendNotificationToUser(String deviceToken,BuildContext context , String userID) async{

String dropOffDestinationAddress=Provider.of<ChatPage>(context,listen: false).chatPartnername.toString();
String  pickupadress=Provider.of<ChatPage>(context,listen: false).chatPartnerimage.toString();

final String serverAccessTokenKey = await getAccessToken();

String endpointFirebaseCloudMessaging = 'https://fcm.googleapis.com/v1/projects/appexlove-e7972/messages:send';

final Map<String, dynamic> message ={

'message':{
  'token' : deviceToken,
  'notification':{
    'title':'$UserName',
    'body':'New Message From $dropOffDestinationAddress $pickupadress'

  },
  'data':{
'UserID':userID
  }
}
};

final http.Response response = await http.post(


Uri.parse(endpointFirebaseCloudMessaging),
headers: <String, String>{
  "Content-Type":'application/json',
  'Authorization':'Bearer $serverAccessTokenKey'
},
body: jsonEncode(message)
);

if (response.statusCode==200) {
  print('Notification sent successfully');
  
}else{
  print('Notification sent unsuccessfully');


}
}



}