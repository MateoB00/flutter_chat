import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitaldschool/globale.dart';
import 'package:digitaldschool/model/utilisateur.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  late String id;
  late String content;
  late DocumentReference sender;
  late DocumentReference receiver;
  late DateTime created_at;
  late DateTime updated_at;

  Message(DocumentSnapshot snapshot) {
    id = snapshot.id;
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    content = map['CONTENT'];
    sender = map['SENDER'];
    receiver = map['RECEIVER'];
    created_at = map['CREATED_AT'].toDate();
    updated_at = map['UPDATED_AT'].toDate();
  }

  Message.empty() {
    id = "";
    content = "";
    sender = FirebaseFirestore.instance.doc('');
    receiver = FirebaseFirestore.instance.doc('');
    created_at = DateTime.now();
    updated_at = DateTime.now();
  }
}