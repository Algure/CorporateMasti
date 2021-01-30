import 'package:corporatemasti/CustomViews/ImageLong.dart';
import 'package:corporatemasti/CustomViews/ImageLongWithText.dart';
import 'package:corporatemasti/CustomViews/ImageShort.dart';
import 'package:corporatemasti/CustomViews/ImageSquare.dart';
import 'package:corporatemasti/CustomViews/ImageTextDescriptionWidget.dart';
import 'package:corporatemasti/CustomViews/ImageTransText.dart';
import 'package:corporatemasti/CustomViews/ImageTransTextDown.dart';
import 'package:corporatemasti/CustomViews/ImageTransTextUp.dart';
import 'package:corporatemasti/DataObjects/EventData.dart';
import 'package:corporatemasti/DataObjects/EventsObject.dart';
import 'package:corporatemasti/Database/OnlineEventsDB.dart';
import 'package:corporatemasti/Pages/TeamsPage.dart';
import 'package:corporatemasti/Pages/TournamentsPage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:corporatemasti/Utilities/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../Utilities/constants.dart';
import 'FantasyPage.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title="News",  this.justLoggedIn=false, this.justSignedIn=false}) : super(key: key);

  final String title;
  bool justLoggedIn;
  bool justSignedIn;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String userName='Dummy Dummy';
  String userMail='dummy@mail.com';
  double navPicHeight=20;
  double navPicWidth=20;
  bool progress=false;
  double drawerSpacerHeight=5;

  List<Widget> itemList=[];


  RefreshController _refreshController=RefreshController(initialRefresh: false);

  @override
  void initState() {
    if(widget.justLoggedIn){
      widget.justLoggedIn=false;
      uShowLoginDialog(context: context);
    }
    if(widget.justSignedIn){
      widget.justSignedIn=false;
      uShowSignupDialog(context: context);
    }
    getAllMarketItems(context);
    setNavDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title, style: kPageTitleStyle,),
        iconTheme: IconThemeData(color: kGreen),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 15, left: 8, right: 8),
        color: Colors.white,
        child: ModalProgressHUD(
          inAsyncCall: progress,

          child: SmartRefresher(
            onRefresh: (){
              reDownloadItems();
            },
            controller: _refreshController,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: itemList
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 60,),
                      Container(
                        height: 80,width: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(image: AssetImage('images/footballim.jpg'), fit: BoxFit.fill)
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(userName, textAlign: TextAlign.start,style: TextStyle(color: Colors.black, fontSize:20, fontWeight: FontWeight.bold)),
                      Text(userMail,textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize:10)),
                      SizedBox(height: 20,)
                    ],
                  ),
                ),
                Container(height: 0.5,width: double.infinity,color: Colors.grey.shade900,),
                SizedBox(height: drawerSpacerHeight,),
                FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
//                    Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsPage()));
                  },
                  color: Colors.white,
                  child: Row(
                    children: [
                      Image.asset('images/newspaper.png', color: kNavSelectedColor,height: navPicHeight, width: navPicWidth,),
                      SizedBox(width: 10,),
                      Text('News', style: TextStyle(color: kNavSelectedColor),)
                    ],
                  ),
                ),

                SizedBox(height: drawerSpacerHeight,),
                FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>TeamsPage()));
                  },
                  color: Colors.white,
                  child: Row(
                    children: [
                      Image.asset('images/shield.png', color: kGreen,height: navPicHeight, width: navPicWidth,),
                      SizedBox(width: 10,),
                      Text('Teams', style: TextStyle(color: kGreen),)
                    ],
                  ),
                ),
                SizedBox(height: drawerSpacerHeight,),
                FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>TournamentsPage()));
                  },
                  color: Colors.white,
                  child: Row(
                    children: [
                      Image.asset('images/trophy.png', color: kGreen,height: navPicHeight, width: navPicWidth,),
                      SizedBox(width: 10,),
                      Text('Tournaments', style: TextStyle(color: kGreen),)
                    ],
                  ),
                ),
                SizedBox(height: drawerSpacerHeight,),
                FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>FantasyPage()));
                  },
                  color: Colors.white,
                  child: Row(
                    children: [
                      Image.asset('images/uniform.png', color: kGreen,height: navPicHeight, width: navPicWidth,),
                      SizedBox(width: 10,),
                      Text('Fantasy', style: TextStyle(color: kGreen),)
                    ],
                  ),
                ),
                SizedBox(height: drawerSpacerHeight,),
                FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
