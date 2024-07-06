import 'package:shared_preferences/shared_preferences.dart';

class LoginData{



  static addLoginStatus(int status) async {
    //status = 1  user logged in
    //status = 0  user not logged in
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('loginStatus', status);

  }

  static addCallStatus(int status) async {
    //status = 1  user logged in
    //status = 0  user not logged in
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('callStatus', status);

  }


  static Future<int> getLoginStatus(
      ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int status = prefs.getInt('loginStatus') ?? 0;
    return status;

  }


  static Future<int> getCallStatus(
      ) async {
        
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int status = prefs.getInt('callStatus') ?? 0;
    return status;

  }


}