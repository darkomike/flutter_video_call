
import 'dart:convert';


import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:video_call_app/firebaseMessaging/firebase_notification.dart';
import 'package:video_call_app/utils/messsaging_page.dart';

// ignore: import_of_legacy_library_into_null_safe


class FirebaseNotification{
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static BuildContext? mycontext;



  void setupFirebase(BuildContext context){
    NotificationHandler.initNotification(context);
    Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AAAAdjD7fas:APA91bGqqQ93v93akxGAL3GWfCH2nGNzsQGBMcuES7oUl4iPIETfmcWK2z9Tet-eJnuGZKuP4wK3169rpVEqID9b-h7tpIaQwIG7myQ23VERhFada2jsbJ7agfXNRo4mNes4EWidKTis',
        appId: '1:1032110152454:android:2abfe1262c9050cd041c87',
        messagingSenderId: '1032110152454',
        projectId: 'video-call-flutter-7c155',
      ),
    );
    firebaseCloudMessagingListener(context);


    mycontext = context;
  }

  void firebaseCloudMessagingListener(BuildContext context) {
    // _messaging.requestPermission(const IosNotificationSettings(sound: true, badge: true,alert:  true));
    // _messaging.onIosSettingsRegistered.listen((event) {(print('setting registered: ${event}')); });

    //get token
    _messaging.getToken().then((value){



      if (kDebugMode) {
        print("FirebaseToken : $value");
      }
    });


    //subcribe to topic

    // ignore: avoid_print
    _messaging.subscribeToTopic("ME").whenComplete(() => print("subscribe ok"));

    FirebaseMessaging.onBackgroundMessage(fcmBackgroundMessageHandler) ;

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("printing message when in app (notification handler)");
      }
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,

              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('A new onMessageOpenedApp event was published!');
      }
      Navigator.pushNamed(
        context,
        '/message',

      );
    });



  }







   Future<void> fcmBackgroundMessageHandler(RemoteMessage message) async {

//    showNotification(message['notification']['title'].toString(),message['notification']['body'].toString());
    showNotification("ME", "YES");

    if (kDebugMode) {
      print("messageReceived " +json.encode(message));
    }





    return Future<void>.value();

  }

  static Future<void> showNotification(title, body) async {
    var androidplatformspecifics = const AndroidNotificationDetails('default_notification_channel_id',
      'default_notification_channel_id',
      autoCancel:  true,
      importance: Importance.max,
      priority: Priority.high,

    );

    var iosPlatformSpecifics = const IOSNotificationDetails();

    var platformChannelSpecifics =NotificationDetails(android: androidplatformspecifics, iOS: iosPlatformSpecifics);

    await NotificationHandler.flutterlocalNotificationplugin.show(0, title, body, platformChannelSpecifics, payload: 'My payload' );


  }


  static Future<void> showLicenseNotification(title, body) async {
    var androidplatformspecifics = const AndroidNotificationDetails('default_notification_channel_id',
      'default_notification_channel_id',
      autoCancel:  true,
      importance: Importance.max,
      priority: Priority.high,

    );

    var iosPlatformSpecifics = const IOSNotificationDetails();

    var platformChannelSpecifics =NotificationDetails(android: androidplatformspecifics, iOS: iosPlatformSpecifics);

    await NotificationHandler.flutterlocalNotificationplugin.show(0, title, body, platformChannelSpecifics, payload: 'My payload' );


  }







}