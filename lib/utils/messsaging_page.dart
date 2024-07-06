// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../firebaseMessaging/firebase_notification.dart';



/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.


/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;





// Crude counter to make messages unique
int _messageCount = 0;

/// The API endpoint here accepts a raw FCM payload for demonstration purposes.
String constructFCMPayload(String? token) {
  _messageCount++;
  return jsonEncode({
    'token': token,
    'data': {
      'via': 'FlutterFire Cloud Messaging!!!',
      'count': _messageCount.toString(),
    },
    'notification': {
      'title': 'Hello FlutterFire!',
      'body': 'This notification (#$_messageCount) was created via FCM!',
    },
  });
}

/// Renders the example application.
class Application extends StatefulWidget {
  const Application({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Application();
}

class _Application extends State<Application> {
  String? _token;
  final String _webPushkey="BA-m5T9IN4uTssSRYh4BToqLHpnN8ZYiX2P3Z6yx0HudUdFH42s_50umMjeImwFOf-ipTEl3RoQIqElsOqxPhTk";

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        Navigator.pushNamed(
          context,
          '"',
        );
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      var androidPlatformSpecifics = const AndroidNotificationDetails('default_notification_channel_id',
        'default_notification_channel_id',
        autoCancel:  true,
        importance: Importance.max,
        priority: Priority.high,
        icon: "launch_background"

      );

      var iosPlatformSpecifics = const IOSNotificationDetails();

      var platformChannelSpecifics =  NotificationDetails(android: androidPlatformSpecifics, iOS: iosPlatformSpecifics);

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        // description
        importance: Importance.high,
      );

      if (kDebugMode) {
        print("printing message in app (messaging page)");
      }
      RemoteNotification? notification = message.notification;


      await NotificationHandler.flutterlocalNotificationplugin.show(0, notification!.title, notification.body, platformChannelSpecifics, payload: 'My payload' );

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

    FirebaseMessaging.instance.getToken(vapidKey: _webPushkey).then((value) {
      _token = value;

      if (kDebugMode) {
        print("token $value");
      }
    });
  }



  Future<void> sendPushMessage() async {
    if (_token == null) {
      if (kDebugMode) {
        print('Unable to send FCM message, no token exists.');
      }
      return;
    }

    try {
      await http.post(
        Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: constructFCMPayload(_token),
      );
      if (kDebugMode) {
        print('FCM request for device sent!');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> onActionSelected(String value) async {
    switch (value) {
      case 'subscribe':
        {
          if (kDebugMode) {
            print(
            'FlutterFire Messaging Example: Subscribing to topic "fcm_test".',
          );
          }
          await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
          if (kDebugMode) {
            print(
            'FlutterFire Messaging Example: Subscribing to topic "fcm_test" successful.',
          );
          }
        }
        break;
      case 'unsubscribe':
        {
          if (kDebugMode) {
            print(
            'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test".',
          );
          }
          await FirebaseMessaging.instance.unsubscribeFromTopic('fcm_test');
          if (kDebugMode) {
            print(
            'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test" successful.',
          );
          }
        }
        break;
      case 'get_apns_token':
        {
          if (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS) {
            if (kDebugMode) {
              print('FlutterFire Messaging Example: Getting APNs token...');
            }
            String? token = await FirebaseMessaging.instance.getAPNSToken();
            if (kDebugMode) {
              print('FlutterFire Messaging Example: Got APNs token: $token');
            }
          } else {
            if (kDebugMode) {
              print(
              'FlutterFire Messaging Example: Getting an APNs token is only supported on iOS and macOS platforms.',
            );
            }
          }
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cloud Messaging'),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: onActionSelected,
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: 'subscribe',
                    child: Text('Subscribe to topic'),
                  ),
                  const PopupMenuItem(
                    value: 'unsubscribe',
                    child: Text('Unsubscribe to topic'),
                  ),
                  const PopupMenuItem(
                    value: 'get_apns_token',
                    child: Text('Get APNs token (Apple only)'),
                  ),
                ];
              },
            ),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            onPressed: sendPushMessage,
            backgroundColor: Colors.white,
            child: const Icon(Icons.send),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: const [

            ],
          ),
        ),
      ),
    );
  }
}

/// UI Widget for displaying metadata.
class MetaCard extends StatelessWidget {
  final String _title;
  final Widget _children;

  // ignore: public_member_api_docs
  const MetaCard(this._title, this._children, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Text(_title, style: const TextStyle(fontSize: 18)),
              ),
              _children,
            ],
          ),
        ),
      ),
    );
  }
}