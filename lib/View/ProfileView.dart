import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projet_final_app_flutter/View/MyDrawerView.dart';
import 'package:projet_final_app_flutter/Services/FirestoreHelper.dart';
import 'package:projet_final_app_flutter/Services/librairies.dart';
import 'package:intl/intl.dart';

import 'CreateAnnouncementView.dart';

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
          width: MediaQuery.of(context).size.width / 1.5,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: MyDrawerView(),
        ),

        appBar: AppBar(
          title : const Text("My profile"),
          backgroundColor: Colors.black38,
        ),
        body: Center(
          child:
          Column(children: [
            SizedBox(height: 20),
            Text("${GlobalUser.firstname}, ${GlobalUser.lastname}",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold
              )
            ),
            SizedBox(height: 20),
            Text("Pseudo: ${GlobalUser.pseudo}"),
            SizedBox(height: 20),
            Text("Email: ${GlobalUser.email}"),
            SizedBox(height: 20),
            Text("Account created: ${getArticleDateFormat(GlobalUser.created_at)}"),

            /*
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context,  MaterialPageRoute(
                    builder: (context){
                      return  //ProfileFormView();
                    })
                );
              },
              icon: Icon( // <-- Icon
                Icons.edit,
                size: 24.0,
              ),
              label: Text('Edit my profile'), // <-- Text
            ),

             */
          ])
        )
    );
  }

}
