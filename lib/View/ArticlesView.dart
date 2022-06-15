import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projet_final_app_flutter/View/MyDrawerView.dart';
import 'package:projet_final_app_flutter/Services/FirestoreHelper.dart';
import 'package:projet_final_app_flutter/Model/ArticleModel.dart';
import 'package:projet_final_app_flutter/Services/librairies.dart';
import 'package:intl/intl.dart';

class ArticlesView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ArticlesViewState();
  }
}

class ArticlesViewState extends State<ArticlesView> {
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

      appBar : AppBar(
        title : const Text("My articles"),
        backgroundColor: Colors.black38,
      ),
      body: bodyPage()
    );
  }

  /*
    The bodyPage display list of current user's article.
    For each article's if user.id == article.user_uid => it shows a Card
    Else an empty Container
   */

  Widget bodyPage(){
    return StreamBuilder<QuerySnapshot>(
      //On cherche tous les documentssnpshots de l'utilisateur dans la bdd
        stream: FirestoreHelper().fire_articles.snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            // Il n'y aucune donnée dans la BDD
            return const CircularProgressIndicator.adaptive();
          } else {
            List documents = snapshot.data!.docs;
            return ListView.builder(
              //gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              padding: EdgeInsets.all(20),
              itemCount: documents.length,
              itemBuilder: (context,index){
                ArticleModel article = ArticleModel(documents[index]);
                if (GlobalUser.id == article.user_uid) {
                  return Dismissible(

                      direction: DismissDirection.endToStart,
                      onDismissed: (DismissDirection direction) {
                        FirestoreHelper().deleteUser(article.id);
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
                            },
                            title: Text(article.title),
                            subtitle: Text(article.description),
                            //leading: Image.network(user.avatar!),

                            //leading: Text("${article.created_at}"),
                          ),

                        ),
                        Text("Le ${DateFormat.yMMMd().format(article.created_at)}"),
                      ],)
                  );
                } else {
                  return Container();
                }
              },
            );
          }
        }
    );
  }


}
