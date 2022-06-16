import 'package:flutter/material.dart';
import 'package:projet_final_app_flutter/Services/FirestoreHelper.dart';
import 'package:projet_final_app_flutter/Services/librairies.dart';

import 'ProfileView.dart';

class ProfileFormView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfileFormViewState();
  }
}

class ProfileFormViewState extends State<ProfileFormView> {
  String user_id = "";
  String lastname = "";
  String firstname = "";
  String pseudo = "";
  String email = "";
  DateTime created_at = DateTime.now();

  /**
   * Those controllers are used to fill TextFields' content at initState()
   */
  final _myProfileLastnameController = TextEditingController();
  final _myProfileFirstnameController = TextEditingController();
  final _myProfileEmailController = TextEditingController();
  final _myProfilePseudoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user_id = GlobalUser.id;

    lastname = GlobalUser.lastname;
    firstname = GlobalUser.firstname;
    pseudo = GlobalUser.pseudo ?? "";
    email = GlobalUser.email;

    _myProfileLastnameController.text = lastname;
    _myProfileFirstnameController.text = firstname;
    _myProfileEmailController.text = email;
    _myProfilePseudoController.text = pseudo;
  }


  /**
   * Update user profile's data from map's parameters then navigate to ProfileView()
   */
  updateProfile() async {
    print("user content: ${user_id} ${lastname} ${firstname} ${email} ${pseudo}");

    Map<String,dynamic> map = {
      "LASTNAME": lastname,
      "FIRSTNAME": firstname,
      "EMAIL": email,
      "PSEUDO": pseudo,
    };
    await FirestoreHelper().updateUser(user_id, map);
    Navigator.push(context, MaterialPageRoute(
        builder: (context){
          return ProfileView();
        }
    ));
  }

  Future<void> _showMyDialog(String title, String description) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(description),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title : const Text("Update your profile"),
          backgroundColor: Colors.black38,
        ),
        body: Center(
            child:
            Column(
              children: <Widget>[
                SizedBox(height: 20),
                Text("Pseudo"),
                TextField(
                  decoration: InputDecoration(
                      hintText : "Update your pseudo here",
                      border : OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                  onChanged : (String value) {
                    setState(() {
                      pseudo = value;
                    });
                  },
                  controller: _myProfilePseudoController,
                ),
                SizedBox(height: 20),
                Text("Firstname"),
                TextField(
                  decoration: InputDecoration(
                      hintText : "Update your firstname here",
                      border : OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                  onChanged : (String value) {
                    setState(() {
                      firstname = value;
                    });
                  },
                  controller: _myProfileFirstnameController,
                ),
                SizedBox(height: 20),
                Text("Lastname"),
                TextField(
                  decoration: InputDecoration(
                      hintText : "Update your lastname here",
                      border : OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                  onChanged : (String value) {
                    setState(() {
                      lastname = value;
                    });
                  },
                  controller: _myProfileLastnameController,
                ),
                SizedBox(height: 20),
                Text("Email"),
                TextField(
                  decoration: InputDecoration(
                      hintText : "Update your email here",
                      border : OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                  onChanged : (String value) {
                    setState(() {
                      email = value;
                    });
                  },
                  controller: _myProfileEmailController,
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () async {
                    /**
                     * If title of description are empty it exits the method
                     * If announcement_id is not empty, it must update the announcement
                     * Else it creates a new one.
                     */
                    if (lastname.length == 0 || firstname.length == 0 || pseudo.length == 0 || email.length == 0) {
                      _showMyDialog("Empty fields", "Firstname, Lastname, Email and Pseudo fields must not be empty");
                      return;
                    }
                    await updateProfile();
                  },
                  icon: Icon( // <-- Icon
                    Icons.edit,
                    size: 24.0,
                  ),
                  label: Text('Submit the update'),
                ),
              ],
            )
        )
    );
  }

}
