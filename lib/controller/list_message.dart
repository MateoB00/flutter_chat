import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:digitaldschool/globale.dart';
import '../model/message.dart';
import '../model/utilisateur.dart';
import 'FirestoreHepler.dart';

class ListMessages extends StatefulWidget {
  const ListMessages({Key? key}) : super(key: key);

  @override
  State<ListMessages> createState() => _ListMessagesState();
}

class _ListMessagesState extends State<ListMessages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Envoyer un message à ${widget.user.fullName}'),
      // ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirestoreHelper().cloudMessage.snapshots(),
              builder: (context, snap) {
                List documents = snap.data?.docs ?? [];
                if (documents.isEmpty) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                } else {
                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      Message message = Message(documents[index]);
                      if (message.receiver.id == monUtilisateur.id &&
                              message.sender.id == selectedUtilisateur.id ||
                          message.receiver.id == selectedUtilisateur.id &&
                              message.sender.id == monUtilisateur.id) {
                        return Card(
                            elevation: 5,
                            color: Colors.purple,
                            child: ListTile(
                              title: Text(message.content),
                            ));
                      }
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Message',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                  onChanged: (value) {
                    // setState(() {
                    //   _message = value;
                    // });
                  },
                ),
                SizedBox(height: 16),
                // ElevatedButton(
                //   onPressed: _message.isEmpty ? null : _sendMessage,
                //   child: Text('Envoyer'),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
