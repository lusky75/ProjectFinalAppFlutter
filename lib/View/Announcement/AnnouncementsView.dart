import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projet_final_app_flutter/Component/MyDrawerView.dart';
import 'package:projet_final_app_flutter/Services/FirestoreHelper.dart';
import 'package:projet_final_app_flutter/Model/AnnouncementModel.dart';
import 'package:projet_final_app_flutter/View/Announcement/CreateAnnouncementView.dart';
import 'package:projet_final_app_flutter/Services/librairies.dart';

class AnnouncementsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AnnouncementsViewState();
  }
}

class AnnouncementsViewState extends State<AnnouncementsView> {

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
        title : const Text("My announcements"),
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
        stream: FirestoreHelper().fire_announcements.orderBy('CREATED_AT', descending: announcementOrderByNewest).snapshots(),
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
                  itemBuilder: (context,index){
                    AnnouncementModel article = AnnouncementModel(documents[index]);
                    if (GlobalUser.id == article.user_uid)
                    {
                      return Dismissible(
                          direction: DismissDirection.endToStart,
                          onDismissed: (DismissDirection direction) {
                            /**
                            Delete the article when the card is dismissed from right to left
                             */
                            FirestoreHelper().deleteAnnouncement(article.id);
                          },
                          key: Key(article.id),
                          child: Column(children: [
                            Card(
                              elevation: 10,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                onTap: () {
                                  /**
                                    Action called when the ListTile is selected
                                    It fills data of article to selectedArticle and navigate to CreateArticleView
                                   */
                                  Navigator.push(context,  MaterialPageRoute(
                                      builder: (context){
                                        selectedAnnouncement = article;
                                        return CreateAnnouncementView();
                                      })
                                  );
                                },
                                title: Text(article.title),
                                subtitle: Text(article.description),
                                trailing: Text("${article.price} €"),
                              ),

                            ),
                          Align
                            (
                              alignment: Alignment.bottomRight,
                              child:
                              Padding(padding: const EdgeInsets.all(10) ,
                                child:
                                Text("${getArticleDateFormat(article.created_at)}")
                              )
                          )
                          ],)
                      );
                  } else {
                    return Container();
                  }
              });
          }
        }
    );
  }


}
