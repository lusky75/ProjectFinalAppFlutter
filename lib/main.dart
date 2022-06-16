import 'package:flutter/material.dart';

import 'package:projet_final_app_flutter/Services/FirestoreHelper.dart';
import 'package:projet_final_app_flutter/Services/global.dart';
import 'package:projet_final_app_flutter/View/HomeView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Component/CustomAlertDialog.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(title: 'Flutter project'),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has FirestoreHelper.dart State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in FirestoreHelper.dart Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String email = "";
  String password = "";
  String  firstname = "";
  String lastname = "";
  DateTime created_at = DateTime.now();
  bool isregister = false;
  List<bool> selection = [true,false];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(

          title: Text(widget.title),
        ),
        body: Padding(
          child : bodyPage(),
          padding : const EdgeInsets.all(10),

        )
    );
  }

  Widget bodyPage(){
    //Créer un design de connexion comportant des champs d'entrée et un bouton
    //3 éléments(adresse mail, mot de passe , bouton) + 1 élément de logo
    return Column(
      children : [
        //Logo

        Container(
          height : 80,
          decoration : const BoxDecoration(
              shape : BoxShape.circle,
              image : DecorationImage(
                  image : NetworkImage("https://medias.pourlascience.fr/api/v1/images/view/5d1b663a8fe56f77c8671165/wide_1300/image.jpg"),
                  fit : BoxFit.fill

              )
          ),
        ),
        const SizedBox(height : 10),
        //Choix pour l'utilisateur
        ToggleButtons(
          borderWidth: 1,
          borderColor: Colors.grey,
          children: const [
            Text("Register"),
            Text("Login")
          ],
          isSelected: selection,
          onPressed: (index) {
            if (index == 0) {
              setState(() {
                selection[0] = true;
                selection[1] = false;
                isregister = true;
              });
            } else {
              setState(() {
                selection[0] = false;
                selection[1] = true;
                isregister = false;
              });
            }
          },
        ),
        const SizedBox(height : 10),
        //Afficher le nom suivant les différents cas
        (isregister) ? TextField(
            decoration : InputDecoration(
                hintText : "Entrer votre nom",
                border : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                )
            ),
            onChanged : (String value){
              setState((){
                lastname = value;
              });
            }
        ): Container(),
        const SizedBox(height : 10),
        (isregister) ? TextField(
            decoration : InputDecoration(
                hintText : "Entrer votre prénom",
                border : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                )
            ),
            onChanged : (String value){
              setState((){
                firstname = value;
              });
            }
        ): Container(),

        //Champs adresse mail
        const SizedBox(height : 10),

        TextField(
            decoration : InputDecoration(
                hintText : "Entrez votre adresse mail",
                icon : const Icon(Icons.mail),
                border : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                )
            ),
            onChanged : (String value){
              setState((){
                email = value;
              });
            }
        ),

        //champs mot de passe
        const SizedBox(height : 10),
        TextField(
            obscureText : true,
            decoration : InputDecoration(
              hintText : "Entrez votre mot de passe",
              icon : const Icon(Icons.lock),
              border : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
            ),
            onChanged : (value){
              setState((){
                password = value;
              });
            }
        ),
        //Bouton
        const SizedBox(height : 10),

        ElevatedButton(
            onPressed : (){
              if (isregister == true) {
                  if (lastname.length == 0 || firstname.length == 0 || email.length == 0 || password.length == 0 ) {
                      _showMyDialog("Empty Fields", "");
                      return;
                  }
                  registerRequest();
              } else {
                  if (email.length == 0 || password.length == 0 ) {
                      _showMyDialog("Empty Fields", "");
                      return;
                  }
                  loginRequest();
              }
            },
            child : Text("Validate")
        )
      ],
    );
  }

  Future<void> _showMyDialog(String title, String description) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CustomAlertDialog(title, description);
      },
    );
  }

  //Fonction
  registerRequest(){
    FirestoreHelper().createUser(lastname, created_at, password, email, firstname).then((value){
      setState(() {
        isregister = !isregister;
      });

      Navigator.push(context, MaterialPageRoute(
          builder: (context){
            return MyApp();
          }
      ));
    }).catchError((error){
      _showMyDialog("Error register", "${error}");
    });
  }

  loginRequest(){
    FirestoreHelper().connectUser(email, password).then((value){
      Navigator.push(context, MaterialPageRoute(
          builder: (context){
            GlobalUser = value;
            return HomeView();
          }
      ));
    }).catchError((error){
      _showMyDialog("Error login", "${error}");
    });
  }
}