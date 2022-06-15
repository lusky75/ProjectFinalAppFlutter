import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projet_final_app_flutter/View/MyDrawerView.dart';
import 'package:projet_final_app_flutter/Services/FirestoreHelper.dart';
import 'package:projet_final_app_flutter/Services/librairies.dart';
import 'package:intl/intl.dart';

class ProfileView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfileViewState();
  }
}

class ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        drawer: Container(
          width: MediaQuery.of(context).size.width/2,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: MyDrawerView(),
        ),

        appBar: AppBar(
          title : const Text("Mon profil"),
          backgroundColor: Colors.black38,
        ),
        body: Center(
          child:
          Column(children: [
            Text("${GlobalUser.firstname}, ${GlobalUser.lastname}",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold
              )
            ),
            Text("${GlobalUser.pseudo}"),
            Text("${GlobalUser.email}"),
            Text("${GlobalUser.created_at}")
          ])
        )
    );
  }

}
