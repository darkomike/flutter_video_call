import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:video_call_app/accept_video_call.dart';
import 'package:video_call_app/firebaseMessaging/firebase_notification.dart';
import 'package:video_call_app/home_page.dart';
import 'package:video_call_app/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:video_call_app/model/video_model.dart';
import 'package:video_call_app/utils/messsaging_page.dart';



class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  var androidPlatformSpecifics = const AndroidNotificationDetails('default_notification_channel_id',
      'default_notification_channel_id',
      autoCancel:  false,
      importance: Importance.max,
      priority: Priority.high,
      icon: "launch_background"

  );

  var iosPlatformSpecifics = const IOSNotificationDetails();

  var platformChannelSpecifics =  NotificationDetails(android: androidPlatformSpecifics, iOS: iosPlatformSpecifics);

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  await NotificationHandler.flutterlocalNotificationplugin.show(0, message.notification!.title, message.notification!.body, platformChannelSpecifics, payload: 'My payload' );

}

firebaseCloudMessaging(BuildContext context) async {
  await Firebase.initializeApp();




  final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
  BehaviorSubject<ReceivedNotification>();

  final BehaviorSubject<String?> selectNotificationSubject =
  BehaviorSubject<String?>();

  const MethodChannel platform =
  MethodChannel('dexterx.dev/flutter_local_notifications_example');

  String _webPushkey="BA-m5T9IN4uTssSRYh4BToqLHpnN8ZYiX2P3Z6yx0HudUdFH42s_50umMjeImwFOf-ipTEl3RoQIqElsOqxPhTk";

  try{



    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      var androidPlatformSpecifics = const AndroidNotificationDetails('default_notification_channel_id',
          'default_notification_channel_id',
          autoCancel:  true,
          importance: Importance.max,
          priority: Priority.high,
          icon: "launch_background"

      );

      var iosPlatformSpecifics = const IOSNotificationDetails();

      var iosSettings =   IOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          onDidReceiveLocalNotification: (
              int id,
              String? title,
              String? body,
              String? payload,
              ) async {
            didReceiveLocalNotificationSubject.add(
              ReceivedNotification(
                id: id,
                title: title,
                body: body,
                payload: payload,
              ),
            );
          });

      final InitializationSettings initializationSettings = InitializationSettings(

        iOS: iosSettings,

      );

      void selectNotification(String payload) async {
        if (payload != null) {
          debugPrint('notification payload: $payload');




        }
      }

      var platformChannelSpecifics =  NotificationDetails(android: androidPlatformSpecifics, iOS: iosPlatformSpecifics);

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: null);

      var details = await flutterLocalNotificationsPlugin
          .getNotificationAppLaunchDetails();
      if (details!.didNotificationLaunchApp) {
        print(details.payload);

        VideoModel videoModel = VideoModel();
        videoModel.roomId = "12345";
        videoModel.callee = "kofi";

         Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (context) => AcceptVideoCall(model: videoModel,)),
        );

      }

      if (kDebugMode) {
        print("printing message in app (messaging page)");
      }


      await NotificationHandler.flutterlocalNotificationplugin.show(0, "video call request", message.notification!.body, platformChannelSpecifics, payload: 'My payload' );



      // flutterLocalNotificationsPlugin.show(
      //   0,
      //   notification!.title,
      //   notification.body,
      //   platformChannelSpecifics,
      //   payload: ""
      //
      // );

    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('A new onMessageOpenedApp event was published!');
      }


    });

    var token = await FirebaseMessaging.instance.getToken(vapidKey: _webPushkey);
    if (kDebugMode) {
      print("token $token");
    }


  }catch(e){
    e.toString();
  }
}

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users').snapshots();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {



    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text("Select a user to start video call", style: TextStyle(fontSize: 12),),),
          body:  StreamBuilder<QuerySnapshot>(
            stream: _usersStream,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }


              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  var users = UserModel.fromJson(json.decode(jsonEncode(data)));
                  return InkWell(
                    onTap: (){

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  MyHomePage(model: users,)),
                      );

                    },
                    child: ListTile(
                      title: Text(users.name!, style:const TextStyle(color: Colors.black,fontSize: 12, fontWeight: FontWeight.bold),),
                      leading:  const SizedBox(
                        width: 30,
                        height: 30,
                        child: Icon(Icons.person, color: Colors.black,),
                      ),

                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      )
     ;
  }

  nameItem(String name){
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all( Radius.circular(8)),
      ),
      child: Row(
        children: [

          const SizedBox(
            width: 30,
            height: 30,
            child: Icon(Icons.person, color: Colors.black,),
          ),

          const SizedBox(width: 10,),
          

          Text(name, style: const TextStyle(color: Colors.black,fontSize: 12, fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }


 sendPush(UserModel model) async {

   var headers = {
     'Authorization': 'key=AAAA8E6PGwY:APA91bEsIeM3RUc11b5_6DAltZFfqIlIEQiL4jjxa6O3GVoAlRp-jv3BwiUcF6fGJonS5KokpbInTfkMeJtpodPSphvRqPGfKDPC6piFnH5nXpASq5L7QBxcb4gzrieMjVwjCQp62PgR',
     'Content-Type': 'application/json'
   };
   var request = http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
   request.body = json.encode({
     "to": model.token,
     "notification": {
       "body": "${model.name} is requesting for a video call",
       "title": "roomid",
       "subtitle": "video call"
     }
   });
   request.headers.addAll(headers);

   http.StreamedResponse response = await request.send();

   if (response.statusCode == 200) {
     print(await response.stream.bytesToString());
   }
   else {
   print(response.reasonPhrase);
   }
 }

}
