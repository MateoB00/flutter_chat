import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitaldschool/globale.dart';
import 'package:digitaldschool/model/utilisateur.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  late String id;
  late String content;
  late DocumentReference sender;
  late DocumentReference receiver;
  Timestamp created_at = Timestamp.now();
  Timestamp updated_at = Timestamp.now();

  Messages(DocumentSnapshot snapshot) {
    id = snapshot.id;
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    content = map['content'];
    sender = map['sender'];
    receiver = map['receiver'];
    created_at = map['created_at'];
    updated_at = map['updated_at'];
  }

  Messages.empty() {
    id = "";
    content = "";
    sender = FirebaseFirestore.instance.doc('');
    receiver = FirebaseFirestore.instance.doc('');
    created_at = Timestamp.now();
    updated_at = Timestamp.now();
  }
}
