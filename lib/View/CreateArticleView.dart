import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projet_final_app_flutter/View/AnnouncementsView.dart';
import 'package:projet_final_app_flutter/View/MyDrawerView.dart';
import 'package:projet_final_app_flutter/Services/FirestoreHelper.dart';
import 'package:projet_final_app_flutter/Services/librairies.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class CreateArticleView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CreateArticleViewState();
  }
}

class CreateArticleViewState extends State<CreateArticleView> {
  String announcement_id = "";
  String title = "";
  double price = 0;
  String description = "";
  DateTime created_at = DateTime.now();

  /**
   * Those controllers are used to fill TextFields' content at initState()
   */
  final _myAnnouncementTitleController = TextEditingController();
  final _myAnnouncementDescriptionController = TextEditingController();
  final _myAnnouncementPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    announcement_id = selectedAnnouncement.id;
    title = selectedAnnouncement.title;
    description = selectedAnnouncement.description;

    _myAnnouncementTitleController.text = title;
    _myAnnouncementDescriptionController.text = description;
    _myAnnouncementPriceController.text = price.toString();
  }

  /**
   * Create announcement then navigate to ArticlesView()
   */
  createAnnouncement(){
    FirestoreHelper().createAnnouncement(title, description, price, created_at, GlobalUser.pseudo ?? "", GlobalUser.id).then((value){
      Navigator.push(context, MaterialPageRoute(
          builder: (context){
            return AnnouncementsView();
          }
      ));

    }).catchError((error){
      //Par exemple une perte de connexion
      print(error);
    });
  }

  /**
   * Update article's data from map's parameters then navigate to ArticlesView()
   */
  updateAnnouncement() {
    Map<String,dynamic> map = {
      "TITLE": title,
      "DESCRIPTION": description,
    };
    FirestoreHelper().updateAnnouncement(announcement_id, map);
    Navigator.push(context, MaterialPageRoute(
        builder: (context){
          return AnnouncementsView();
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
                  controller: _myAnnouncementTitleController,
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
                        controller: _myAnnouncementDescriptionController,
                        maxLines: 8, //or null
                        decoration: InputDecoration.collapsed(hintText: "Enter your description here"),
                      ),
                    )
                ),
                Text("Price"),
                TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged : (String value) {
                    setState(() {
                      print("ok");
                      price = double.parse(value);
                    });
                  },
                  controller: _myAnnouncementPriceController,
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    /**
                     * If title of description are empty it exits the method
                     * If announcement_id is not empty, it must update the announcement
                     * Else it creates a new one.
                     */
                    if (title.length == 0 && description.length == 0) {
                      return;
                    }
                    if (announcement_id != "") {
                      await updateAnnouncement();
                    } else {
                      await createAnnouncement();
                    }
                  },
                  icon: Icon( // <-- Icon
                    Icons.edit,
                    size: 24.0,
                  ),
                  label: Text('Submit the article'),
                ),
              ],
            )
        )
    );
  }

}
