import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projet_final_app_flutter/View/MyDrawerView.dart';
import 'package:projet_final_app_flutter/Services/FirestoreHelper.dart';
import 'package:projet_final_app_flutter/Model/AnnouncementModel.dart';
import 'package:projet_final_app_flutter/View/CreateArticleView.dart';
import 'package:projet_final_app_flutter/Services/librairies.dart';

class AnnouncementsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AnnouncementsViewState();
  }
}

class AnnouncementsViewState extends State<AnnouncementsView> {
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
        title : const Text("My articles"),
        backgroundColor: Colors.black38,
      ),
      body:
        SafeArea(child:
          Stack(children: [
            bodyPage(),
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
                              return CreateArticleView();
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

  /*
    The bodyPage display list of current user's article.
    For each announcement's if user.id == announcement.user_uid => it shows a Card
    Else an empty Container
   */
  Widget bodyPage(){
    return StreamBuilder<QuerySnapshot>(
      //On cherche tous les documentssnpshots de l'utilisateur dans la bdd
        stream: FirestoreHelper().fire_announcements.snapshots(),
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
                                        return CreateArticleView();
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
