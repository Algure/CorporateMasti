import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../DataObjects/EventsObject.dart';
import '../Utilities/constants.dart';
import '../Utilities/utilities.dart';

class ImageLongWidget extends StatelessWidget {

  EventsObject _eventsObject;
  Function onFormatSelected;
  bool isFromNetwork;
  Function deleteItemFunc;

  ImageLongWidget(this._eventsObject,{this.onFormatSelected, this.deleteItemFunc, this.isFromNetwork=false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFormatSelected??(){

        if(_eventsObject.clickLink!=null && _eventsObject.clickLink.trim().length>4)
          kLoadClickLink(_eventsObject.clickLink.trim());
      },
      child: Container(
        height: MediaQuery.of(context).size.height*0.7,//+(isFromNetwork?50:0),
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: kWidgetsMargin),
        width: kWidgetWidth,
        child: Column(
          children: [
            if(isFromNetwork)
              Image.network(kImageUrlStart+_eventsObject.imageUrl, fit: BoxFit.fill, width: double.infinity, height:MediaQuery.of(context).size.height*0.7)
            else
              if(_eventsObject.imageUrl!=null)Image.file(File(_eventsObject.imageUrl??""), fit: BoxFit.cover, width: kWidgetWidth, height: kWidgetWidth*1.8,)
              else Image.asset('images/footim.jpg', fit: BoxFit.cover, width: kWidgetWidth, height:double.infinity,),
//            if(isFromNetwork)
//              FlatButton(
//                onPressed: deleteItemFunc??(){},
//                child: Row(
//                  children: [
//                    Icon(Icons.clear, color: Colors.red,),
//                    Text('Delete Event', style: TextStyle(color: Colors.red),)
//                  ],
//                ),
//              )
          ],
        ),
      ),
    );
  }


}
