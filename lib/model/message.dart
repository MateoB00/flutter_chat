import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitaldschool/globale.dart';
import 'package:digitaldschool/model/utilisateur.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Message {
  //attributs
  late String id;
  late String content;
  late Reference sender;
  late Reference receiver;
  DateTime created_at = DateTime.now();
  DateTime updated_at = DateTime.now();

Message(DocumentSnapshot snapshot) {
  id = snapshot.id;
  Map map = snapshot.data() as Map;
  content = map['CONTENT'];
  sender = map['SENDER'];
  receiver = map['RECEIVER'];
}


 Message.empty(){
   id = "";
   content = "";
   sender = "" as Reference;
   receiver = "" as Reference;
 }
}