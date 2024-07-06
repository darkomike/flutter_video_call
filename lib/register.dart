import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:video_call_app/login_data.dart';
import 'package:video_call_app/users_list.dart';

class RegisterName extends StatefulWidget {
  const RegisterName({Key? key}) : super(key: key);

  @override
  State<RegisterName> createState() => _RegisterNameState();
}

class _RegisterNameState extends State<RegisterName> {
  final TextEditingController nameController = TextEditingController();
  String _webPushkey="BA-m5T9IN4uTssSRYh4BToqLHpnN8ZYiX2P3Z6yx0HudUdFH42s_50umMjeImwFOf-ipTEl3RoQIqElsOqxPhTk";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [

          SizedBox(
            width: 150,
            height: 50,
            child: TextFormField(
                          controller: nameController,
                        ),
          ),

            SizedBox(height: 15,),

            Container(
              color: Colors.blue,
              width: 150,
              height: 50,
              child: InkWell(
                onTap: () async {
                  var token = await FirebaseMessaging.instance.getToken(vapidKey: _webPushkey);
                  await addUser(nameController.text, token!);
                  LoginData.addLoginStatus(1);
                },
                child: Center(child: Text("Add Name", style: TextStyle(color: Colors.white),)),
              ),

            )





          ],
        ),
      ),
    );
  }

  Future<void> addUser(String  name, String token) {
    var dialogContext = context;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext buildContext) {
          dialogContext = buildContext;

          return  AlertDialog(
              insetPadding: const EdgeInsets.all(20),
              contentPadding: const EdgeInsets.all(10),
              clipBehavior: Clip.antiAliasWithSaveLayer,

              content: SizedBox(
                height: 150,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:  [
                      Text("adding name", style: TextStyle(color:Colors.black)),
                      const Center(child: CircularProgressIndicator(color: Colors.blue,),),
                      SizedBox(height: 10,),
                      Text("Please wait....", style: TextStyle(color: Colors.black),)
                    ],
                  ),
                ),
              )
          );
        });

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    // Call the user's CollectionReference to add a new user
    return users
        .add({
      'name': name, // John Doe
      'token': token, // Stokes and Sons

    })
        .then((value) {
      Navigator.pop(dialogContext);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Users()),
      );
    })
        .catchError((error) {
      Navigator.pop(dialogContext);
    });
  }
}
