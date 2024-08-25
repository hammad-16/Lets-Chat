import 'dart:developer';
import 'dart:io';

import 'package:chatting/helper/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatting/main.dart';
import 'package:chatting/screens/HomeScreen.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../api/apis.dart';
import 'lib/helper/dialogs.dart';
class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _login();
}

class _login extends State<login> {
  @override
  bool _isAnimate=false;
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1),(){
      setState(() {
        _isAnimate=true;
      });
    });
  }
  _handleGoogleClick()
  {
    //This will start showing Progress bar circle
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async{
      //This will end progress bar circle
      Navigator.pop(context);

      if(user!=null)
        {
          log("\nUser:${user.user}");
          log("\nUserAdditionalInfo:${user.additionalUserInfo}");

          if((await APIs.userExists()))
            {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_)=> const HomeScreen()  )
              );
            }
          else
            {
              await APIs.createUser().then((value)
              {
              Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_)=> const HomeScreen()  )
              );

              }
              );
            }



        }

    });
  }


  Future<UserCredential?> _signInWithGoogle() async {
   try{
     await InternetAddress.lookup('google.com');
     // Trigger the authentication flow
     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

     // Obtain the auth details from the request
     final GoogleSignInAuthentication? googleAuth =
     await googleUser?.authentication;

     // Create a new credential
     final credential = GoogleAuthProvider.credential(
       accessToken: googleAuth?.accessToken,
       idToken: googleAuth?.idToken,
     );
      // print("life");
     // Once signed in, return the UserCredential
     return await APIs.auth.signInWithCredential(credential);
   }
   catch(Exception)
    {
      // print("life");
      log('\n_signInWithGoogle: $Exception');
      if(mounted) {
        Dialogs.showSnackbar(context, "Something Went Wrong(Check Internet!)");
      }
       return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    // mq= MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,

          title: const Text('Start a Chat!',
          ),


          backgroundColor: Colors.black,),
        body: Stack(
          children: [
            AnimatedPositioned(
                top: mq.height* .15,

                width:mq.width*0.5,
                right: _isAnimate? mq.width*0.25: mq.width*0.5,
                duration: const Duration(milliseconds: 500),
                child: Image.asset('images/chat.png')
            ),




            Positioned(bottom: mq.height* .15,
              width:mq.width*0.9,

              left: mq.width * 0.05,
              height: mq.width*0.07,

              child: ElevatedButton.icon(

                style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape:StadiumBorder(), elevation: 3, fixedSize: Size(60, 60)),
                onPressed: (){
                  _handleGoogleClick();

                }, icon:Image.asset('images/google_dark.jpg', height: mq.height* 0.03),
                label: RichText(text: TextSpan(
                  style: TextStyle(color: Colors.white,fontSize: 19),
                  children: [
                    TextSpan(text:"Log in with ", style: TextStyle(fontWeight: FontWeight.w300)),
                    TextSpan(text:"Google",style: TextStyle(fontWeight: FontWeight.w700)),
                  ],),



                ),
              ),
            ),
          ],

        )

    );
  }
}
