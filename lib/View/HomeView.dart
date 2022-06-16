import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projet_final_app_flutter/Model/AnnouncementModel.dart';
import 'package:projet_final_app_flutter/Services/FirestoreHelper.dart';
import 'package:projet_final_app_flutter/Component/MyDrawerView.dart';
import 'package:projet_final_app_flutter/Services/librairies.dart';
import 'package:intl/intl.dart';

import '../Model/UserModel.dart';

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState(){
    return HomeViewState();
  }
}

class HomeViewState extends State<HomeView>{
  final dateformat = new DateFormat('yyyy-MM-dd hh:mm');
  String dropdownValue = 'Sort: Newest';
  bool announcementOrderByNewest = true;

  UserModel userModel = UserModel.empty();

  @override
  Widget build(BuildContext context){
    return Scaffold(
        drawer: Container(
          width: MediaQuery.of(context).size.width / 1.5,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: MyDrawerView(),
        ),

        appBar : AppBar(
          title : const Text("Home"),
          backgroundColor: Colors.black38,
        ),
        backgroundColor: Colors.white,
        body : SafeArea(child:
          Stack(children: [
            Padding(padding: EdgeInsets.all(20), child: dropdownSelectButton()),
            Padding(padding: EdgeInsets.only(top: 60), child: bodyPage()),]
          )
        )
    );
  }

  Widget dropdownSelectButton() {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.blueGrey),
      underline: Container(
        height: 2,
        color: Colors.blueAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          announcementOrderByNewest = !announcementOrderByNewest;

        });
      },
      items: <String>['Sort: Newest', 'Sort: Oldest']

          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget bodyPage(){
    return StreamBuilder<QuerySnapshot>(
        stream: FirestoreHelper().fire_announcements.orderBy('CREATED_AT', descending: announcementOrderByNewest).snapshots(),
        builder: (context, snapshot){
            if (!snapshot.hasData) {
                // Il n'y aucune donnée dans la BDD
                return const CircularProgressIndicator.adaptive();
            } else {
                List documents = snapshot.data!.docs;
                return ListView.builder(
                  //gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                    padding: EdgeInsets.all(20),
                    itemCount: documents.length,
                    itemBuilder: (context,index){
                        AnnouncementModel article = AnnouncementModel(documents[index]);
                        return FutureBuilder(
                            future: FirestoreHelper().getUserPseudoFromAnnouncement(article.user_uid),
                            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                String author_pseudo = "";
                                if (!snapshot.hasData) {
                                    author_pseudo = article.author_pseudo;
                                } else {
                                    author_pseudo = snapshot.data.toString();
                                }
                                return Column(children: [
                                    Card(
                                        elevation: 10,
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)),
                                        child: ListTile(
                                          onTap: () {
                                          },
                                          title: Text(article.title),
                                          subtitle: Text(article.description),
                                          trailing: Text("${article.price} €"),
                                        ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.favorite),
                                      color: Colors.red,
                                      onPressed: () {
                                          FirestoreHelper().createFavorite(article.id, GlobalUser.id);
                                      },
                                    ),
                                    Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text("${getArticleDateFormat(
                                                article.created_at)} by "
                                                "${author_pseudo}")
                                        )
                                    )
                                ],);
                            }
                        );
                    },
                );
            }
        }
    );
  }
}