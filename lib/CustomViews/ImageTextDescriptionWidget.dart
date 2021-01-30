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
      onTap: onFormatSelected??(){
        if(_eventsObject.clickLink!=null && _eventsObject.clickLink.trim().length>4)
          kLoadClickLink(_eventsObject.clickLink.trim());
      },
      child: Container(
//          width: kWidgetWidth*1.5,//+(isFromNetwork?50:0),
        color: Colors.white,
//          height: kWidgetWidth*0.5,
        margin: EdgeInsets.symmetric(vertical: kWidgetsMargin),
        padding: EdgeInsets.all( kWidgetsMargin),
        child: ListTile(
          leading:
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child:
          isFromNetwork?Image.network(kImageUrlStart+_eventsObject.imageUrl??"",  fit: BoxFit.cover, width:kWidgetWidth*0.5, height: kWidgetWidth*2.5,):
            (_eventsObject.imageUrl!=null)?Image.file(File(_eventsObject.imageUrl??""),  fit: BoxFit.cover, width:kWidgetWidth*0.3, height: kWidgetWidth*0.3,):
              Image.asset('images/footim.jpg',  fit: BoxFit.cover, width:kWidgetWidth*0.5, height: kWidgetWidth*0.5,),),

        title:Container(width: double.infinity,child:
        Text(_eventsObject.title==null||_eventsObject.title.isEmpty?"Title goes here":_eventsObject.title, style: kTitleStyle,
        maxLines: 1,)),
        subtitle:Container(width:double.infinity,child: Text(_eventsObject.value==null||_eventsObject.value.isEmpty?"Description goes here dzsdfzzaadsssssssssssssssssssssssssssaDdd":_eventsObject.value,
            maxLines: 3, style:kSubtitleStyle)),

        ),
      ),
    );
  }
}
