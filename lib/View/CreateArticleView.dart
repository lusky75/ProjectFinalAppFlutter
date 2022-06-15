import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projet_final_app_flutter/View/ArticlesView.dart';
import 'package:projet_final_app_flutter/View/MyDrawerView.dart';
import 'package:projet_final_app_flutter/Services/FirestoreHelper.dart';
import 'package:projet_final_app_flutter/Services/librairies.dart';
import 'package:intl/intl.dart';

class CreateArticleView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CreateArticleViewState();
  }
}

class CreateArticleViewState extends State<CreateArticleView> {
  String article_id = "";
  String title = "";
  String description = "";
  DateTime created_at = DateTime.now();

  final _myArticleTitleController = TextEditingController();
  final _myArticleDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    article_id = selectedArticle.id;
    title = selectedArticle.title;
    description = selectedArticle.description;

    _myArticleTitleController.text = title;
    _myArticleDescriptionController.text = description;
  }

  //Functions
  createArticle(){
    FirestoreHelper().createArticle(title, description, created_at, GlobalUser.pseudo ?? "", GlobalUser.id).then((value){
      Navigator.push(context, MaterialPageRoute(
          builder: (context){
            return ArticlesView();
          }
      ));

    }).catchError((error){
      //Par exemple une perte de connexion
      print(error);
    });
  }

  updateArticle() {
    Map<String,dynamic> map = {
      "TITLE": title,
      "DESCRIPTION": description,
    };
    FirestoreHelper().updateArticle(article_id, map);
    Navigator.push(context, MaterialPageRoute(
        builder: (context){
          return ArticlesView();
        }
    ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title : const Text("Create your article"),
          backgroundColor: Colors.black38,
        ),
        body: Center(
            child:
            Column(
              children: <Widget>[
                Text("Title"),
                TextField(
                  onChanged : (String value) {
                    setState(() {
                      title = value;
                    });
                  },
                  controller: _myArticleTitleController,
                ),
                Text("Description"),
                Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged : (String value) {
                          setState(() {
                            description = value;
                          });
                        },
                        controller: _myArticleDescriptionController,
                        maxLines: 8, //or null
                        decoration: InputDecoration.collapsed(hintText: "Enter your text here"),
                      ),
                    )
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (title.length == 0 && description.length == 0) {
                      return;
                    }
                    if (article_id != "") {
                      await updateArticle();
                    } else {
                      await createArticle();
                    }
                  },
                  icon: Icon( // <-- Icon
                    Icons.edit,
                    size: 24.0,
                  ),
                  label: Text('Submit the article'), // <-- Text
                ),
              ],
            )
        )
    );
  }

}
