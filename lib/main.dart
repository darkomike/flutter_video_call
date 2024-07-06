


import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rxdart/rxdart.dart';
import 'package:video_call_app/accept_video_call.dart';
import 'package:video_call_app/available_call_provider.dart';
import 'package:video_call_app/firebaseMessaging/firebase_notification.dart';
import 'package:video_call_app/incoming_call_screen.dart';
import 'package:video_call_app/login_data.dart';
import 'package:video_call_app/model/notification_model.dart';
import 'package:video_call_app/model/video_model.dart';
import 'package:video_call_app/token_provider.dart';
import 'package:video_call_app/utils/messsaging_page.dart';
import 'package:video_call_app/utils/routes.dart';

import 'users_list.dart';


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
      print(json.encode(message.data));

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: null);

      var details = await flutterLocalNotificationsPlugin
          .getNotificationAppLaunchDetails();
      if (details!.didNotificationLaunchApp) {

        var notification = NotificationModel.fromJson(json.decode(jsonEncode(message.notification)));

        if(message.notification!.title == "video call"){
          VideoModel model = VideoModel();
          model.callee = "123";
          model.roomId = notification.body;


          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  AcceptVideoCall(model: model,)),
          );
        }




      }


      VideoModel model = VideoModel();
      model.callee = "123";
      model.roomId = message.notification!.title;


      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  const IncomingCall()),
      );



      if (kDebugMode) {
        print("printing message in app (messaging page)");
      }


      await NotificationHandler.flutterlocalNotificationplugin.show(0, "video call request", message.notification!.title, platformChannelSpecifics, payload: 'My payload' );



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


Future<void> main() async {
  List<SingleChildWidget> providers = [
    ChangeNotifierProvider<TokenProvider>(
        create: (_) => TokenProvider()),
    ChangeNotifierProvider<AvailableCall>(
        create: (_) => AvailableCall()),


  ];
  WidgetsFlutterBinding.ensureInitialized();

        runApp(
            MultiProvider(
              providers: providers,
              child:  const MaterialApp(home: MyApp()), //todo:change to MyApp
            ));
  // firebaseCloudMessaging();
  // if(Firebase.apps.isEmpty){
  //   await  Firebase.initializeApp();
  // }


  // try {
  //
  //   LoginData.getLoginStatus().then((value){
  //     //toggle is loading to false
  //
  //
  //     if(value == 1){
  //
  //
  //       runApp(
  //           MultiProvider(
  //             providers: providers,
  //             child:  const MaterialApp(debugShowCheckedModeBanner: false, home:  Users()),
  //           )
  //       );
  //     } else {
  //       runApp(
  //           MultiProvider(
  //             providers: providers,
  //             child:  const MyApp(), //todo:change to MyApp
  //           )
  //       );
  //     }
  //
  //   });
  //
  //
  //
  //
  // } catch (error) {
  //
  //   error.toString();
  // }


}



class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}



class _MyAppState extends State<MyApp> {


  var isLogin;
  var isLoading = true;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
     firebaseCloudMessaging(context);

    isLogin = false;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    try {
      LoginData.getLoginStatus().then((value) => {
        //toggle is loading to false
        setState(() {
          isLoading = false;
        }),

        //if read do not return null
        if (value == 1)
          {
            //set user login status to true
            isLogin = true,
          setState(() {})

          }
        else
          {
            //set user login status to false
            isLogin = false,
            setState(() {})


          }
      });
    } catch (error) {
      error.toString();
    }

    return isLoading?

      const MediaQuery(
        data:  MediaQueryData(),
        child: Scaffold(

            body:
            Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ))),
      )
        :
    MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(
        title: 'video call',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: isLogin ? 'users' : 'register',
        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
        builder: (BuildContext context, Widget? widget) {
          Widget error = const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Text('Something went wrong...\n Please try again later'),
              ),
            ),
          );
          //If widget returns error show this widget instead
          if (widget is Scaffold || widget is Navigator) {
            error = Scaffold(

              body: Center(
                child: error,
              ),
            );
            ErrorWidget.builder = (FlutterErrorDetails errorDetails) => error;
          }
          return widget!;
        },
      ),
    );
  }
}


