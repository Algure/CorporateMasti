
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constants.dart';


const kImageUrlStart='https://firebasestorage.googleapis.com/v0/b/soccerevents-e5543.appspot.com/o/';

Future<bool> uCheckInternet() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}

Future<void> kLoadClickLink(String link) async {
  await launch(link);
}

Future<void> uSetPrefsValue(String key, var value) async {
  SharedPreferences sp=await SharedPreferences.getInstance();
  if(sp.containsKey(key)){
    await sp.remove(key);
  }
  await sp.reload();
  await sp.setString(key, value.toString());
  await sp.commit();
}
Future<dynamic> uGetSharedPrefValue(String key) async {
  SharedPreferences sp=await SharedPreferences.getInstance();
  if(sp.containsKey(key))
    return sp.get(key).toString();
  else
    return '';
}

void uShowMessageNotification(String text) {
  showSimpleNotification(
        Text(text??'', style: TextStyle(color: Colors.green),),
      leading:Icon(Icons.check, color:Colors.white),
      background: Colors.white);
}

void uShowErrorNotification(String text){
  showSimpleNotification(
      Text(text, style: TextStyle(color: Colors.white),),
      leading:Icon(Icons.warning, color:Colors.white),
      background: Colors.red);
}

void uShowNoInternetDialog(BuildContext context){
  uShowCustomDialog(context:context, icon: CupertinoIcons.cloud_bolt_rain, iconColor: Colors.grey,text:'No iternet connection. 😕');
}

void uShowErrorDialog(BuildContext context, String errorText){
  uShowCustomDialog(context: context, icon:Icons.warning, iconColor: Colors.red, text: errorText );
}

Future<void> uShowSignupDialog({ BuildContext context}) async {
  String fname=await uGetSharedPrefValue(kFnameKey);
  String sname=await uGetSharedPrefValue(kLnameKey);
  Dialog creditDialog= Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    backgroundColor: kDialogLight,
    child: Container(
      height: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20,),
          Padding(
              padding: const EdgeInsets.symmetric(vertical:20.0),
              child:Icon(Icons.auto_awesome, color: kThemeOrange, size: 200,)          ),
          SizedBox(height: 30,),
          Expanded(child: Text('Welcome ${fname} $sname ! 😊.', style: TextStyle(color:kThemeBlue, fontSize: 20, fontWeight: FontWeight.bold),textAlign: TextAlign.center, )),
          SizedBox(height: 12,),
        ],
      ),
    ),
  );
  showGeneralDialog(context: context,
      barrierLabel: sname,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 500),
      transitionBuilder: (_, anim, __, child){
        return SlideTransition(position: Tween(begin: Offset(0,1), end: Offset(0,0)).animate(anim), child: child,);
      },
      pageBuilder: (BuildContext context, _, __)=>(creditDialog));
}

Future<void> uShowLoginDialog({ BuildContext context}) async {
  String fname=await uGetSharedPrefValue(kFnameKey);
  String sname=await uGetSharedPrefValue(kLnameKey);
  Dialog creditDialog= Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    backgroundColor: kDialogLight,
    child: Container(
      height: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20,),
          Padding(
              padding: const EdgeInsets.symmetric(vertical:20.0),
              child:Icon(Icons.auto_awesome, color: kThemeOrange, size: 200,)          ),
          SizedBox(height: 30,),
          Expanded(child: Text('Welcome back ${fname} $sname ! We did miss you 😊.',
            style: TextStyle(color:kThemeBlue, fontSize: 20, fontWeight: FontWeight.bold),textAlign: TextAlign.center, )),
          SizedBox(height: 12,),
        ],
      ),
    ),
  );
  showGeneralDialog(context: context,
      barrierLabel: 'cjns',
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 500),
      transitionBuilder: (_, anim, __, child){
        return SlideTransition(position: Tween(begin: Offset(0,1), end: Offset(0,0)).animate(anim), child: child,);
      },
      pageBuilder: (BuildContext context, _, __)=>(creditDialog));
}

void uShowCustomDialog({BuildContext context, IconData icon, Color iconColor, String text, List buttonList}){
  List<Widget> butList=[];
  if(buttonList!=null && buttonList.length>0){
    for(var arr in buttonList){
      butList.add(Expanded(
        child: Container(
          margin: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
              color: arr[1],
              borderRadius: BorderRadius.circular(20)
          ),
          child: FlatButton(onPressed: arr[2],
            child: Padding(
              padding: EdgeInsets.all(2),
              child: Text(arr[0], style: TextStyle(color: Colors.black),),
            ),
            splashColor: Colors.white,),
        ),
      ));
    }
  }
  Dialog errorDialog= Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    backgroundColor: Color(0xFFDDDDFF),
    child: Container(
      height: 350,
      child: Column(
        children: [
          Expanded(child: Icon(icon, color: iconColor, size: 200,)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(text, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
          ),
          SizedBox(height: 20,),
          Container(
            height: butList!=null?50:2,
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: buttonList!=null?butList:[],
            ),
          )
        ],
      ),
    ),
  );
  showGeneralDialog(context: context,
      barrierLabel: text,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 500),
      transitionBuilder: (_, anim, __, child){
        return SlideTransition(position: Tween(begin: Offset(-1,0), end: Offset(0,0)).animate(anim), child: child,);
      },
      pageBuilder: (BuildContext context, _, __)=>(errorDialog)
  );
}
