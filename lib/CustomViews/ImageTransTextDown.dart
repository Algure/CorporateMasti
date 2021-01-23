import 'dart:io';

import 'package:flutter/material.dart';

import '../DataObjects/EventsObject.dart';
import '../Utilities/constants.dart';
import '../Utilities/utilities.dart';

class ImageTransTextDown extends StatelessWidget {

  EventsObject _eventsObject;
  Function onFormatSelected;

  var isFromNetwork;

  var deleteItemFunc;

  ImageTransTextDown(this._eventsObject, {this.onFormatSelected,  this.deleteItemFunc, this.isFromNetwork=false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFormatSelected??(){},
      child: Container(
        height: kWidgetWidth*1.4+(isFromNetwork?50:0),
        color: Colors.white,
        margin: EdgeInsets.all(3),
        width: kWidgetWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(isFromNetwork)
              Image.network(kImageUrlStart+_eventsObject.imageUrl,fit: BoxFit.cover, width: double.infinity, height: kWidgetWidth,)
            else
              if(_eventsObject.imageUrl!=null)Image.file(File(_eventsObject.imageUrl??""), fit: BoxFit.cover,width: kWidgetWidth, height: kWidgetWidth,)
              else Image.asset('images/footim.jpg', fit: BoxFit.cover,width: kWidgetWidth, height: kWidgetWidth,),

            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(_eventsObject.title==null||_eventsObject.title.isEmpty?"Title goes here":_eventsObject.title, style:kPageTitleStyle),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(_eventsObject.value==null||_eventsObject.value.isEmpty?"Description goes here":_eventsObject.value, style:kSubtitleStyle),
            ),
            SizedBox(height: 5),
            isFromNetwork?FlatButton(
              onPressed: deleteItemFunc??(){},
              child: Row(
                children: [
                  Icon(Icons.clear, color: Colors.red,),
                  Text('Delete Event', style: TextStyle(color: Colors.red),)
                ],
              ),
            ):Container(),
          ],
        ),
      ),
    );
  }
}
