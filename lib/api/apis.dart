import 'package:chatting/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//Good approach to make seperate classes and use their objects in complex projects
class APIs
{
//Creation of static object, created once and if global can be accessed from anywhere
  static FirebaseAuth auth = FirebaseAuth.instance;    // for authentication

// For accessing cloud firestore database
static FirebaseFirestore firestore = FirebaseFirestore.instance;

static User get user => auth.currentUser!;
// For checking if user exists or not.
// Making a static function which we can access without any object
static  Future<bool> userExists() async{
  return (await
  firestore.collection('users')
      .doc(auth.currentUser!.uid).
  get()).exists;
}
  static  Future<void> createUser() async{
  final time =DateTime.now().millisecondsSinceEpoch.toString();
  final Chatuser = ChatUser(
      image: user.photoURL.toString(),
      name: user.displayName.toString(),
      about: "Hey I am using Lets Chat!",
      createdAt: time ,
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


}