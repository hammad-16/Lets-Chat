
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting/auth/login.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../main.dart';
import '../models/chat_user.dart';
class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});


  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Color check = Colors.grey;
  bool _isTap = false;
  final _formKey = GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //For hiding keyboard by clicking anywhere on screen
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
      
          title: const Text('Profile Screen',
          ),
      
      
          backgroundColor: Colors.black,),
      
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(onPressed: () async {
            Dialogs.showProgressBar(context);
            //This will show progress dialog
            //This will sign out the app
            await APIs.auth.signOut().then((value) async {
              await GoogleSignIn().signOut().then((value){
                //hiding progress dialog
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>login()));
              });
      
            });
          }, icon: Icon(Icons.logout, color: Colors.white,) ,
            label: Text("Logout",
            style: TextStyle(color: Colors.white,
            fontSize: 15),
            ),
            backgroundColor: Colors.redAccent,
      
      
          ),
        ),
      
        // builder is helpful in dynamically showing the cards and also manages the memory well
        body:
          Form(
            key: _formKey,
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: mq.width*0.05),
              child: SingleChildScrollView(
                child: Column(children: [
                  SizedBox(height: mq.height* 0.03), // This will add some space from the appbar
                  Center(
                    child: Stack(
                      children: [
                        _image !=null  ?
                        ClipRRect(
                          //Local image
                          borderRadius: BorderRadius.circular(mq.height* 0.1),
                          child: Image.file(
                            File(_image!),
                            width: mq.height*.2,
                            height: mq.height* .2,
                            fit: BoxFit.cover, //Will fill all the available space
                            // placeholder: (context, url) => CircularProgressIndicator(),

                          ),
                        ):



                            //Image from server
                        ClipRRect(
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
                        //Edit Image Button
                        Positioned(
                          bottom: 0
                          ,right: 0,
                          child: MaterialButton(onPressed: (){
                            _showBottomSheet();
                          },
                              elevation: 1,

                              color: Colors.white,
                              shape: CircleBorder(),
                          child: Icon(Icons.edit)),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: mq.height* 0.03 ,),
                      
                  Text(widget.user.email, style: TextStyle(color: Colors.black54, fontSize:16),),
                      
                  SizedBox(height: mq.height* 0.03 ,),
                      
                  TextFormField(
                    onSaved: (val)=>APIs.me.name=val??'',
                    validator: (val)=> val!=null && val.isNotEmpty? null : "Required Field",
                    initialValue: widget.user.name,
                    decoration: InputDecoration(
                     border: const OutlineInputBorder()
                    , prefixIcon: Icon(Icons.person_2, color: Colors.black),
                      hintText: "Enter Your Name",
                      label:  Text("Name")
                    ),
                  ),
                  SizedBox(height: mq.height* 0.03 ,),
            
                  GestureDetector(
                    onTap: ()=>FocusScope.of(context).unfocus(
                    ),
                    child: TextFormField(
                      onSaved: (val)=>APIs.me.name=val??'',
                      validator: (val)=> val!=null && val.isNotEmpty? null : "Required Field",


                      onTap: () {
                        setState(() {
                          _isTap = true;
                        });
                      },
                      onFieldSubmitted: (value) {
                        setState(() {
                          _isTap = false;
                        });
                      },
                      initialValue: widget.user.name,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lightbulb, color: _isTap ? Colors.yellow : Colors.grey),
                        hintText: "Feeling good",
                        label: Text("About"),
                      ),
                    ),
                  ),
                  SizedBox(height: mq.height* 0.05 ,),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(shape: StadiumBorder(),
                    backgroundColor: Colors.black,
                    fixedSize: Size(mq.width*0.5, mq.height*0.06 )),
                    onPressed: (){
                      if(_formKey.currentState!.validate())
                        {
                          _formKey.currentState!.save();
                          APIs.updateUserInfo().then((value){
                            Dialogs.showSnackbar(
                                context,"Profile updated successfully");
                          });
                          log('inside validator');
                          
                        }
                    },
                  icon:Icon(Icons.edit, color: Colors.white,), label: Text("UPDATE", style: TextStyle(fontSize: 16, color: Colors.white), ),)
                ],),
              ),
            ),
          )
      ),
    );
  }
  // Bottom sheet for picking a profile picture for user
  void _showBottomSheet()
  {
    showModalBottomSheet(context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight:  Radius.circular(30)))
        ,
        builder: (_)
    {

      return ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(top: mq.height*0.04, bottom: mq.height*0.15),
        children: [
          const Text("Choose a Profile Picture", textAlign:TextAlign.center,style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
          SizedBox(height: mq.height*0.02,)
          ,Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
            children: [
              //Picking pfp from gallery
              ElevatedButton(onPressed: () async {
                final ImagePicker picker = ImagePicker();
                //Picking an image
                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                if(image!=null) {
                  log('Image path: ${image.path}--MimeType: ${image.mimeType}');
                  setState(() {
                    _image=image.path;
                  });
                  APIs.updateProfilePicture(File(_image!));
                  Navigator.pop(context);//This will subsequently hide the bottom sheet
                }
              },
                child: Image.asset("images/select_image.png"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,

                  fixedSize: Size(mq.width*0.3, mq.height*0.15)
                )
              ),
              //Taking picture from camera button
              ElevatedButton(onPressed: () async {
                final ImagePicker picker = ImagePicker();
                //Picking an image
                final XFile? image = await picker.pickImage(source: ImageSource.camera);
                if(image!=null) {
                  log('Image path: ${image.path}');
                  setState(() {
                    _image=image.path;
                  });
                  APIs.updateProfilePicture(File(_image!));
                  Navigator.pop(context);//This will subsequently hide the bottom sheet
                }
              },
                  child: Image.asset("images/camera.png"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      fixedSize: Size(mq.width*0.3, mq.height*0.15)
                  )
              ),
            ],
          )
        ],

      );

      
    }
    );

  }


}
