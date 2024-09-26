
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting/helper/my_date_util.dart';
import 'package:chatting/models/chat_user.dart';
import 'package:chatting/models/message.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';
import '../api/apis.dart';
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
  //Last message info (if null -> no message)
  Message? _message;
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

      child: StreamBuilder(
        stream:APIs.getLastMessages(widget.user),
        builder: (context,snapshots)
          {
            final data = snapshots.data?.docs;
            final names = data?.map((e) => Message.fromJson(e.data())).toList() ??[];
            // Remember mapping, an alternative to traverse the list, return an empty list, if no data available.

            // final data = snapshots.data?.docs;
            if(names.isNotEmpty)
              {
                _message = names[0] ;

              }

            return ListTile(
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
                subtitle: Text(_message!=null?_message!.msg:widget.user.about, maxLines: 1,),
                // trailing: Text("4:30 PM"),
                // Last message time.

                trailing: _message==null?
                null: //Show nothing when no message is sent
                    _message!.read.isNotEmpty && _message!.fromid!=APIs.user.uid?
                        //Show for unread message
                Container(width:15, height: 15,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ) // For a green dot
              : Text(MyDateUtil.getLastMessageTime(context: context,
                        time: _message!.sent),
                    style: TextStyle(color: Colors.black),),


            );
          }

        ),
    ),
    );
  }
}
