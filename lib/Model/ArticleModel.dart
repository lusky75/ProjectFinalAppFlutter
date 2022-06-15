import 'package:cloud_firestore/cloud_firestore.dart';

// Constructor of class Article by Firebase

class ArticleModel {
  //Attributs
  late String id ;
  late String title;
  late String description;
  late String author_pseudo;
  late String user_uid;
  DateTime created_at =  DateTime.now();

  //Constructor
  ArticleModel(DocumentSnapshot snapshot){
    String? provisoire;
    id = snapshot.id;
    Map<String,dynamic> map = snapshot.data() as Map<String,dynamic>;
    title = map["TITLE"];
    description = map["DESCRIPTION"];
    user_uid = map["USER_UID"];
    provisoire = map["AUTHOR_PSEUDO"];
    if (provisoire == null) {
      author_pseudo = "";
    } else {
      author_pseudo = provisoire;
    }
    Timestamp timestamp = map["CREATED_AT"];
    created_at = timestamp.toDate();
  }

  //Deuxième constructeur qui affecter les valeurs à vide
  ArticleModel.empty(){
    id = "";
    title = "";
    description = "";
    author_pseudo = "";
    created_at = DateTime.now();
  }

}