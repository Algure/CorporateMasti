import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Utilities/utilities.dart';

class ProposedEvent extends StatelessWidget {

  String id;
  String data;
  String name;
  String email;
  String phoneNum;
  Function onDeleleteItemFunc;
  Function onPushToMainFunc;

  ProposedEvent({this.data, this.id, this.onDeleleteItemFunc,this.onPushToMainFunc}){
    List<String> dataList= data.split(":")[1].replaceAll('"', '').split("<");
    data=dataList[0];
    name=dataList[1];
    phoneNum=dataList[2];
    email=dataList[3];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      color: Colors.blueGrey.withOpacity(0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15,),
          Text(data, style: TextStyle(color: Colors.white, fontSize: 15)),
          SizedBox(height: 10,),
          Text('Proposed by $name', style: TextStyle(color: Colors.white, fontSize: 10)),
          SizedBox(height: 10,),
          Row(
              children:[
              Expanded(child: ListButton(onPressed: onDeleleteItemFunc, text: "Delete", iconData: Icons.clear,)),
                Expanded(child: ListButton(onPressed: onPushToMainFunc, text:"Approve", iconData: Icons.done,)),
                Expanded(
                  child: ListButton(text: "Contact",iconData: Icons.phone,onPressed: (){
                    launch('tel:+${phoneNum}');
                  },),
                ),
                Expanded(
                  child: ListButton(text: "Email",iconData: Icons.send,onPressed: (){
                    launch('mailto:${email}');
                  },),
                )
            ]
          ),
          SizedBox(height: 10,),
        ],
      ),
    );
  }
}

class ListButton extends StatelessWidget {
   ListButton({
    @required this.onPressed, this.text, this.iconData
  });

  final Function onPressed;
  String text;
  IconData iconData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          Icon(iconData, color: Colors.white, size :12),
          Text(text, style: TextStyle(color: Colors.white, fontSize :12),)
        ],
      ),
    );
  }
}
