import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitaldschool/globale.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Message {
  //attributs
  late String id;
  late String content;
  late Reference sender;
  late Reference receiver;
  DateTime created_at = DateTime.now();
  DateTime updated_at = DateTime.now();

//   //un ou des constructeurs
//  Utilisateur(DocumentSnapshot snapshot){
//    id = snapshot.id;
//    Map<String,dynamic> map = snapshot.data()as Map<String,dynamic>;
//    lastname = map['NOM'];
//    name = map['PRENOM'];
//    email = map['EMAIL'];
//    avatar = map["AVATAR"] ?? defaultImage;
//    favoris = map["FAVORIS"] ?? [];
//    Timestamp? timeprovisoire = map["BIRTHDAY"];
//    if(timeprovisoire == null){
//      birthday = DateTime.now();
//    }
//    else
//      {
//        birthday = timeprovisoire.toDate();
//      }

//  }


 Message.empty(){
   id = "";
   content ="";
  //  sender ="";
  //  receiver ="";
 }




  //méthode


}