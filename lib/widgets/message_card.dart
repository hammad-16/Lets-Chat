import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting/helper/my_date_util.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';
import '../main.dart';
import '../models/message.dart';
class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
final Message message;
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromid
        ? _blackMessage()
        : _greenMessage();
  }
  //Sender or another user message
  Widget _blackMessage()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween ,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type==Type.image?
            mq.width*0.03:
                mq.width*0.04
            ),
            margin: EdgeInsets.symmetric(horizontal: mq.width*0.04, vertical: mq.width*0.01),
            decoration: BoxDecoration(color: Colors.black,

                borderRadius: BorderRadius.only(topLeft: Radius.circular(30)
                ,topRight: Radius.circular(30), bottomRight: Radius.circular(30))
            ),
            child:
                widget.message.type== Type.text?
            Text(widget.message.msg, style: TextStyle(fontSize: 15,
            color: Colors.white)
          
            ):
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(

                    imageUrl: widget.message.msg,
                     placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2,),
                    errorWidget: (context, url, error) =>
                      Icon(Icons.image_aspect_ratio, size: 70, color: Colors.white,),

                  ),//We have used this for the display picture, using CachedNetworkImage
                )
          ),
        ),
        Row(
          children: [

            //sent time
            Text(MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),
              style: TextStyle(fontSize: 13, color: Colors.black54),),
            SizedBox(width: 2),
            //Double tick blue icon for read message
            if(widget.message.read.isNotEmpty)
            Icon(Icons.done_all, color: Colors.blue, size: 20,),
            SizedBox(width: mq.width*0.04,),
          ],
        ),
      ],
    );
  }

  //Receiver/ our/ user message

  Widget _greenMessage()
  {
    //Update last read message if sender and receiver are different
    if(widget.message.read.isEmpty)
      {
        APIs.updateMessageReadStatus(widget.message);

      }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween ,
      children: [

        Padding(
            padding: EdgeInsets.all(widget.message.type==Type.image?
            mq.width*0.03:
            mq.width*0.04
            ),
            child: Text(MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),
  style: TextStyle(fontSize: 13, color: Colors.black54),)),
        //Message Content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width*0.04),
            margin: EdgeInsets.symmetric(horizontal: mq.width*0.04, vertical: mq.width*0.01),
            decoration: BoxDecoration(color: Color.fromARGB(255,255, 163, 26),

                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30)
                    ,topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))
            ),
            child: widget.message.type== Type.text?
                //Then show text
            Text(widget.message.msg, style: TextStyle(fontSize: 15,
                color: Colors.white)

            ):
                //Else show image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(

                imageUrl: widget.message.msg,
                placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2,),

                errorWidget: (context, url, error) =>
                    Icon(Icons.image_aspect_ratio, size: 70, color: Colors.white,),

              ),//We have used this for the display picture, using CachedNetworkImage
            )
          ),
        ),

      ],
    );
  }
}
