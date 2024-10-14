
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting/auth/login.dart';
import 'package:chatting/helper/my_date_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../main.dart';
import '../models/chat_user.dart';
// view profile screen to view profile of user
class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ViewProfileScreen({super.key, required this.user});


  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  Color check = Colors.grey;
  bool _isTap = false;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //For hiding keyboard by clicking anywhere on screen
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
      
          title: Text(widget.user.name,
          ),
      
      
          backgroundColor: Colors.black,),
        
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Joined on: ', style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 16),),
            Text(MyDateUtil.getLastMessageTime(context: context, time: widget.user.createdAt, showYear: true), style: TextStyle(color: Colors.black54, fontSize:16),),
          ],
        ),
      

      
        // builder is helpful in dynamically showing the cards and also manages the memory well
        body:
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: mq.width*0.05),
            child: SingleChildScrollView(
              child: Column(children: [
                SizedBox(height: mq.height* 0.03), // This will add some space from the appbar
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height* 0.1),
                    child: CachedNetworkImage(
                      width: mq.height*.2,
                      height: mq.height* .2,
                      fit: BoxFit.fill, //Will fill all the available space
                      imageUrl: widget.user.image,
                      // placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: mq.height* 0.03 ,),
                //User email
                Text(widget.user.email, style: TextStyle(color: Colors.black87, fontSize:16),),


                SizedBox(height: mq.height* 0.03 ,),
                //User About
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('About: ', style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    fontSize: 16),),
                    Text(widget.user.about, style: TextStyle(color: Colors.black54, fontSize:16),),
                  ],
                ),



              ],),
            ),
          )
      ),
    );
  }
}
