import 'dart:io';

import 'package:corporatemasti/Utilities/constants.dart';
import 'package:corporatemasti/Utilities/utilities.dart';
import 'package:flutter/material.dart';

class FantasyView extends StatelessWidget {
  String _eventsObject;
  Function onFormatSelected;
  bool isFromNetwork;
  bool isFantasy;
  Function deleteItemFunc;

  FantasyView(this._eventsObject,{this.onFormatSelected, this.deleteItemFunc, this.isFromNetwork=false,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFormatSelected??(){},
      child: Container(
        height: MediaQuery.of(context).size.height*0.6,// kWidgetWidth*1.5+(isFromNetwork?50:0),
        color: Colors.transparent,
        margin: EdgeInsets.all(3),
        width: MediaQuery.of(context).size.width*0.85,
        child: GestureDetector(
          onTap: (){
            List<String> dataList=_eventsObject.split('<');
            if(dataList.length>1 && dataList[1]!=null &&dataList[1].trim().isNotEmpty)
              kLoadClickLink(dataList[1]);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(18)),
            child: Image.file(File(_eventsObject.split('<')[0].trim()),
              fit: BoxFit.fill, width: double.infinity, height: MediaQuery.of(context).size.height*0.6,),
          ),
        ),
      ),
    );
  }
}
