import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:projet_final_app_flutter/Model/AnnouncementModel.dart';
import 'package:projet_final_app_flutter/Model/UserModel.dart';

class FirestoreHelper {

  //Attributes
  final auth = FirebaseAuth.instance;
  final fire_users = FirebaseFirestore.instance.collection("Users");
  final fire_announcements = FirebaseFirestore.instance.collection("Announcements");
  final fire_favorites = FirebaseFirestore.instance.collection("Favorites");

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

  String getIdentifiant(){
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
    String nameFinal = name + getIdentifiant();
    String url = "";
    //Stockage de l'image dans la bdd
    print("storage: ${storage.ref("ProfileImage")}");
    TaskSnapshot taskSnapshot = await storage.ref("/ProfileImage").child(nameFinal).putData(bytes);

    print("storage2: ${taskSnapshot}");
    //récupération du lien de l'image dans la bdd
    url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  // Announcement methods

  createAnnouncement(String title, String description, double price, DateTime created_at, String author_pseudo, String user_id) async {
    Map<String,dynamic> map = {
      "TITLE": title,
      "DESCRIPTION" : description,
      "PRICE": price,
      "CREATED_AT" : created_at,
      "AUTHOR_PSEUDO" : author_pseudo,
      "USER_UID" : user_id
    };
    await addAnnouncement(user_id, map);
  }

  addAnnouncement(String uid , Map<String,dynamic> map) {
    fire_announcements.add(map);
  }

  updateAnnouncement(String announcement_id , Map<String,dynamic> map){
    fire_announcements.doc(announcement_id).update(map);
  }

  deleteAnnouncement(String id) {
    fire_announcements.doc(id).delete();
  }

  Future<String> getUserPseudoFromAnnouncement(String uid) async {
    DocumentSnapshot snapshot = await fire_users.doc(uid).get();
    return UserModel(snapshot).pseudo ?? "";
  }


  // Favorites methods
  Future <AnnouncementModel> getFavoriteAnnouncements(String uid, String a_id) async {
    AnnouncementModel announcementModel = AnnouncementModel.empty();

    QuerySnapshot query = await fire_favorites.where("USER_UID", isEqualTo: uid)
        .where("ANNOUNCEMENT_ID", isEqualTo: a_id)
        .get();
    var element = query.docs[0];
    String announcement_id = element["ANNOUNCEMENT_ID"];
    DocumentSnapshot snapshot = await fire_announcements.doc(announcement_id).get();
    announcementModel = AnnouncementModel(snapshot);
    return announcementModel;
  }

  createFavorite(String announcement_id, String user_uid) async {
    Map<String,dynamic> map = {
      "ANNOUNCEMENT_ID": announcement_id,
      "USER_UID" : user_uid,
    };
    await addFavorite(map);
  }

  addFavorite(Map<String,dynamic> map) async {
    QuerySnapshot query = await fire_favorites.where('USER_UID', isEqualTo: map["USER_UID"])
        .where('ANNOUNCEMENT_ID', isEqualTo: map["ANNOUNCEMENT_ID"]).get();

    if (!query.docs.isEmpty) {
      return;
    }
    fire_favorites.add(map);
  }

  deleteFavoriteAnnouncement(String announcement_id, String user_uid) {
    var jobskill_query = fire_favorites.where('ANNOUNCEMENT_ID', isEqualTo: announcement_id)
        .where('USER_UID', isEqualTo: user_uid);
    jobskill_query
        .get()
        .then((snapshot)  {
          snapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        }
        );
  }
}