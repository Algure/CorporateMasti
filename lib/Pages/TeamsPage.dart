import 'package:corporatemasti/CustomViews/TeamWidget.dart';
import 'package:corporatemasti/CustomViews/my_button.dart';
import 'package:corporatemasti/DataObjects/EventData.dart';
import 'package:corporatemasti/Database/TeamsDatabase.dart';
import 'package:corporatemasti/Utilities/constants.dart';
import 'package:corporatemasti/Utilities/utilities.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:intl/intl.dart';

import 'TeamDataPage.dart';

class TeamsPage extends StatefulWidget {
  @override
  _TeamsPageState createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
  List<Widget> itemList=[];
  bool progress=false;
  RefreshController _refreshController=RefreshController(initialRefresh: false);

  @override
  void initState() {
    getAllMarketItems(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor ,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        title: Text('Teams', style: kPageTitleStyle,),
        iconTheme: IconThemeData(color: kGreen),
        elevation: 0,
      ),
      body: ModalProgressHUD(
        inAsyncCall: progress,
        child: Container(
          margin: EdgeInsets.all(10),
          color: kBackgroundColor,
          child: SmartRefresher(
            onRefresh: (){
              reDownloadItems();
            },
            controller: _refreshController,
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: itemList
              ),
            ),
          ),
        ),
      ),
    );
  }


  Future<void> getAllMarketItems(BuildContext context) async {
    showProgress(true);
    DateTime now= DateTime.now();
    String formattedDate=  DateFormat('YY:MM:dd').format(now);
    if(!(await uCheckInternet()) || ((await uGetSharedPrefValue('ldateteam')).toString())==formattedDate){
      showProgress(false);
      await setListFromDb();
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
        itemList.add(TeamWidget( teamData:maps[key].toString(),
          onTeamPressed: (){
          print('team pressed');

            Navigator.push(context, MaterialPageRoute(builder: (context)=>TeamDataPage(teamName: eventDetails.split('<')[0]
              ,teamId: key.toString(),)));
          }
          ,onDeletePressed:
              (){
            deleteItem(key.toString());
          }, largeNumberText: dex.toString(),));
        dex++;
      }catch(e){
        print("Event add exception ${e.toString()}");
      }
    }
    showProgress(false);
  }

  void showProgress(bool b) {
    setState(() {
      progress=b;
      _refreshController.refreshCompleted();
    });
  }

  Future<void> setListFromDb() async {
    showProgress(true);
    itemList=[];
    TeamsDb sDb = TeamsDb();
    List<EventData> eventsList=await sDb.getEvents();
    int dex=0;
    for(EventData eves in eventsList){
      try {
        itemList.add(TeamWidget( teamData:eves.e,
          onTeamPressed: (){
          print ('team pressed0');
            Navigator.push(context, MaterialPageRoute(builder: (context)=>TeamDataPage(teamName: eves.e.split('<')[0]
              ,teamId: eves.l.toString(),)));
          },
          onDeletePressed: (){
            deleteItem(eves.l);
          }, largeNumberText: dex.toString(),));
        dex++;
      }catch(e){
        print("Event add exception ${e.toString()}");
      }
    }
    print('event list length: ${itemList.length}');
    showProgress(false);
  }

  Future<void> deleteItem(String key) async {
    if(!(await uCheckInternet())){
      uShowNoInternetDialog(context);
      return;
    }
    uShowDeleteDialog(key:key);
  }

  void reDownloadItems() async{
    showProgress(true);
    DateTime now= DateTime.now();
    String formattedDate=  DateFormat('YY:MM:dd').format(now);
    if(!(await uCheckInternet()) || ((await uGetSharedPrefValue('ldateteam')).toString())==formattedDate){
      showProgress(false);
      await setListFromDb();
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
        itemList.add(TeamWidget( teamData:maps[key].toString(),
          onTeamPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>TeamDataPage(teamName: eventDetails.split('<')[0]
              ,teamId: key.toString(),)));
          },onDeletePressed: (){
            deleteItem(key.toString());
          },largeNumberText: dex.toString(),));
        dex++;
      }catch(e){
        print("Event update exception ${e.toString()}");
      }
    }
    showProgress(false);
  }

  displayAboutDialog(){
    Navigator.pop(context);
    showAboutDialog(
      applicationName: 'Soccer-Masti Mgt.',
      context: this.context,
      applicationLegalese: 'Brought to you by Cyber-Techies',
      applicationVersion: '1.0.0',
      applicationIcon:Container(child: Icon(Icons.sports_volleyball,size: 70, color: Colors.deepPurple,),),
    );
  }

  void uShowDeleteDialog({String key}){
    List<Widget> butList=[];
    Dialog errorDialog= Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.black,
      child: Container(
        height: 350,
        child: Column(
          children: [
            Expanded(child: Icon(Icons.delete, color: Colors.red, size: 200,)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('This event would be permanently deleted.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
            ),
            SizedBox(height: 20,),
            Container(
                height: butList!=null?50:2,
                padding: EdgeInsets.all(8.0),
                child: MyButton(text: 'Delete', buttonColor: Colors.white, textColor: Colors.black, onPressed: (){
                  Navigator.pop(context);
                  realDeleteItem(key);
                },)
            )
          ],
        ),
      ),
    );
    showGeneralDialog(context: context,
        barrierLabel: 'iugisss',
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 500),
        transitionBuilder: (_, anim, __, child){
          return SlideTransition(position: Tween(begin: Offset(-1,0), end: Offset(0,0)).animate(anim), child: child,);
        },
        pageBuilder: (BuildContext context, _, __)=>(errorDialog)
    );
  }

  void realDeleteItem(String key) async{
    if(!(await uCheckInternet())){
      uShowNoInternetDialog(context);
      return;
    }
    print('key2delete: '+key);
    showProgress(true);
    await FirebaseDatabase.instance.reference().child('Teams').child(key).remove();
    print('DELETED+');
    TeamsDb sDb = TeamsDb();
    await sDb.deleteItem(key);
    setListFromDb();
  }

}
