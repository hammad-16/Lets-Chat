import 'package:chatting/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chatting/auth/login.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';

late Size mq;
void main() async {

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await _initialiseFirebase();
  }catch(Exception){
    print(Exception);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Lets Chat',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 1,
            titleTextStyle: TextStyle(
                backgroundColor: Colors.black, fontSize: 19),
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.white,
          ),),

debugShowCheckedModeBanner: false,
        home: const SplashScreen());


    // home: const MyHomePage(title: 'Flutter Demo Home Page'),

  }
}

_initialiseFirebase()
  async{
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).whenComplete(()=>print("hello"));
}
