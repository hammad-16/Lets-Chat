import 'dart:developer';
import 'dart:io';

import 'package:chatting/models/chat_user.dart';
import 'package:chatting/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
//Good approach to make seperate classes and use their objects in complex projects
class APIs {
//Creation of static object, created once and if global can be accessed from anywhere
  static FirebaseAuth auth = FirebaseAuth.instance; // for authentication

// For accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

// For accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

//For storing self information
  static late ChatUser me;

  static User get user => auth.currentUser!;

// For checking if user exists or not.

// Making a static function which we can access without any object
  static Future<bool> userExists() async {
    return (await
    firestore.collection('users')
        .doc(auth.currentUser!.uid).
    get()).exists;
  }

//For getting current user info
  static Future <void> getSelfInfo() async {
    await firestore.
    collection('users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((user) {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        log("My data: ${user.data()}");
      }
      else {
        createUser().then((value) => getSelfInfo());
      }
    });
  }

//For creating a new user
  static Future<void> createUser() async {
    final time = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    final Chatuser = ChatUser(
        image: user.photoURL.toString(),
        name: user.displayName.toString(),
        about: "Hey I am using Lets Chat!",
        createdAt: time,
        lastActive: time,
        isOnline: false,
        id: user.uid,
        pushToken: time,
        email: user.email.toString()
    );
    return (await
    firestore.collection('users')
        .doc(user.uid).set(Chatuser.toJson()));
  }

  // For getting all data from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore.collection('users')
        .where('id', isNotEqualTo: (user.uid))
        .snapshots();
    //where clause here is specifying that id should not be equal to our current userid
  }

  //For updating user information
  static Future<void> updateUserInfo() async {
    await
    firestore.collection('users')
        .doc(auth.currentUser!.uid).
    update(
        {
          'name': me.name,
          'about': me.about,
        });
  }

// We can update data in two ways, by using .set : we will be making the document if it does not exist
// .update : Update is called when document exists and data is written in the pre-existing document.


//This function is to update the profile picture of user
  static Future<void> updateProfilePicture(File file) async {
    //Getting image file extension
    final ext = file.path.split('.'),
        last;
    log("Extesnion:$ext");

    //Storage file reference with path
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((
        p0) async {
      log('Data transferred: ${p0.bytesTransferred / 1000} kb');
    });
      //Updating image in firestore database
      me.image = await ref.getDownloadURL();
      await
      firestore.collection('users')
          .doc(auth.currentUser!.uid).
      update(
          {
            'image': me.image,

          });

  }

  ///Chat Screen Related APIs*********************
  ///

  //Useful for getting conversation id
  static String getConversationID(String id) =>
      user.uid.hashCode <= id.hashCode
          ? '${user.uid}_$id'
          : '${id}_${user.uid}';

  // For getting all messages of a specific conversation from Firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .snapshots();
    //where clause here is specifying that id should not be equal to our current userid
  }

  //For sending message.

  static Future<void> sendMessage(ChatUser chatUser, String msg, Type type) async {
    final time = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();

    //Messages to send
    final Message message = Message(
        msg: msg,
        toId: chatUser.id,
        read: '',
        type: type,
        fromid: user.uid,
        sent: time);
    final ref = firestore.collection(
        'chats/${getConversationID(chatUser.id)}/messages/');
    ref.doc(time).set(message.toJson());
  }
// Update read status of message
  static Future<void> updateMessageReadStatus(Message message) async
  {
    firestore.collection(
        'chats/${getConversationID(message.fromid)}/messages/')
        .doc(message.sent).update({'read':DateTime
        .now()
        .millisecondsSinceEpoch
        .toString()});

  }

  //Get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(
      ChatUser user)
  {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
    .orderBy('sent', descending: true)
    .limit(1)
        .snapshots();
  }
  //send chat image
  static Future <void> sendChatImage(ChatUser chatuser, File file)
  async {
    //Getting image file extension
    final ext = file.path.split('.'),
        last;


    //Storage file reference with path
    final ref = storage.ref().child('images/${getConversationID(chatuser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    //Uploading image
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((
        p0) async {
      log('Data transferred: ${p0.bytesTransferred / 1000} kb');
    });
    //Updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatuser, imageUrl, Type.image);

  }



}