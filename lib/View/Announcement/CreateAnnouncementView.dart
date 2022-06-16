import 'package:flutter/material.dart';
import 'package:projet_final_app_flutter/View/Announcement/AnnouncementsView.dart';
import 'package:projet_final_app_flutter/Services/FirestoreHelper.dart';
import 'package:projet_final_app_flutter/Services/librairies.dart';
import 'package:flutter/services.dart';

import '../../Component/CustomAlertDialog.dart';

class CreateAnnouncementView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CreateAnnouncementViewState();
  }
}

class CreateAnnouncementViewState extends State<CreateAnnouncementView> {
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
    price = selectedAnnouncement.price;

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
      "PRICE": price
    };
    FirestoreHelper().updateAnnouncement(announcement_id, map);
    Navigator.push(context, MaterialPageRoute(
        builder: (context){
          return AnnouncementsView();
        }
    ));
  }

  Future<void> _showMyDialog(String title, String description) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CustomAlertDialog(title, description);
      },
    );
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
                SizedBox(height: 20),
                Text("Title"),
                TextField(
                  decoration: InputDecoration(
                      hintText : "Enter your title here",
                      border : OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                  onChanged : (String value) {
                    setState(() {
                      title = value;
                    });
                  },
                  controller: _myAnnouncementTitleController,
                ),
                SizedBox(height: 20),
                Text("Description"),
                Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: TextField(

                        onChanged : (String value) {
                          setState(() {
                            description = value;
                          });
                        },
                        controller: _myAnnouncementDescriptionController,
                        maxLines: 8, //or null
                        decoration : InputDecoration(
                            hintText : "Enter your description here",
                            border : OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                            )
                        ),
                      ),
                    )
                ),
                SizedBox(height: 20),
                Text("Price"),
                TextFormField(
                  decoration : InputDecoration(
                      hintText : "Enter the price",
                      border : OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged : (String value) {
                    setState(() {
                      price = double.parse(value);
                    });
                  },
                  controller: _myAnnouncementPriceController,
                ),
                SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: () async {
                    /**
                     * If title of description are empty it exits the method
                     * If announcement_id is not empty, it must update the announcement
                     * Else it creates a new one.
                     */
                    if (title.length == 0 || description.length == 0) {
                      _showMyDialog("Empty fields", "Title and Description fields must not be empty");
                      return;
                    }
                    if (price == 0) {
                      _showMyDialog("Error fields", "Price field must be numeric or decimal");
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
