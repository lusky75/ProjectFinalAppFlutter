import 'package:flutter/material.dart';
import 'package:projet_final_app_flutter/View/MyDrawerView.dart';

class ArticlesView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ArticlesViewState();
  }
}

class ArticlesViewState extends State<ArticlesView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      drawer: Container(
        width: MediaQuery.of(context).size.width/2,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: MyDrawerView(),
      ),

      appBar : AppBar(
        title : const Text("Articles page"),
        backgroundColor: Colors.black38,
      ),
    );
  }


}
