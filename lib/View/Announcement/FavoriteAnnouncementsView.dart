import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projet_final_app_flutter/Component/MyDrawerView.dart';
import 'package:projet_final_app_flutter/Services/FirestoreHelper.dart';
import 'package:projet_final_app_flutter/Model/AnnouncementModel.dart';
import 'package:projet_final_app_flutter/View/Announcement/CreateAnnouncementView.dart';
import 'package:projet_final_app_flutter/Services/librairies.dart';

import '../../Model/FavoriteModel.dart';

class FavoriteAnnouncementsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FavoriteAnnouncementsViewState();
  }
}

class FavoriteAnnouncementsViewState extends State<FavoriteAnnouncementsView> {

  String dropdownValue = 'Sort: Newest';
  bool announcementOrderByNewest = true;

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

        appBar : AppBar(
          title : const Text("My favorites"),
          backgroundColor: Colors.black38,
        ),
        body:
        SafeArea(child:
        Stack(children: [
          Padding(padding: EdgeInsets.all(20), child: dropdownSelectButton()),

          Padding(padding: EdgeInsets.only(top: 60), child: bodyPage()),

          Align
            (
              alignment: Alignment.bottomRight,
              child:
              Padding(padding: const EdgeInsets.all(20) ,
                child:
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context,  MaterialPageRoute(
                        builder: (context){
                          selectedAnnouncement = AnnouncementModel.empty();
                          return CreateAnnouncementView();
                        })
                    );
                  },
                  icon: Icon( // <-- Icon
                    Icons.edit,
                    size: 24.0,
                  ),
                  label: Text('Write a new announcement'), // <-- Text
                ),
              )
          )
        ],),
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

  /*
    The bodyPage display list of current user's article.
    For each announcement's if user.id == announcement.user_uid => it shows a Card
    Else an empty Container
   */
  Widget bodyPage(){
    return StreamBuilder<QuerySnapshot>(
      //On cherche tous les documentssnpshots de l'utilisateur dans la bdd
        //stream: FirestoreHelper().fire_favorites.orderBy('CREATED_AT', descending: announcementOrderByNewest).snapshots(),
        stream: FirestoreHelper().fire_favorites.where('USER_UID', isEqualTo: GlobalUser.id).snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            // Il n'y aucune donnée dans la BDD
            return const CircularProgressIndicator.adaptive();
          } else {
            List documents = snapshot.data!.docs;
            return
              ListView.builder
                (
                //gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  padding: EdgeInsets.all(20),
                  itemCount: documents.length,
                  itemBuilder: (context,index) {
                    FavoriteModel favorite = FavoriteModel(documents[index]);
                    print("1. ${favorite.user_uid}");

                    return FutureBuilder(
                        future: FirestoreHelper().getFavoriteAnnouncements(favorite.user_uid, favorite.announcement_id),
                        builder: (BuildContext context, AsyncSnapshot secondSnapshot) {
                          if (!secondSnapshot.hasData) {
                            return Container();
                          }
                          AnnouncementModel announcement = secondSnapshot.data;

                          String author_pseudo = "";
                          if (!snapshot.hasData) {
                            return Container();
                            //author_pseudo = announcement.author_pseudo;
                          } else {
                          }
                          return Dismissible(
                              direction: DismissDirection.endToStart,
                              onDismissed: (DismissDirection direction) {
                            /**
                                Delete the article when the card is dismissed from right to left
                             */
                            FirestoreHelper().deleteFavoriteAnnouncement(announcement.id, GlobalUser.id);
                          },
                          key: Key(announcement.id),
                          child:
                            Column(children: [
                            Card(
                              elevation: 10,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                onTap: () {
                                },
                                title: Text("${announcement.title}"),
                                subtitle: Text("${announcement.description}"),
                                trailing: Text("${announcement.price}"),
                              ),
                            ),
                            Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text("${getArticleDateFormat(
                                        announcement.created_at)}")
                                )
                            )
                          ],)
                          );
                        }
                    );
                  });
          }
        }
    );
  }


}
