import 'package:corporatemasti/Pages/LoginFlow/LoginPage.dart';
import 'package:corporatemasti/Pages/NewsPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginFlow/LoginStartPage.dart';

class DecisionPage extends StatefulWidget {
  @override
  _DecisionPageState createState() => _DecisionPageState();
}

class _DecisionPageState extends State<DecisionPage> {

  @override
  void initState() {
    openChatIfLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:Image.asset('images/Splash.png')
    );
  }

  void openChatIfLoggedIn() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    if(sp.containsKey('id')&& (await sp.getString('id')).isNotEmpty) {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
    }
    else{
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginStartPage()));
    }
    this.dispose();
  }

}
