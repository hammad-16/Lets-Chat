import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting/models/chat_user.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';
import '../main.dart';
import '../models/message.dart';
import '../widgets/chat_user_card.dart';
import '../widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Here I'll be storing all the messages in the list.
  List<Message> _list = [];
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace:  _appBar(),
        ),
       // backgroundColor: Color.fromARGB(255, 128, 128, 128),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                // gives right to access any collection. We can query the data in form of snapshots
                //   stream: APIs.getAllUsers(),
              stream: APIs.getAllMessages(widget.user),
                  builder: (context, snapshot)
                  {
                    switch(snapshot.connectionState)
                    {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return SizedBox();
              
                    //If some data is thereto show then go ahead->
                      case ConnectionState.done:
                      case ConnectionState.active:
              
              
                        final data = snapshot.data?.docs;

                         _list =
                             data?.map((e) => Message.fromJson(e.data())).toList() ??[];
                       // Remember mapping, an alternative to traverse the list, return an empty list, if no data available.

                        if(_list.isNotEmpty)
                        {
                          return ListView.builder(
                              itemCount:  _list.length,
                              physics: BouncingScrollPhysics(),   // Scrolling Style,
                              padding: EdgeInsets.only(top: mq.height *0.01),
                              itemBuilder: (context,index)
                              {
                                return  MessageCard(message: _list[index],);
              
                              }
                          );
                        }
                        else
                        {
                          return const Center(
                            child: Text("Lets Chat! 😎",
                              style: TextStyle(fontSize: 20),
                            ),
                          );
                        }
              
              
                    }
              
                  }
              
              ),
            )
            ,_chatInput()

          ],
        ),
      ),
    );
  }
  //App Bar widget
  Widget _appBar()
  {
    return InkWell(
      onTap: (){},
      child: Row(
        children: [
          IconButton(onPressed:()=>Navigator.pop(context),
            icon: Icon(Icons.arrow_back),
            color: Colors.black54,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height* 0.3),
            child: CachedNetworkImage(
              width: mq.height*.055,
              height: mq.height* .05,
              imageUrl: widget.user.image,
              // placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) =>const CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),//We have used this for the display picture, using CachedNetworkImage
          ),
          SizedBox(width:10),
          Column(
            mainAxisAlignment:MainAxisAlignment.center ,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //User Name
              Text(widget.user.name, style: const TextStyle(
                fontSize: 16, color: Colors.black87,
                  fontWeight: FontWeight.w500
              ),),
              SizedBox(height: 2),
              // Last Active Time of the user
              Text("Last seen not available", style: const TextStyle(
                  fontSize: 13, color: Colors.black54,
                  fontWeight: FontWeight.w500
              ),),
            ],
          )
      
      
        ],
      ),
    );

  }
  // Bottom chat input field
  Widget _chatInput()
  {
    return Row(
      children:[
        Expanded(
          child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),
          child: Padding(
            padding:  EdgeInsets.symmetric(vertical: mq.height*0.01, horizontal: mq.width*0.025),
            child: Row(
              children: [
                //Emoji Button
                IconButton(onPressed:(){},
                  icon: Icon(Icons.emoji_emotions, size: 24),
                  color: Colors.blue,
                ),
                 Expanded(child: TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: "Write a message.",
                    hintStyle: TextStyle(color: Colors.grey,),
                    border: InputBorder.none

                  ),
                )),
                //Pick image from gallery
                IconButton(onPressed:(){},
                  icon: Icon(Icons.image, size: 25),
                  color: Colors.blue,
                ),
                //Pick image from camera
                IconButton(onPressed:(){},
                  icon: Icon(Icons.camera_enhance, size: 25,),
                  color: Colors.blue,
                ),
                SizedBox(width: mq.width*0.008,)
              ],
            ),
          ),
                ),
        ),
        MaterialButton(
        onPressed: (){
          if(_textController.text.isNotEmpty)
            {
              APIs.sendMessage(widget.user, _textController.text);
              _textController.text ='';
            }

        },
            minWidth: 0,
            padding: EdgeInsets.only(top:10, bottom:10,right:5, left:10 ),
            shape: CircleBorder(),child: Icon(Icons.send, color: Colors.white, size:28),color: Colors.black)
    ]
    );
  }



}
