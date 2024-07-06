

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHandler{
static final flutterlocalNotificationplugin = FlutterLocalNotificationsPlugin();
static BuildContext? mycontext;


static void initNotification(BuildContext context){
  mycontext = context;

  var initAndroid = const AndroidInitializationSettings("mylauncher");
  var initIOS = const IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  var initsettings = InitializationSettings(android: initAndroid, iOS: initIOS);

  flutterlocalNotificationplugin.initialize(initsettings, onSelectNotification: onSelectNotification);


}

  static Future onSelectNotification(String? payload) async{
    if(payload!= null){
      if (kDebugMode) {
        print('notification payload: '+payload);
      }
    }
  }

  static Future onDidReceiveLocalNotification(int? id, String? title, String? body, String? payload) async{
  showDialog(context: mycontext!,
  builder: (BuildContext context) => CupertinoAlertDialog(
    title: Text(title!),
    content: Text(body!),
    actions: [
      CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('OK'), onPressed: (){

            Navigator.of(context,rootNavigator: true).pop();
      },)
    ],
  )
  );
  }
}