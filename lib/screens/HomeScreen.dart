import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../api/apis.dart';
import '../main.dart';
import '../models/chat_user.dart';
import '../widgets/chat_user_card.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> names=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.home, ),
        title: const Text('Lets Chat',
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.search)),
          IconButton(onPressed: (){}, icon: Icon(Icons.more_vert))
        ],

        backgroundColor: Colors.black,),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(onPressed: () async {
          await APIs.auth.signOut();
          await GoogleSignIn().signOut();
        }, child: Icon(Icons.add_box) ,

        ),
      ),

      // builder is helpful in dynamically showing the cards and also manages the memory well
      body: StreamBuilder(
        // gives right to access any collection. We can query the data in form of snapshots
          stream: APIs.firestore.collection('users').snapshots(),

        builder: (context, snapshot)
            {
              switch(snapshot.connectionState)
              {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator()
                  );

                  //If some data is thereto show then go ahead->
                case ConnectionState.done:
                case ConnectionState.active:


                  final data = snapshot.data?.docs;
                 names = data?.map((e) => ChatUser.fromJson(e.data())).toList() ??[];
                  // Remember mapping, an alternative to traverse the list, return an empty list, if no data available.

              if(names.isNotEmpty)
                {
                  return ListView.builder(
                      itemCount: names.length,
                      physics: BouncingScrollPhysics(),   // Scrolling Style,
                      padding: EdgeInsets.only(top: mq.height *0.01),
                      itemBuilder: (context,index)
                      {
                        return  ChatUserCard(user: names[index]);

                      }
                  );
                }
              else
                {
                  return const Center(
                    child: Text("Start a Chat!",
                    style: TextStyle(fontSize: 20),
                    ),
                  );
                }


              }

            }

      )

    );
  }
}
