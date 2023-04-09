import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
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
  TextEditingController contentMessage = TextEditingController();

  late TextEditingController messageATraduire;
  late LanguageIdentifier _languageIdentifier;
  late OnDeviceTranslator translator;
  String simpleLang = "";
  String mutlipleLang = "";
  String traductionText = "";

  getUniqueLanguage() async {
    simpleLang = "";
    String phrase = messageATraduire.text;
    if (phrase == "") return;
    final langage = await _languageIdentifier.identifyLanguage(phrase);
    setState(() {
      simpleLang = langage;
    });
  }

  getMultipleLanguage() async {
    mutlipleLang = "";
    String phrase = messageATraduire.text;
    if (phrase == "") return;
    final multiple =
        await _languageIdentifier.identifyPossibleLanguages(phrase);
    if (multiple.isEmpty) {
      setState(() {
        mutlipleLang = "Nous n'avons pas trouvé aucune correspondance";
      });
    } else {
      for (var lang in multiple) {
        setState(() {
          mutlipleLang +=
              "${lang.languageTag}, avec une confiance de : ${lang.confidence * 100}%";
        });
      }
    }
  }

  traduction() async {
    traductionText = "";
    if (messageATraduire == "") return;
    String phrase = messageATraduire.text;
    final tr = await translator.translateText(phrase);
    setState(() {
      traductionText = tr;
    });
  }

  @override
  void initState() {
    messageATraduire = TextEditingController();
    _languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.3);
    translator = OnDeviceTranslator(
        sourceLanguage: TranslateLanguage.french,
        targetLanguage: TranslateLanguage.english);
    super.initState();
  }

  @override
  void dispose() {
    _languageIdentifier.close();
    translator.close();
    messageATraduire.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Envoyer un message à ${selectedUtilisateur.fullName}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirestoreHelper()
                  .cloudMessage
                  .orderBy('created_at')
                  .snapshots(),
              builder: (context, snap) {
                List documents = snap.data?.docs ?? [];
                if (documents.isEmpty) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                } else {
                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      Messages message = Messages(documents[index]);
                      // print('!------!');
                      // print(message.content);
                      // print('!------!');
                      // print(message.receiver.id);
                      // print('!------!');
                      // print(message.sender.id);
                      // print('!------!');
                      // print(monUtilisateur.id);
                      // print('!------!');
                      // print(selectedUtilisateur.id);
                      // if (message.receiver.id == monUtilisateur.id &&
                      //         message.sender.id == selectedUtilisateur.id ||
                      //     message.receiver.id == selectedUtilisateur.id &&
                      //         message.sender.id == monUtilisateur.id) {

                      print(traductionText);

                      if (message.receiver.id == monUtilisateur.id &&
                              message.sender.id == selectedUtilisateur.id ||
                          message.receiver.id == selectedUtilisateur.id &&
                              message.sender.id == monUtilisateur.id) {
                        // print('GOOOOOOD');
                        return Card(
                          child: Align(
                            alignment: message.sender.id == monUtilisateur.id
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: message.sender.id == monUtilisateur.id
                                    ? Colors.blue[200]
                                    : Colors.grey[300],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message.content,
                                    style: TextStyle(fontSize: 25),
                                  ),
                                  ElevatedButton(
                                    onPressed: traduction,
                                    child: Text(
                                      "Traduire de français en anglais",
                                    ),
                                  ),
                                  Text(traductionText)
                                ],
                              ),
                            ),
                          ),
                        );
                        // }
                      } else {
                        return Container();
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
                  controller: contentMessage,
                  decoration: InputDecoration(
                    labelText: 'Message',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        FirestoreHelper().sendMessage(monUtilisateur.email,
                            selectedUtilisateur.email, contentMessage.text);
                        contentMessage.clear();
                        // .then((value) {
                        //si la méthode fonctionne bien
                        // setState(() {
                        //   monUtilisateur = value;
                        // });
                        //   Navigator.push(context,
                        //       MaterialPageRoute(builder: (context) {
                        //     return DashBoardView(
                        //         mail: mail.text, password: password.text);
                        //   }));
                        // }).catchError((onError) {
                        //   //si on constate une erreur
                        //   popUp();
                        // });
                      },
                    ),
                  ),
                  maxLines: null,
                  // onChanged: (value) {
                  //   // setState(() {
                  //   //   _message = value;
                  //   // });
                  // },
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
