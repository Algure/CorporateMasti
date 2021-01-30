import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:corporatemasti/CustomViews/FantasyView.dart';
import 'package:corporatemasti/CustomViews/my_button.dart';
import 'package:corporatemasti/DataObjects/EventData.dart';
import 'package:corporatemasti/Database/FantasyDatabase.dart';
import 'package:corporatemasti/Utilities/constants.dart';
import 'package:corporatemasti/Utilities/utilities.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FantasyPage extends StatefulWidget {
  @override
  _FantasyPageState createState() => _FantasyPageState();
}

class _FantasyPageState extends State<FantasyPage> {

  String userName='Dummy Dummy';
  String userMail='dummy@mail.com';
  double navPicHeight=20;
  double navPicWidth=20;
  List<Widget> itemList=[];
  bool progress=false;
  double drawerSpacerHeight=5;
  RefreshController _refreshController=RefreshController(initialRefresh: false);


  @override
  void initState() {
    getAllMarketItems(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fantasy Games', style: kPageTitleStyle,),
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
            child:  CarouselSlider(
                items: itemList
                , options: CarouselOptions(height: 400,
                enlargeCenterPage: true,
                viewportFraction: 0.8
            )),
          ),
        ),
      ),
    );
  }

  displayAboutDialog(){
    showAboutDialog(
      applicationName: 'Corporate-Masti',
      context: this.context,
      applicationLegalese: 'Brought to you by Cyber-Techies',
      applicationVersion: '1.0.0',
    );
  }

  Future<void> getAllMarketItems(BuildContext context) async {
    showProgress(true);
    await initializeDownloder();
    DateTime now= DateTime.now();
    String formattedDate=  DateFormat('YY:MM:dd').format(now);
    if(!(await uCheckInternet()) || ((await uGetSharedPrefValue('ldate')).toString())==formattedDate){
      showProgress(false);
      await setListFromDb();
      return;
    }
    itemList=[];
    DatabaseReference myRef=FirebaseDatabase.instance.reference().child('fantasy');
    DataSnapshot snapShot=await myRef.once();
    print('gotten value');
    print(snapShot.value.toString());
    if(snapShot.value.toString()=="null"){
      showProgress(false);
      return;
    }
    Map<dynamic , dynamic> maps= Map.from(snapShot.value);
    FantasyDb sDb = FantasyDb();

    for (var key in maps.keys){
      String eventDetails=maps[key];
      try {
//        EventsObject eveOb = EventsObject.fromString(eventDetails);

      String picUrl=await downloadFileGetUrI(eventDetails.split('<')[0]);
      eventDetails=eventDetails.replaceAll(eventDetails.split('<')[0], picUrl);
      await sDb.insertItem(id: key, item:eventDetails);
      itemList.add(
          FantasyView(eventDetails, isFromNetwork: true, deleteItemFunc: () {
            deleteItem(key.toString());
          },));
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

  static var httpClient = new HttpClient();

  Future<String> downloadFileGetUrI(String filId) async {
    try {

      final directory = await getApplicationDocumentsDirectory();
      String path = directory.path + '/FantasyDownloads';
      if (!Directory(path).existsSync()) await Directory(path).create();
      String fileId =filId;
      path += '/${fileId + '.jpg'}';
      if(File('$path').existsSync())
        return path;
      var request = await httpClient.getUrl(Uri.parse(kImageUrlStart+filId));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);

      File file = new File('$path');
      await file.writeAsBytes(bytes);
      return file.path;

    }catch(e){
    print('media download error ${e.toString()}');
      return '';
    }
  }
  String getUniqueId() {
    DateTime dt= DateTime.now();
    DateFormat df=DateFormat('yy:MM:dd:mm:ss');
    return df.format(dt).toString();
  }

  Future<void> setListFromDb() async {
    showProgress(true);
    itemList=[];
    FantasyDb sDb = FantasyDb();
    List<EventData> eventsList=await sDb.getEvents();
    for(EventData eves in eventsList){
//      itemList.add(EventItem(eventItem: eves,deleteItemFunc:  (){
//        deleteItem(eves.l);
//      }),);
      try {
//        EventsObject eveOb = EventsObject.fromString(eves.e);
        itemList.add(
            FantasyView(eves.e, isFromNetwork: true, deleteItemFunc: () {
              deleteItem(eves.l.toString());
            },));

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
    if(!(await uCheckInternet()) || ((await uGetSharedPrefValue('ldate')).toString())==formattedDate){
      showProgress(false);
      await setListFromDb();
      return;
    }
    itemList=[];
    DatabaseReference myRef=FirebaseDatabase.instance.reference().child('fantasy');
    DataSnapshot snapShot=await myRef.once();
    print('gotten value');
    print(snapShot.value.toString());
    if(snapShot.value.toString()=="null"){
      showProgress(false);
      return;
    }
    Map<dynamic , dynamic> maps= Map.from(snapShot.value);
    FantasyDb sDb = FantasyDb();

    for (var key in maps.keys){

      String eventDetails=maps[key];
      try {
        String picUrl=await downloadFileGetUrI(eventDetails.split('<')[0]);

        eventDetails=eventDetails.replaceAll(eventDetails.split('<')[0], picUrl);
        await sDb.insertItem(id: key, item:eventDetails);
        itemList.add(FantasyView(eventDetails, isFromNetwork: true,deleteItemFunc: (){
          deleteItem(key.toString());
        },));
      }catch(e){
        print("Event add exception ${e.toString()}");
      }
    }
    showProgress(false);
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
    await FirebaseDatabase.instance.reference().child('fantasy').child(key).remove();
    print('DELETED+');
    FantasyDb sDb = FantasyDb();
    await sDb.deleteItem(key);
    setListFromDb();
  }

  Future<void> initializeDownloder() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize(
        debug: true // optional: set false to disable printing logs to console
    );

  }

}
