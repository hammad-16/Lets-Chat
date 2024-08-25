import 'dart:developer';

import 'package:chatting/auth/login.dart';

import 'package:flutter/material.dart';
import 'package:chatting/main.dart';
import 'package:chatting/screens/HomeScreen.dart';
import 'package:flutter/services.dart';

import '../api/apis.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _login();
}

class _login extends State<SplashScreen> {
  @override

  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2),(){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
              statusBarColor: Colors.black,

          )
      );

      if(APIs.auth.currentUser!=null)
        {
          log("\nUser:${APIs.auth.currentUser}");
          //Navigate to Home Screen
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const HomeScreen()));

        }
      else
        {
          //Navigate to login screen
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const login()));

        }

    });
  }
  Widget build(BuildContext context) {
    mq= MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,

          title: const Text('Start a Chat!',
          ),


          backgroundColor: Colors.black,),
        body: Stack(
          children: [
            Positioned(
                top: mq.height* .15,

                width:mq.width*0.5,
                right:  mq.width*0.25,
                child: Image.asset('images/chat.png')
            ),




            Positioned(
                 bottom: mq.height* .15,
              width:mq.width*0.9,

              child: Text("A Chatting Application",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  letterSpacing: 0.5


              ),)
            ),
          ],

        )

    );
  }
}
