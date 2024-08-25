
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting/models/chat_user.dart';
import 'package:flutter/material.dart';

import '../main.dart';


//We will be changing this dynamically, hence stateful widget
class ChatUserCard extends StatefulWidget {
  final ChatUser user; // ChatUser object
  const ChatUserCard({super.key, required this.user}); //We will be adding a user

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      margin: EdgeInsets.symmetric(horizontal: mq.width*0.04, vertical: 4) ,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
      onTap:(){},
      child: ListTile(
        //pfp
        leading: CachedNetworkImage(
          imageUrl: "http://via.placeholder.com/350x150",
         // placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) =>const CircleAvatar(
       child: Icon(Icons.person),
     ),
        ),
        // leading: const CircleAvatar(
        //   child: Icon(Icons.person),
        // ),
          //name
          title:Text(widget.user.name),
              //Last message
          subtitle: Text(widget.user.about, maxLines: 1,),
        trailing: Text("4:30 PM"),

      )
        ),
    );
  }
}
