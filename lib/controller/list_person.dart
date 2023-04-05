import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:digitaldschool/globale.dart';
import '../model/utilisateur.dart';
import 'FirestoreHepler.dart';

class ListPerson extends StatefulWidget {
  const ListPerson({Key? key}) : super(key: key);

  @override
  State<ListPerson> createState() => _ListPersonState();
}

class _ListPersonState extends State<ListPerson> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreHelper().cloudUsers.snapshots(),
      builder: (context, snap) {
        List documents = snap.data?.docs ?? [];
        if (documents.isEmpty){
          return const Center(
            child: CircularProgressIndicator.adaptive()
          );
        } else {
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              Utilisateur otherUser = Utilisateur(documents[index]);
              if (monUtilisateur.id == otherUser.id) {
                return Container();
              }
              return Card(
                elevation: 5,
                color: Colors.purple,
                child:               ListTile(
                onTap: () {

                  print('fdsokfqdskf');
                },
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(otherUser.avatar!),
                ),
                title: Text(otherUser.fullName),
                subtitle: Text(otherUser.email),
              ) 
              );
            }
          );
        }
      }
    );
  }
}