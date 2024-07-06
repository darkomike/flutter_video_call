import 'package:flutter/material.dart';

class IncomingCall extends StatefulWidget {
  // final VideoModel model;
  const IncomingCall({Key? key,
    // required this.model
  }) : super(key: key);

  @override
  State<IncomingCall> createState() => _IncomingCallState();
}

class _IncomingCallState extends State<IncomingCall> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              const Text("Incoming Call", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  InkWell(
                    onTap: (){

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) =>  AcceptVideoCall(model: widget.model,)),
                      // );
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(7))
                      ),
                      width: 100,
                      height: 50,

                      child: const Center(
                        child: Text('Accept', style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: (){

                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(7))
                      ),
                      width: 100,
                      height: 50,

                      child: const Center(
                        child: Text('Decline', style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
