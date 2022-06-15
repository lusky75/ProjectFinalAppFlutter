import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projet_final_app_flutter/Model/ArticleModel.dart';
import 'package:projet_final_app_flutter/Services/FirestoreHelper.dart';
import 'package:projet_final_app_flutter/View/MyDrawerView.dart';

import 'package:intl/intl.dart';

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState(){
    return HomeViewState();
  }
}

class HomeViewState extends State<HomeView>{
  final dateformat = new DateFormat('yyyy-MM-dd hh:mm');

  @override
  Widget build(BuildContext context){
    return Scaffold(
        drawer: Container(
          width: MediaQuery.of(context).size.width/2,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: MyDrawerView(),
        ),

        appBar : AppBar(
          title : const Text("Home"),
          backgroundColor: Colors.black38,
        ),
        backgroundColor: Colors.white,
        body : bodyPage()
    );
  }

  Widget bodyPage(){
    return StreamBuilder<QuerySnapshot>(
      //On cherche tous les documentssnpshots de l'utilisateur dans la bdd
        stream: FirestoreHelper().fire_articles.snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            // Il n'y aucune donnée dans la BDD
            return const CircularProgressIndicator.adaptive();
          }
          else
          {
            //
            List documents = snapshot.data!.docs;
            return ListView.builder(
              //gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              padding: EdgeInsets.all(20),
              itemCount: documents.length,
              itemBuilder: (context,index){
                ArticleModel article = ArticleModel(documents[index]);
                  return Dismissible(

                    direction: DismissDirection.endToStart,
                    onDismissed: (DismissDirection direction){
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
                            //Détail de l'utilisateur

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
              },
            );
          }
        }
    );
  }
}