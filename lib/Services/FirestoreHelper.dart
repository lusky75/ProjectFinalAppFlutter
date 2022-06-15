import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:projet_final_app_flutter/Model/ArticleModel.dart';
import 'package:projet_final_app_flutter/Model/UserModel.dart';

class FirestoreHelper{

  //Attributs
  final auth = FirebaseAuth.instance;
  final fire_users = FirebaseFirestore.instance.collection("Users");
  final fire_articles = FirebaseFirestore.instance.collection("Articles");

  final storage = FirebaseStorage.instance;

  //User methods
  Future <UserModel> createUser(String lastname, DateTime created_at, String password, String email, String firstname) async {
    UserCredential resultat = await auth.createUserWithEmailAndPassword(email: email, password: password);
    User userFirebase = resultat.user!;
    String uid = userFirebase.uid;
    Map<String,dynamic> map = {
      "EMAIL": email,
      "AVATAR" : null,
      "PSEUDO" : null,
      "FIRSTNAME" : firstname,
      "LASTNAME": lastname,

      "CREATED_AT": created_at,

    };
    addUser(uid, map);
    return getUser(uid);

  }

  Future <UserModel> connectUser(String mail , String password) async {
    UserCredential resultat =  await auth.signInWithEmailAndPassword(email: mail, password: password);
    String uid = resultat.user!.uid;
    return getUser(uid);

  }


  Future <UserModel> getUser( String uid) async {
    DocumentSnapshot snapshot = await fire_users.doc(uid).get();
    return UserModel(snapshot);

  }

  String getIdentifant(){
    return auth.currentUser!.uid;
  }



  addUser(String uid , Map<String,dynamic> map){
    fire_users.doc(uid).set(map);
  }

  updateUser(String uid , Map<String,dynamic> map){
    fire_users.doc(uid).update(map);
  }

  deleteUser(String uid){
    fire_users.doc(uid).delete();
  }

  // Image storage method
  Future <String> stockageImage(Uint8List bytes, String name) async {
    String nameFinal = name+getIdentifant();
    String url = "";
    //Stockage de l'image dans la bdd
    print("storage: ${storage.ref("ProfileImage")}");
    TaskSnapshot taskSnapshot = await storage.ref("/ProfileImage").child(nameFinal).putData(bytes);

    print("storage2: ${taskSnapshot}");
    //récupération du lien de l'image dans la bdd
    url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  // Article methods
  createArticle(String title, String description, DateTime created_at, String author_pseudo, String user_id) async {
    Map<String,dynamic> map = {
      "TITLE": title,
      "DESCRIPTION" : description,
      "CREATED_AT" : created_at,
      "AUTHOR_PSEUDO" : author_pseudo,
      "USER_UID" : user_id
    };
    await addArticle(user_id, map);
  }

  addArticle(String uid , Map<String,dynamic> map) {
    fire_articles.add(map);
  }









}