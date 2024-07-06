
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:video_call_app/model/user_model.dart';
import 'package:video_call_app/signaling.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  final UserModel model;
  const MyHomePage({Key? key, required this.model}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  TextEditingController textEditingController = TextEditingController(text: '');

  int? boxNumberIsDragged;

  @override
  void initState() {
    boxNumberIsDragged = null;
    _localRenderer.initialize();
    _remoteRenderer.initialize();

    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });

    startCamera();
    super.initState();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video call try"),
      ),
      body:
      OrientationBuilder(builder: (context, orientation) {
        return Stack(children: <Widget>[
          Positioned(
              left: 0.0,
              right: 0.0,
              top: 0.0,
              bottom: 0.0,
              child: Container(
                margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(color: Colors.black54),
                child: RTCVideoView(_remoteRenderer),
              )),
          Positioned(
            left: 20.0,
            top: 20.0,
            child: Container(
              width: orientation == Orientation.portrait ? 90.0 : 120.0,
              height:
              orientation == Orientation.portrait ? 120.0 : 90.0,
              decoration: const BoxDecoration(color: Colors.black54),
              child: RTCVideoView(_localRenderer, mirror: true),
            ),
          ),
        ]);
      })


      // Column(
      //   children: [
      //
      //
      //
      //
      //     Expanded(
      //       child: Stack(
      //
      //         children: [
      //           Expanded(child: RTCVideoView(_localRenderer, mirror: true)),
      //
      //           // Positioned(
      //           //   top: 0,
      //           //   right: 0,
      //           //   child: SizedBox(
      //           //        height: 150,
      //           //       width: 150,
      //           //       child: Expanded(child: RTCVideoView(_remoteRenderer))),
      //           // )
      //            buildDraggableBox( Colors.red, new Offset(30.0, 100.0)),
      //           Positioned(
      //             bottom: 0,
      //             right: 0,
      //             left: 0,
      //             child:   SingleChildScrollView(
      //             scrollDirection: Axis.horizontal,
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 ElevatedButton(
      //                   onPressed: () async {
      //
      //                     await signaling.openUserMedia(_localRenderer, _remoteRenderer);
      //                     setState(() {});
      //                   },
      //                   child: Text("Open camera"),
      //                 ),
      //                 SizedBox(
      //                   width: 8,
      //                 ),
      //                 ElevatedButton(
      //                   onPressed: () async {
      //                     roomId = await signaling.createRoom(_remoteRenderer);
      //                     textEditingController.text = roomId!;
      //                     setState(() {});
      //                   },
      //                   child: Text("Create room"),
      //                 ),
      //                 SizedBox(
      //                   width: 8,
      //                 ),
      //                 ElevatedButton(
      //                   onPressed: () async {
      //                     // Add roomId
      //                     await  signaling.joinRoom(
      //                       textEditingController.text,
      //                       _remoteRenderer,
      //                     );
      //                     setState(() {});
      //                   },
      //                   child: Text("Join room"),
      //                 ),
      //                 SizedBox(
      //                   width: 8,
      //                 ),
      //                 ElevatedButton(
      //                   onPressed: () {
      //                     signaling.hangUp(_localRenderer);
      //                   },
      //                   child: Text("Hangup"),
      //                 )
      //               ],
      //             ),
      //           ),)
      //         ],
      //       ),
      //     ),
      //
      //     Padding(
      //       padding: const EdgeInsets.all(0.0),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Text("Join the following Room: "),
      //           Flexible(
      //             child: TextFormField(
      //               controller: textEditingController,
      //             ),
      //           )
      //         ],
      //       ),
      //     ),
      //     SizedBox(height: 8)
      //   ],
      // ),
    );
  }

  Widget buildDraggableBox( Color color, Offset offset) {
    return Draggable(
      child: _buildBox(color, offset),
      feedback: _buildBox(color, offset),
      childWhenDragging: _buildBox(color, offset, onlyBorder: true),
      onDragStarted: () {
        setState((){

        });
      },
      onDragCompleted: () {
        setState((){

        });
      },
      onDraggableCanceled: (_,__) {
        setState((){

        });
      },
    );
  }

  _buildBox(Color color, Offset offset, {bool onlyBorder: false}) {
    return
      Positioned(
        top: 0,
        right: 0,
        child: SizedBox(
            height: 150,
            width: 150,
            child: Expanded(child: RTCVideoView(_remoteRenderer))),
      );
  }

  startCamera() async {
    await  signaling.openUserMedia(_localRenderer, _remoteRenderer);
    // roomId = await signaling.createRoom(_remoteRenderer);
    // await sendPush(widget.model, roomId!);
    setState(() {});
  }

  _switchCamera() {
    signaling.switchCamera();
  }

  sendPush(UserModel model, String roomId) async {

    var headers = {
      'Authorization': 'key=AAAA8E6PGwY:APA91bEsIeM3RUc11b5_6DAltZFfqIlIEQiL4jjxa6O3GVoAlRp-jv3BwiUcF6fGJonS5KokpbInTfkMeJtpodPSphvRqPGfKDPC6piFnH5nXpASq5L7QBxcb4gzrieMjVwjCQp62PgR',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    request.body = json.encode({
      "to": model.token,
      "notification": {
        "body": "${model.name} is requesting for a video call",
        "title": roomId,
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