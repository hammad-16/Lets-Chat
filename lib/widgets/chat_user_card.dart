
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting/models/chat_user.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../screens/chat_screen.dart';


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
      onTap:(){
        //For navigating to chat screen
        Navigator.push(context, MaterialPageRoute(builder: (_)=> ChatScreen(user: widget.user ,) ));
      },
      child: ListTile(
        //pfp
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(mq.height* 0.3),
          child: CachedNetworkImage(
            width: mq.height*.055,
            height: mq.height* .055,
            imageUrl: widget.user.image,
           // placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) =>const CircleAvatar(
                 child: Icon(Icons.person),
               ),
          ),//We have used this for the display picture, using CachedNetworkImage
        ),
        // leading: const CircleAvatar(
        //   child: Icon(Icons.person),
        // ),
          //name
          title:Text(widget.user.name),
              //Last message
          subtitle: Text(widget.user.about, maxLines: 1,),
        // trailing: Text("4:30 PM"),
        // Last message time.

        trailing: Container(width:15, height: 15,
        decoration: BoxDecoration( 
        color: Colors.greenAccent.shade400,
          borderRadius: BorderRadius.circular(10),
        ),
        ) // For a green dot
      )
        ),
    );
  }
}
