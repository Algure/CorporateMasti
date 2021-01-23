import 'dart:io';

import 'package:flutter/material.dart';
import '../DataObjects/EventsObject.dart';
import '../Utilities/constants.dart';
import '../Utilities/utilities.dart';

class ImageSquare extends StatelessWidget {
  EventsObject _eventsObject;
  Function onFormatSelected;

  var isFromNetwork;

  var deleteItemFunc;

  ImageSquare(this._eventsObject, {this.onFormatSelected,  this.deleteItemFunc, this.isFromNetwork=false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFormatSelected??(){},
      child: Container(
        height: kWidgetWidth+(isFromNetwork?50:0),
        color: Colors.white,
        margin: EdgeInsets.all(3),
        width: kWidgetWidth,
        child: Column(
          children: [
            if(isFromNetwork)
              Image.network(kImageUrlStart+_eventsObject.imageUrl, fit: BoxFit.cover, width: double.infinity, height: kWidgetWidth,)
            else
              if(_eventsObject.imageUrl!=null)Image.file(File(_eventsObject.imageUrl??"", ),  fit: BoxFit.cover,width:kWidgetWidth, height: kWidgetWidth,)
              else Image.asset('images/footim.jpg', fit: BoxFit.cover, width: kWidgetWidth, height: kWidgetWidth,),
            if(isFromNetwork)
              FlatButton(
                onPressed: deleteItemFunc??(){},
                child: Row(
                  children: [
                    Icon(Icons.clear, color: Colors.red,),
                    Text('Delete Event', style: TextStyle(color: Colors.red),)
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
