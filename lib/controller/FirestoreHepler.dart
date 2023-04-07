//C'est de faire les opérations sur la base de donnée

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitaldschool/model/utilisateur.dart';
import 'package:digitaldschool/model/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreHelper {

  //attributs
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final cloudUsers = FirebaseFirestore.instance.collection("UTILISATEURS");
  final cloudMessage = FirebaseFirestore.instance.collection("messages");




  //méthode

  //créer un utilisateur dans la base
   Future<Utilisateur> Inscription(String email, String password, String nom , String prenom) async{
    //creer dans l'authentification
      UserCredential credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = credential.user;
      if (user == null) {return Future.error("error");}
      else {
        String uid = user.uid;
        Map<String,dynamic> map = {
          "NOM": nom,
          "PRENOM":prenom,
          "EMAIL": email,
          "FAVORIS":[]
        };
        //stocker dans la partie du firestore database
        addUser(uid,map);
        return getUser(uid);

      }
  }

  Future<void> sendMessage(String senderEmail, String receiverEmail, String content) async {
    try {
      // Get sender and receiver documents from the 'UTILISATEURS' collection
      final senderSnapshot = await FirebaseFirestore.instance
          .collection('UTILISATEURS')
          .where('EMAIL', isEqualTo: senderEmail)
          .get();
      final receiverSnapshot = await FirebaseFirestore.instance
          .collection('UTILISATEURS')
          .where('EMAIL', isEqualTo: receiverEmail)
          .get();

      // Get the sender and receiver documents from the snapshots
      final senderDocument = senderSnapshot.docs.first;
      final receiverDocument = receiverSnapshot.docs.first;
      print(senderDocument);
      print(receiverDocument);
      // Create a new message document in Firestore
      await FirebaseFirestore.instance
          .collection('messages')
          .add({
        'sender': senderDocument.reference,
        'receiver': receiverDocument.reference,
        'content': content,
        'timestamp': DateTime.now(),
      });
    } catch (error) {
      // Handle any errors that occur during the message sending process
      print('Error sending message: $error');
      throw error;
    }
  }


  //    Future<Message> CreateMessage(String message, Reference sender, Reference received) async{
  //   //creer dans l'authentification
  //     UserCredential credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
  //     User? user = credential.user;
  //     if (user == null) {return Future.error("error");}
  //     else {
  //       String uid = user.uid;
  //       Map<String,dynamic> map = {
  //         "message": message,
  //         "sender":sender,
  //         "received": received,
  //       };
  //       //stocker dans la partie du firestore database
  //       addUser(uid,map);
  //       return getUser(uid);

  //     }
  // }

  Future<void> sendMessage(senderId, receiverId, String content) async {
  // Ajouter le message à la collection "messages".
  await FirebaseFirestore.instance.collection('MESSAGES').add({
    'senderId': senderId,
    'receiverId': receiverId,
    'content': content,
  });

  // Ajouter le message à l'historique du sender.
  await FirebaseFirestore.instance.collection('UTILISATEURS').doc(senderId).update({
    'MESSAGES': FieldValue.arrayUnion([{
      'receiverId': receiverId,
      'content': content,
    }])
  });

  // Ajouter le message à l'historique du receiver.
  await FirebaseFirestore.instance.collection('UTILISATEURS').doc(receiverId).update({
    'MESSAGES': FieldValue.arrayUnion([{
      'senderId': senderId,
      'content': content,
    }])
  });
}


  //Récupérer les infos de l'utilisateur
  Future<Utilisateur> getUser(String id) async {
     DocumentSnapshot snapshots =await cloudUsers.doc(id).get();
     return Utilisateur(snapshots);

  }


//se connecter à un compte
  Future<Utilisateur>Connect(String email, String password) async{
     UserCredential credential = await auth.signInWithEmailAndPassword(email: email, password: password);
     User? user = credential.user;
     if(user == null){return Future.error("erreur");}
     else {
       String uid = user.uid;
       return getUser(uid);
     }



  }

  //ajouter un utilisateur
 addUser(String id, Map<String,dynamic> map){
    cloudUsers.doc(id).set(map);

 }


//supprimer un utlisateur



//mise à jour des infos utlisateurs
 updateUser(String id,Map<String,dynamic> data){
    cloudUsers.doc(id).update(data);
 }


//ajouter un message



//supprimer un message


// upload une image
Future<String>stockageImage({required String dossier,required String dossierPersonnel,required String nameImage, required Uint8List bytesImage}) async{
     String url = "";
     TaskSnapshot taskSnapshot = await storage.ref("$dossier/$dossierPersonnel/$nameImage").putData(bytesImage);
     url = await taskSnapshot.ref.getDownloadURL();
     return url;
   }






}