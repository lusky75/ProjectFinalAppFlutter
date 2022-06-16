import 'package:projet_final_app_flutter/Model/AnnouncementModel.dart';
import 'package:projet_final_app_flutter/Model/UserModel.dart';
import 'package:intl/intl.dart';

/**
 * GlobalUser used to reuse data of user after being logged
 */
UserModel GlobalUser = UserModel.empty();

String getArticleDateFormat(DateTime created_at) {
  return "${DateFormat.yMMMEd().format(created_at)} at ${DateFormat.Hm().format(created_at)}";
}

/**
 * selectedAnnouncement is used when the user is selecting one of his announcement to update
 */
AnnouncementModel selectedAnnouncement = AnnouncementModel.empty();


