import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projet_final_app_flutter/Model/UserModel.dart';
import 'package:projet_final_app_flutter/Services/FirestoreHelper.dart';
import 'package:projet_final_app_flutter/Services/librairies.dart';
import 'package:projet_final_app_flutter/View/MyDrawerView.dart';

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState(){
    return HomeViewState();
  }
}

class HomeViewState extends State<HomeView>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
        drawer: Container(
          width: MediaQuery.of(context).size.width/2,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: MyDrawerView(),
        ),

        appBar : AppBar(
          title : const Text("Home page"),
          backgroundColor: Colors.black38,
        ),
        backgroundColor: Colors.white,
        body : bodyPage()
    );
  }

  Widget bodyPage(){
    return StreamBuilder<QuerySnapshot>(
      //On cherche tous les documentssnpshots de l'utilisateur dans la bdd
        stream: FirestoreHelper().fire_users.snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            // Il n'y aucune donnée dans la BDD
            return const CircularProgressIndicator.adaptive();
          }
          else
          {
            //
            List documents = snapshot.data!.docs;
            return ListView.builder(
              //gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              padding: EdgeInsets.all(20),
              itemCount: documents.length,
              itemBuilder: (context,index){
                UserModel user = UserModel(documents[index]);
                if(GlobalUser.id != user.id) {
                  return Dismissible(

                    direction: DismissDirection.endToStart,
                    onDismissed: (DismissDirection direction){
                      FirestoreHelper().deleteUser(user.id);
                    },
                    key: Key(user.id),

                    child: Card(
                      elevation: 10,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        onTap: () {
                          //Détail de l'utilisateur

                        },
                        title: Text(user.completeName()),
                        subtitle: Text(user.pseudo!),
                        leading: Image.network(user.avatar!),
                        trailing: Text(user.email),
                      ),

                    ),
                  );

                }
                else
                {
                  return Container();
                }




              },


            );
          }
        }
    );
  }
}