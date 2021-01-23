import 'package:corporatemasti/DataObjects/EventData.dart';
import 'package:flutter/material.dart';


import '../Utilities/constants.dart';
import '../Utilities/utilities.dart';

class TeamWidget extends StatelessWidget {

  String teamData;
  Function onDeletePressed;
  Function onTeamPressed;

  String teamName;

  String teamSpeed;

  String teamPower;

  String teamShot;

  String teamLogo;

  String largeNumberText;

  double rowWidth=5;

  TeamWidget({this.teamData, this.onDeletePressed, this.onTeamPressed, this.largeNumberText='00'}){
    setupTeamData(teamData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      child: Container(
        child: GestureDetector(
          onTap: onTeamPressed,
          child: Stack(
            children: [
              Container(
                  alignment:Alignment.bottomRight,child: Text(largeNumberText, textAlign: TextAlign.end, style: TextStyle(letterSpacing:0,fontSize: 200, fontWeight: FontWeight.w900, color: Colors.grey.shade100),)),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(kImageUrlStart+teamLogo, height: 45, width: 45,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(teamName, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30, color: Colors.black),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: rowWidth,),
                      Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.blue.shade900
                          ),
                          child: Text('speed:$teamSpeed%', style: kTeamStyle,)),
                      SizedBox(width: rowWidth,),
                      Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Colors.lightBlueAccent
                          ),
                          child: Text('shot:$teamShot%', style: kTeamStyle,)),
                      SizedBox(width: rowWidth,),
                      Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Colors.red
                          ),
                          child: Text('power:$teamPower%', style: kTeamStyle,)),
                      SizedBox(width: rowWidth,),
                    ],
                  ),
                  SizedBox(height: 15,),
                ],
              ),
            ],
          ),
        ),

      ),
    );
  }

  void setupTeamData(String teamData) {
    List<String> dataList= teamData.split('<');
     teamName=dataList[0];
     teamSpeed=dataList[1];
     teamPower=dataList[2];
     teamShot=dataList[3];
     teamLogo=dataList[4];
  }
}