//                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsPage()));
                  },
                  color: Colors.white,
                  child: Row(
                    children: [
                      Image.asset('images/profile.png', color: kGreen,height: navPicHeight, width: navPicWidth,),
                      SizedBox(width: 10,),
                      Text('Profile', style: TextStyle(color: kGreen),)
                    ],
                  ),
                ),
                Spacer(),
                FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                    displayAboutDialog();
                  },
                  color: Colors.white,
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color:kGreen,size: navPicHeight,),
                      SizedBox(width: 10,),
                      Text('About', style: TextStyle(color: kGreen),)
                    ],
                  ),
                ),

              ]
          ),
        ),
      ),
    );
  }

  displayAboutDialog(){
    showAboutDialog(
      applicationIcon:Image.asset('images/logo.png', height: 70, width: 200,) ,
      applicationName: '',
      context: this.context,
      applicationLegalese: '',//'''Brought to you by Cyber-Techies',
      applicationVersion:'',// '1.0.0',
      children: [
        Text('Brought to you by Cyber-Techies', style: TextStyle(color: Colors.grey, fontSize: 8))
    ]);
  }

  Future<void> getAllMarketItems(BuildContext context) async {
    showProgress(true);
    DateTime now= DateTime.now();
    String formattedDate=  DateFormat('YY:MM:dd').format(now);
    if(!(await uCheckInternet()) || ((await uGetSharedPrefValue('ldate')).toString())==formattedDate){
      showProgress(false);
      await setListFromDb();
      return;
    }
    itemList=[];
    DatabaseReference myRef=FirebaseDatabase.instance.reference().child('News');
    DataSnapshot snapShot=await myRef.once();
    print('gotten value');
    print(snapShot.value.toString());
    if(snapShot.value.toString()=="null"){
      showProgress(false);
      return;
    }
    Map<dynamic , dynamic> maps= Map.from(snapShot.value);
    OnlineEventsDb sDb = OnlineEventsDb();

    for (var key in maps.keys){
      await sDb.insertItem(id: key, item: maps[key].toString());
      String eventDetails=maps[key];
      try {
        EventsObject eveOb = EventsObject.fromString(eventDetails);
        if (eveOb.widgetType == '0') {
          itemList.insert(0,ImageLongWidget(eveOb, isFromNetwork: true,));
        } else if (eveOb.widgetType == '1') {
          itemList.insert(0,ImageLongWithTextWidget(eveOb,isFromNetwork: true));
        } else if (eveOb.widgetType == '2') {
          itemList.insert(0,ImageShort(eveOb, isFromNetwork: true));
        } else if (eveOb.widgetType == '3') {
          itemList.insert(0,ImageSquare(eveOb, isFromNetwork: true));
        } else if (eveOb.widgetType == '4') {
          itemList.insert(itemList.length-1,ImageTextDescriptionWidget(eveOb,isFromNetwork: true));
        } else if (eveOb.widgetType == '5') {
          itemList.insert(0,ImageTransText(eveOb,isFromNetwork: true));
        } else if (eveOb.widgetType == '6') {
          itemList.insert(0,ImageTransTextDown(eveOb,isFromNetwork: true));
        } else if (eveOb.widgetType == '7') {
          itemList.insert(0,ImageTransTextUpWidget(eveOb,isFromNetwork: true));
        }
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
    OnlineEventsDb sDb = OnlineEventsDb();
    List<EventData> eventsList=await sDb.getEvents();
    for(EventData eves in eventsList){
      try {
        EventsObject eveOb = EventsObject.fromString(eves.e);
        if (eveOb.widgetType == '0') {
          itemList.insert(0,ImageLongWidget(eveOb, isFromNetwork: true));
        } else if (eveOb.widgetType == '1') {
          itemList.insert(0,ImageLongWithTextWidget(eveOb,isFromNetwork: true));
        } else if (eveOb.widgetType == '2') {
          itemList.insert(0,ImageShort(eveOb,isFromNetwork: true));
        } else if (eveOb.widgetType == '3') {
          itemList.insert(0,ImageSquare(eveOb,isFromNetwork: true));
        } else if (eveOb.widgetType == '4') {
          itemList.insert(itemList.length-1,ImageTextDescriptionWidget(eveOb,isFromNetwork: true));
        } else if (eveOb.widgetType == '5') {
          itemList.insert(0,ImageTransText(eveOb,isFromNetwork: true));
        } else if (eveOb.widgetType == '6') {
          itemList.insert(0,ImageTransTextDown(eveOb,isFromNetwork: true));
        } else if (eveOb.widgetType == '7') {
          itemList.insert(0,ImageTransTextUpWidget(eveOb,isFromNetwork: true ));
        }
      }catch(e){
        print("Event add exception ${e.toString()}");
      }
    }
    print('event list length: ${itemList.length}');
    showProgress(false);
  }

  void reDownloadItems() async{

    showProgress(true);
    DateTime now= DateTime.now();
    String formattedDate=  DateFormat('YY:MM:dd').format(now);
    if(!(await uCheckInternet()) || ((await uGetSharedPrefValue('ldate')).toString())==formattedDate){
      showProgress(false);
      await setListFromDb();
      return;
    }
    itemList=[];
    DatabaseReference myRef=FirebaseDatabase.instance.reference().child('News');
    DataSnapshot snapShot=await myRef.once();
    print('gotten value');
    print(snapShot.value.toString());
    if(snapShot.value.toString()=="null"){
      showProgress(false);
      return;
    }
    Map<dynamic , dynamic> maps= Map.from(snapShot.value);
    OnlineEventsDb sDb = OnlineEventsDb();

    for (var key in maps.keys){
      await sDb.insertItem(id: key, item: maps[key].toString());
      String eventDetails=maps[key];
      try {
        EventsObject eveOb = EventsObject.fromString(eventDetails);
        if (eveOb.widgetType == '0') {
          itemList.insert(0,ImageLongWidget(eveOb, isFromNetwork: true));

        } else if (eveOb.widgetType == '1') {
          itemList.insert(0,ImageLongWithTextWidget(eveOb, isFromNetwork: true));

        } else if (eveOb.widgetType == '2') {
          itemList.insert(0,ImageShort(eveOb, isFromNetwork: true));

        } else if (eveOb.widgetType == '3') {
          itemList.insert(0,ImageSquare(eveOb, isFromNetwork: true));

        } else if (eveOb.widgetType == '4') {
          itemList.insert(itemList.length-1,ImageTextDescriptionWidget(eveOb,isFromNetwork: true));

        } else if (eveOb.widgetType == '5') {
          itemList.insert(0,ImageTransText(eveOb,isFromNetwork: true));

        } else if (eveOb.widgetType == '6') {
          itemList.insert(0,ImageTransTextDown(eveOb,isFromNetwork: true));

        } else if (eveOb.widgetType == '7') {
          itemList.insert(0,ImageTransTextUpWidget(eveOb, isFromNetwork: true));
        }
      }catch(e){
        print("Event add exception ${e.toString()}");
      }
    }
    showProgress(false);
  }

  Future<void> setNavDetails() async {
    userName='${await uGetSharedPrefValue(kFnameKey)} ${await uGetSharedPrefValue(kLnameKey)}';
    userMail= await uGetSharedPrefValue(kMailKey);
    showProgress(false);
  }

}
