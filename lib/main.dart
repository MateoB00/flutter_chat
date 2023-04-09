import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitaldschool/controller/FirestoreHepler.dart';
import 'package:digitaldschool/controller/home_page.dart';
import 'package:digitaldschool/controller/permission_helper.dart';
import 'package:digitaldschool/globale.dart';
import 'package:digitaldschool/view/dashboard_view.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';
import 'model/utilisateur.dart';
import 'package:lottie/lottie.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PermissionHelper().init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //variables
  TextEditingController mail = TextEditingController();
  TextEditingController  password = TextEditingController();
  TextEditingController  prenom = TextEditingController();
  TextEditingController  nom = TextEditingController();
  TextEditingController message = TextEditingController();
  List<bool> selection = [true,false];



  //Méthode
  popUp(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          if (defaultTargetPlatform == TargetPlatform.iOS){
            return CupertinoAlertDialog(
              title: const Text("Erreur"),
              content: const Text("Votre email et/ou votre mot de passe sont incorrectes"),
              actions: [
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text("ok")
                )
              ],

            );
          }
          else
            {
              return AlertDialog(
                title: const Text("Erreur"),
                content: const Text("Votre email et/ou votre mot de passe sont incorrectes"),
                actions: [
                  TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: const Text("ok")
                  )
                ],
              );
            }
        }
    );
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(

        title: const Text("Chat en ligne MyDigitalSchool"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: bodyPage(),
      )
    );
  }


  Widget bodyPage(){
    //image
    //entrer mail
    //entrer le mot de passe
    //bouton de validation

    // Row --> met les élements en ligne
    //Stack --> empile le widgets
    //Text
    //ElevatedButton
    //Container
    //Image
    //Texfield
    //Icon
    //listView
     return Column(

      children: [
  Padding(
    padding: const EdgeInsets.all(10.0),
    child: ToggleButtons(
          selectedColor: Color.fromARGB(255, 76, 89, 175),
          onPressed: (int choix){
            if(choix == 0){
              setState(() {
                selection[0]=true;
                selection[1]= false;
              });

            }
            else
              {
                setState(() {
                  selection[0]=false;
                  selection[1]= true;
                });

              }
          },
            isSelected: selection,
            children: const [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("Connexion"),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("Inscription"),
    ),
  ],
    )
        
        ),
        //image
        const SizedBox(height:10),
        
        Lottie.asset(
  'assets/chat1.json',
  width: MediaQuery.of(context).size.width * 0.5, // réduit la largeur de l'animation de moitié
  height: MediaQuery.of(context).size.height * 0.5, // réduit la hauteur de l'animation de moitié
 
),
        const SizedBox(height:10),


        //prenom

        (selection[0] == false)?TextField(
          controller: prenom,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
              hintText: "Entrer votre prénom"
          ),
        ):Container(),
        const SizedBox(height:10),



        //nom

        (selection[0]==false)?TextField(
          controller: nom,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
              hintText: "Entrer votre nom"
          ),
        ):Container(),
        const SizedBox(height:10),

        //mail
        TextField(
          controller: mail,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20)
            ),
            hintText: "Entrer votre mail"
          ),
        ),
        const SizedBox(height:10),


        //password
        TextField(
          controller: password,
          obscureText: true,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
              hintText: "Entrer votre password"
          ),
        ),
        const SizedBox(height:10),


        //bouton
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder()
          ),
            onPressed: (){

              if(selection[0]== false){
                //si on en mode inscription
                FirestoreHelper().Inscription(mail.text, password.text, nom.text, prenom.text).then((value) {
                  //si la méthode fonctionne bien
                  setState(() {
                    monUtilisateur = value;
                  });
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context){
                        return DashBoardView(mail: mail.text, password: password.text);
                      }
                  ));


                }).catchError((onError){
                  //si on constate une erreur
                  popUp();

                });
              }
              else
                {
                  //si en mode connexion
                  FirestoreHelper().Connect(mail.text, password.text).then((value){
                    setState(() {
                      monUtilisateur = value;
                    });
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context){
                          return DashBoardView(mail: mail.text, password: password.text);
                        }
                    ));
                  }).catchError((onError){
                    popUp();
                  });
                }




            },

            
            child: const Text("Validation")
            
        ),

              
      ],
    );
  }
}
