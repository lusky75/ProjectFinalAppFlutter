import 'package:cloud_firestore/cloud_firestore.dart';

// Constructor of class Article by Firebase

class FavoriteModel {
  //Attributs
  late String id;
  late String user_uid;
  late String announcement_id;

  //Constructor
  FavoriteModel(DocumentSnapshot snapshot){
    id = snapshot.id;
    Map<String,dynamic> map = snapshot.data() as Map<String,dynamic>;
    user_uid = map["USER_UID"];
    announcement_id = map["ANNOUNCEMENT_ID"];
  }

  //Deuxième constructeur qui affecter les valeurs à vide
  FavoriteModel.empty(){
    id = "";
    user_uid = "";
    announcement_id = "";
  }

}