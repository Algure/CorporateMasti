import 'package:corporatemasti/Utilities/constants.dart';
import 'package:corporatemasti/Utilities/utilities.dart';
import 'package:flutter/material.dart';

class TeamChooseWidget extends StatelessWidget {

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
  Widget mediaImage;

  TeamChooseWidget({this.teamData, this.onDeletePressed, this.onTeamPressed, this.largeNumberText='00'}){
    setupTeamData(teamData);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 10,
      child: Container(
        height: 150,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8))
        ),
        child: FlatButton(
          onPressed: ()  {
            onTeamPressed.call();
          },
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

            ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Image.network(kImageUrlStart+ teamLogo,fit: BoxFit.fill,height: 50, width: 50,)),
            SizedBox(height: 10,),
            Text(teamName, style: TextStyle(color: Colors.grey, fontSize: 10),),
          ]
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

    mediaImage=ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
    child: Image.network(kImageUrlStart+ teamLogo,fit: BoxFit.contain,height: 70, width: 70,));
  }
}
