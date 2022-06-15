import 'package:cloud_firestore/cloud_firestore.dart';

// Constructeur de la classe utilisateur via Firebase

class UserModel {
  //Attributs
  late String id ;
  late String lastname;
  late String firstname;
  late String email;
  String? avatar;
  String? pseudo;
  DateTime created_at =  DateTime.now();

  //Constructor
  UserModel(DocumentSnapshot snapshot){
    String? provisoire;
    id = snapshot.id;
    Map<String,dynamic> map = snapshot.data() as Map<String,dynamic>;
    lastname = map["LASTNAME"];
    firstname = map["FIRSTNAME"];
    email = map["EMAIL"];
    provisoire = map["AVATAR"];
    if (provisoire == null) {
      avatar = "https://firebasestorage.googleapis.com/v0/b/ipssia3bdfirstapplication.appspot.com/o/icon.png?alt=media&token=c3d7cb1c-1d44-4bca-aeb8-63f08d559926";
    } else {
      avatar = provisoire;
    }
    provisoire = map["PSEUDO"];
    if (provisoire == null) {
      pseudo = "";
    } else {
      pseudo = provisoire;
    }
    Timestamp timestamp = map["CREATED_AT"];
    created_at = timestamp.toDate();

  }

  //Deuxième constructeur qui affecter les valeurs à vide
  UserModel.empty(){
    id = "";
    lastname = "";
    firstname = "";
    email = "";
    avatar = "";
    pseudo = "";
    created_at = DateTime.now();
  }


  String completeName() {
    return firstname + " " + lastname;
  }







}