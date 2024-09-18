import 'dart:convert';
import 'dart:developer';

import 'package:chatting/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
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
  //This will store all users
   List<ChatUser>names=[];
  //This will store searched items
  final List<ChatUser> _searchNames=[];
  //For storing search status
  bool _isSearching = false;

  @override
  void initState() {

    super.initState();
    APIs.getSelfInfo();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: WillPopScope(
        //WillPopScope will work only on the scaffold it is applied on or current screen
        //If search is on and back button is clicked, then close search
        //Or else simple close current screen on back button click
        onWillPop: (){
          if(_isSearching)
            {
              setState(() {
                _isSearching=!_isSearching;

              });
              return Future.value(false);
            }
          else
            {
              return Future.value(true);
            }

        },
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(Icons.home, ),
            title: _isSearching?
            TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Name, Email....",
                hintStyle: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400)
              ),
              autofocus: true,
              style: TextStyle(fontSize: 16, letterSpacing: 1, color: Colors.white, fontWeight: FontWeight.w600),
              onChanged: (val){
                //Search logic
                _searchNames.clear();
                for(var i in names)
                  {
                    if(i.name.contains(val.toLowerCase()) || i.email.contains(val.toLowerCase()) )
                      {
                        _searchNames.add(i);
                        setState(() {
                         _searchNames;
                        });
                      }
                  }
              },
            ): Text('Lets Chat'),
            actions: [
              // Search User Button
              IconButton(onPressed: (){
                setState(() {
                  _isSearching= !_isSearching;
                });
              }, icon: Icon(_isSearching?CupertinoIcons.clear_circled_solid: Icons.search)),
              IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>ProfileScreen(user: APIs.me)));

              }, icon: Icon(Icons.more_vert))
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
              stream: APIs.getAllUsers(),

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
                          itemCount: _isSearching? _searchNames.length: names.length,
                          physics: BouncingScrollPhysics(),   // Scrolling Style,
                          padding: EdgeInsets.only(top: mq.height *0.01),
                          itemBuilder: (context,index)
                          {
                            return  ChatUserCard(
                                user:_isSearching?_searchNames[index]:  names[index]);

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

        ),
      ),
    );
  }
}
