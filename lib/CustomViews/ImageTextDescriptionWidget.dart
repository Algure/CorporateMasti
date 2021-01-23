import 'dart:io';

import 'package:flutter/material.dart';

import '../DataObjects/EventsObject.dart';
import '../Utilities/constants.dart';
import '../Utilities/utilities.dart';

class ImageTextDescriptionWidget extends StatelessWidget {

  EventsObject _eventsObject;
  Function onFormatSelected;

  var deleteItemFunc;

  var isFromNetwork;

  ImageTextDescriptionWidget(this._eventsObject,{this.onFormatSelected,  this.deleteItemFunc, this.isFromNetwork=false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFormatSelected??(){},
      child: Container(
        width: kWidgetWidth*1.5+(isFromNetwork?50:0),
        color: Colors.white,
        margin: EdgeInsets.all(3),
        height: kWidgetWidth*0.5,
        child: ListTile(
          leading:isFromNetwork?Image.network(kImageUrlStart+_eventsObject.imageUrl??"",  fit: BoxFit.cover, width:kWidgetWidth*0.3, height: kWidgetWidth*0.3,):
            (_eventsObject.imageUrl!=null)?Image.file(File(_eventsObject.imageUrl??""),  fit: BoxFit.cover, width:kWidgetWidth*0.3, height: kWidgetWidth*0.3,):
              Image.asset('images/footim.jpg',  fit: BoxFit.cover, width:kWidgetWidth*0.3, height: kWidgetWidth*0.3,),

        title:Container(width: double.infinity,child: Text(_eventsObject.title==null||_eventsObject.title.isEmpty?"Title goes here":_eventsObject.title, style: kTitleStyle)),
        subtitle:Container(width:double.infinity,child: Text(_eventsObject.value==null||_eventsObject.value.isEmpty?"Description goes here dzsdfzzaadsssssssssssssssssssssssssssaDdd":_eventsObject.value, style:kSubtitleStyle)),
        trailing:  isFromNetwork?Container(
          width: 50,
          child: FlatButton(
            onPressed: deleteItemFunc??(){},
      child: Center(
          child:
            Icon(Icons.clear, color: Colors.red,),

      ),
    ),
        ):Container(width: 1,),
        ),
      ),
    );
  }
}
