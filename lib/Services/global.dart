import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projet_final_app_flutter/Model/ArticleModel.dart';
import 'package:projet_final_app_flutter/Model/UserModel.dart';
import 'package:intl/intl.dart';

UserModel GlobalUser = UserModel.empty();

String getArticleDateFormat(DateTime created_at) {
  return "${DateFormat.yMMMEd().format(created_at)} at ${DateFormat.Hm().format(created_at)}";
}

ArticleModel selectedArticle = ArticleModel.empty();


