import 'package:flutter/material.dart';
import 'package:video_call_app/accept_video_call.dart';
import 'package:video_call_app/error_page.dart';
import 'package:video_call_app/home_page.dart';
import 'package:video_call_app/incoming_call_screen.dart';
import 'package:video_call_app/model/user_model.dart';
import 'package:video_call_app/model/video_model.dart';

import 'package:video_call_app/register.dart';
import 'package:video_call_app/users_list.dart';


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'register':
        return MaterialPageRoute(builder: (_) => const RegisterName());
      case 'home_page':
        final args =  settings.arguments as UserModel;
        return MaterialPageRoute(builder: (_) =>  MyHomePage(model: args,));
      case 'users':
        return MaterialPageRoute(builder: (_) => const Users());
      case 'incoming_call':

        return MaterialPageRoute(builder: (_) =>  IncomingCall());
      case 'accept_video_call':
        final args =  settings.arguments as VideoModel;
        return MaterialPageRoute(builder: (_) =>  AcceptVideoCall(model: args));
      default:
        return MaterialPageRoute(builder: (_) => const ErrorPage());
    }
  }
}
