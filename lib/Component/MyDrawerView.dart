import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projet_final_app_flutter/Services/FirestoreHelper.dart';
import 'package:projet_final_app_flutter/Services/global.dart';
import 'package:file_picker/file_picker.dart';
import 'package:projet_final_app_flutter/View/Announcement/AnnouncementsView.dart';
import 'package:projet_final_app_flutter/View/HomeView.dart';
import 'package:projet_final_app_flutter/View/Profile/ProfileView.dart';
import 'package:projet_final_app_flutter/main.dart';
import 'package:projet_final_app_flutter/Model/UserModel.dart';

import '../View/Announcement/FavoriteAnnouncementsView.dart';

class MyDrawerView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyDrawerViewState();
  }

}

class MyDrawerViewState extends  State<MyDrawerView>{
  //Variable
  String? nomImage;
  String? urlImage;
  Uint8List? bytesImage;
  bool isEditing = false;
  String pseudoTempo="";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
      SafeArea(child: Drawer
        (
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            InkWell
              (
              child: Container
                (
                height: 80,
                decoration: BoxDecoration
                  (
                  shape: BoxShape.circle,
                  image: DecorationImage
                    (
                      image: NetworkImage(GlobalUser.avatar!),
                      fit: BoxFit.fitHeight
                  ),
                ),
              ),
              onTap: (){
                pickImage();
              },
            ),

            //Pseudo qui pourra changer
            TextButton.icon(

                onPressed: (){

                  if (isEditing == true){
                    setState(() {
                      GlobalUser.pseudo = pseudoTempo;
                      Map<String,dynamic> map = {
                        "PSEUDO": pseudoTempo
                      };
                      FirestoreHelper().updateUser(GlobalUser.id, map);
                    });

                  }
                  setState(() {
                    isEditing = !isEditing;
                  });

                } ,
                icon: (isEditing)?const Icon(Icons.check,color: Colors.green,):const Icon(Icons.edit),
                label: (isEditing)?TextField(
                  decoration: const InputDecoration(
                    hintText: "Entrer le pseudo",
                  ),
                  onChanged: (newValue){
                    setState(() {
                      pseudoTempo=newValue;
                    });
                  },

                ):
                Text(GlobalUser.pseudo!)
            ),
            // nom et prénom complet
            Center(child:
              Text(GlobalUser.completeName())
            ),

            SizedBox(height: 20),

            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => {
                Navigator.push(context,  MaterialPageRoute(
                    builder: (context){
                      return HomeView();
                    })
                )
              },
            ),

            ListTile(
              leading: Icon(Icons.border_color),
              title: Text('My announcements'),
              onTap: () => {
                Navigator.push(context,  MaterialPageRoute(
                    builder: (context){
                      return AnnouncementsView();
                    })
                )
              },
            ),

            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('My favorites'),
              onTap: () => {
                Navigator.push(context,  MaterialPageRoute(
                    builder: (context){
                      return FavoriteAnnouncementsView();
                    })
                )
              },
            ),

            ListTile(
              leading: Icon(Icons.verified_user),
              title: Text('My profile'),
              onTap: () => {
                Navigator.push(context,  MaterialPageRoute(
                    builder: (context){
                      return ProfileView();
                    })
                )
              },
            ),

            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                GlobalUser = UserModel.empty();
                Navigator.push(context,  MaterialPageRoute(
                  builder: (context){
                    return MyApp();
                  })
                );
              }
            ),
          ],
        ),
      )
      );
  }

  //Fonction

  //Choisir l'image
  Future pickImage() async{
    FilePickerResult? resultat = await FilePicker.platform.pickFiles(
        withData: true,
        type: FileType.image
    );
    if (resultat != null){
      nomImage = resultat.files.first.name;
      bytesImage = resultat.files.first.bytes;
      MyPopUp();

    }



  }

  //Création de notre popUp
  MyPopUp(){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context){
          if(Platform.isIOS){
            return CupertinoAlertDialog(
              title: const Text("Mon image"),
              content: Image.memory(bytesImage!),
              actions: [
                ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  onPressed: (){
                    //Stocker et on va récupérer son url
                    FirestoreHelper().stockageImage(bytesImage!, nomImage!).then((value){
                      setState(() {
                        GlobalUser.avatar = value;
                        urlImage = value;
                      });
                      //Mettre à jour notre base de donnée en stockant l'url
                      Map<String,dynamic> map ={
                        //Key : Valeur
                        "AVATAR":urlImage
                      };
                      FirestoreHelper().updateUser(GlobalUser.id, map);
                      Navigator.pop(context);
                    });
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          }
          else {
            return AlertDialog(
              title: const Text("Mon image"),
              content: Image.memory(bytesImage!),
              actions: [
                ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  onPressed: (){
                    //Stocker et on va récupérer son url
                    FirestoreHelper().stockageImage(bytesImage!, nomImage!).then((value){
                      setState(() {
                        GlobalUser.avatar = value;
                        urlImage = value;
                      });
                      //Mettre à jour notre base de donnée en stockant l'url
                      Map<String,dynamic> map ={
                        //Key : Valeur
                        "AVATAR":urlImage
                      };
                      FirestoreHelper().updateUser(GlobalUser.id, map);



                      Navigator.pop(context);
                    });
                  },
                  child: const Text("Enregistrement"),
                ),
              ],

            );
          }
        }
    );
  }



}