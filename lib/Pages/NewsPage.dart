
import 'package:flutter/material.dart';

import '../Utilities/constants.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title="News"}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _name='';

  String _email='';




  @override
  Widget build(BuildContext context) {

    List<Widget> newsList= [];

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title, style: kPageTitleStyle,),
        iconTheme: IconThemeData(color: kGreen),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: newsList
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        child: Card(
                          color: Colors.transparent,

                          child: ListTile(
                            tileColor: Colors.transparent,
                            leading: Image.asset('images/logo.png'),
                            title: Text(_name,style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold
                            ),),
                            subtitle: Text(_email,style: kNavTextStyleSmall,),
                          ),
                        ),
                      ),
                    ),
                  )),

              Container(
                height: 1,
                color: Colors.white,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              ),

            ],
          ),
        ),

      ),
    );
  }


}
