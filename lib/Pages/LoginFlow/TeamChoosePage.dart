import 'package:corporatemasti/CustomViews/TeamChooseWidget.dart';
import 'package:corporatemasti/Database/TeamsDatabase.dart';
import 'package:corporatemasti/Pages/LoginFlow/SignupPage.dart';
import 'package:corporatemasti/Pages/NewsPage.dart';
import 'package:corporatemasti/Utilities/constants.dart';
import 'package:corporatemasti/Utilities/utilities.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TeamChoosePage extends StatefulWidget {

  @override
  _TeamChoosePageState createState() => _TeamChoosePageState();
}

class _TeamChoosePageState extends State<TeamChoosePage> {

  bool progress=false;
  List<Widget> itemList=[];
  RefreshController _refreshController=RefreshController(initialRefresh: false);


  @override
  void initState() {
    setAllMarketItems(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: progress,
          child: Column(
            children: [
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                  children:[
                    SizedBox(width:10),
                    GestureDetector(
                        onTap: (){
                          moveToSignUpPage();
                        },
                        child: Icon(CupertinoIcons.chevron_left , color: Colors.black, size: 16,)),
                    SizedBox(width:10),
                    Text('Select your favorite team.', style: TextStyle(color: Colors.black, fontSize: 16),)]),
              SizedBox(height: 50,),
              Row(
              children: [
                Spacer(),
                GestureDetector(
                    onTap: (){
                     moveToHomePage();
                    },
                    child: Text('skip', style: TextStyle(color: kThemeOrange))),
                Icon(CupertinoIcons.chevron_right , color: kThemeOrange, size: 12,),
                SizedBox(width: 20,),
              ]),
              SizedBox(height: 20,),
              Expanded(
                child: GridView.builder(
                  semanticChildCount: 3,
                  itemCount: itemList.length,
                  itemBuilder: (context, dex) {
                    return itemList[dex];
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 3,
                      crossAxisSpacing: 3,
                      childAspectRatio: 1
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setAllTeams(){

  }

  Future<void> setAllMarketItems(BuildContext context) async {
    showProgress(true);
    DateTime now= DateTime.now();
    String formattedDate=  DateFormat('YY:MM:dd').format(now);
    if(!(await uCheckInternet()) || ((await uGetSharedPrefValue('ldateteam')).toString())==formattedDate){
      showProgress(false);
//      await setListFromDb();
      return;
    }
    itemList=[];
    DatabaseReference myRef=FirebaseDatabase.instance.reference().child('Teams');
    DataSnapshot snapShot=await myRef.once();
    print('gotten value');
    print(snapShot.value.toString());
    if(snapShot.value.toString()=="null"){
      showProgress(false);
      return;
    }
    Map<dynamic , dynamic> maps= Map.from(snapShot.value);
    TeamsDb sDb = TeamsDb();
    int dex=0;
    for (var key in maps.keys){
      await sDb.insertItem(id: key, item: maps[key].toString());
      String eventDetails=maps[key];
      try {
        itemList.add(TeamChooseWidget( teamData:maps[key].toString(),
          onTeamPressed: (){
            print('team pressed');
            saveFavoriteTeam(key.toString());
          },
          largeNumberText: dex.toString(),));
        dex++;
      }catch(e){
        print("Event add exception ${e.toString()}");
      }
    }
    showProgress(false);
  }

  Future<void> saveFavoriteTeam(String teamId) async {
    showProgress(true);
    await uSetPrefsValue(kFavTeam, teamId);
    showProgress(false);
    moveToHomePage();
  }

  void moveToHomePage(){
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage(justSignedIn: true,)));
  }

  void moveToSignUpPage(){
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupPage()));
  }

  void showProgress(bool b) {
    setState(() {
      progress=b;
      _refreshController.refreshCompleted();
    });
  }
}
