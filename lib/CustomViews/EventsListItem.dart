import 'package:flutter/material.dart';

import '../DataObjects/EventData.dart';
import '../Utilities/utilities.dart';

class EventItem extends StatelessWidget {

  String id;
  String srcImage='';
  String data;
  EventData eventItem;
  Function deleteItemFunc;

  EventItem({this.data, this.id, this.srcImage, this.eventItem, this.deleteItemFunc}){
    if(eventItem!=null){
      id = eventItem.l;
      if(eventItem.e!=null && eventItem.e.isNotEmpty){
        if(eventItem.e.trim().startsWith('<')){
          data=eventItem.e.substring(1);
        }else{
          List<String> dataBank=eventItem.e.split('<');
          if(dataBank.length>1)data=dataBank[1];
          srcImage=kImageUrlStart+dataBank[0];
        }
      }
    }
    if(srcImage==null||srcImage.isEmpty)
      srcImage='';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),

      color: Colors.blueGrey.withOpacity(0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(kImageUrlStart+srcImage, height: srcImage.isEmpty?0:150,width: double.maxFinite, fit: BoxFit.cover,),
          SizedBox(height: 15,),
          Text(data, style: TextStyle(color: Colors.white, fontSize: 15)),
//          SizedBox(height: 10,),
//          FlatButton(
//            onPressed: deleteItemFunc,
//            child: Row(
//              children: [
//                Icon(Icons.clear, color: Colors.white,),
//                Text('Delete Event', style: TextStyle(color: Colors.white),)
//              ],
//            ),
//          )
        ],
      ),
    );
  }
}
