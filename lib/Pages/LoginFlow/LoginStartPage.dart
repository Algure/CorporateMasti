import 'package:corporatemasti/Pages/LoginFlow/SignupPage.dart';
import 'package:corporatemasti/Utilities/constants.dart';
import 'package:corporatemasti/Utilities/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../NewsPage.dart';
import 'LoginPage.dart';

class LoginStartPage extends StatefulWidget {

  @override
  _LoginStartPageState createState() => _LoginStartPageState();
}

class _LoginStartPageState extends State<LoginStartPage> {
  bool showPassword=false;
  double marginVal=16;
  double buttonTextSize=20;
  Color textFillColor=Color(0x22FFFFFF);
  CurvedAnimation slideInLeftAnim;
  String password;
  String email;
  bool showProgress=false;

  FocusNode emailFocus= FocusNode();
  FocusNode paswordFocus= FocusNode();

  var hintColor=Colors.grey;
  var hintSelectedColor=Colors.grey;
  Color kThemeYellow=Colors.yellow;

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showProgress,
      color: Colors.black.withOpacity(0.9),
      child: Material(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                  tag: 'mainLogo',
                  child: Image.asset('images/logo.png', height: 150,)),
              SizedBox(height: 50),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: FlatButton(onPressed: (){
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupPage()));
                },
                  child: Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Text('Get Started', style: TextStyle(color: kThemeOrange, fontSize: buttonTextSize, fontWeight: FontWeight.bold),),
                  ),
                  splashColor: Colors.white,),
              ),
              SizedBox(height: 28,),
              Text('Already have an account? ', textAlign: TextAlign.end, style: kHintStyle,),
              SizedBox(height: 8,),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: kThemeOrange,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: FlatButton(onPressed: (){
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                },
                  child: Padding(
                    padding:  EdgeInsets.all(18.0),
                    child: Text('Log in', style: TextStyle(color: Colors.black,fontSize: buttonTextSize, fontWeight: FontWeight.bold),),
                  ),
                  splashColor: Colors.white,),
              ),
            ],
          ),
        ),
      ),
    );
  }

  setSpinner(bool b){
    showProgress=b;
    setState(() { });
  }

  toggleIconVisibility(){
    showPassword=!showPassword;
    setState(() {

    });
  }

  Future<void> checkDetails () async {
    try {
      bool cancel = false;
      // Check for a valid password, if the user entered one.
      if (password.isEmpty || password.length<5) {
        uShowErrorDialog(this.context,'An error occured: Invalid password.\nPassword cannot not be less than 5 characters.');
        cancel = true;
        return;
      }
      // Check for a valid email address.
      if (email.isEmpty) {
        cancel = true;
        uShowErrorDialog(this.context,'An error occured: Invalid email address');
        return;
      } else if (!email.contains('@')||!email.contains('.com')|| email.length<6) {
        uShowErrorDialog(this.context,'An error occured: Invalid email address');
        cancel = true;
        return;
      }
      if (cancel) {
        uShowErrorDialog(this.context,'An error occured\nInvalid credentials.');
        return;
      }else if(!(await uCheckInternet())){
        uShowNoInternetDialog(this.context);
      }
      else {
        setSpinner(true);
        attemptLogin();
      }
    }catch ( e){
      print(e);
      setSpinner(false);
      uShowErrorDialog(this.context,'An error occured');
    }
  }

  Future<void> attemptLogin() async {//This method is optimised to limit authentication tasks
    setSpinner(true);
    SharedPreferences sp = await SharedPreferences.getInstance();
    String falseEmail = sp.getString('failedMail') ?? '';
    try {
      print('failed Mails:$falseEmail');
      if (falseEmail.contains(email)) {
        setSpinner(false);
        showRetrievePasswordDialog('You have not reset your password');
        return;
      }
      DataSnapshot snapshot = await FirebaseDatabase.instance.reference().child("cus").child(
          email.replaceAll('.', '')).once();
      print('email safe: ${snapshot.value.toString()}');
      if (snapshot == null || snapshot.value == null) {
        setSpinner(false);
        showSignUpAgainDiaolog('Sorry: it appears we do not have your account.\nPlease quickly follow the sign-up process.');
        return;
      }
      bool error=false;

      print('gotten to sign IN');//Debug method
      FirebaseAuth fbauth = FirebaseAuth.instance;
      var userCred = await fbauth.signInWithEmailAndPassword(
          email: email, password: password);

      String id = userCred.user.uid.toString();
      DataSnapshot userDataSnapshot = await FirebaseDatabase.instance.reference().child('cad').child(id).once();
      print('userSnapshot: ${userDataSnapshot.value.toString()}');
      //if user is a registered seller, download his info.

      if (userDataSnapshot == null || userDataSnapshot.value == null) {
        setSpinner(false);
        showSignUpAgainDiaolog('Sorry: it appears there is an error with your account data.\nPlease sign up with another email.');
        return;
      }
      print (userDataSnapshot.value.toString());
      await uSetPrefsValue(kIdKey, id);
      for (var v in userDataSnapshot.value.entries) {
        if (v.key == 'e')
          await uSetPrefsValue('email', v.value.toString());
        else if (v.key == 'p')
          await uSetPrefsValue(kPhoneKey, v.value.toString());
        else if (v.key == 's')
          await uSetPrefsValue('state', v.value.toString());
        else if (v.key == 'w')
          await uSetPrefsValue('wallet', v.value.toString());
        else if (v.key == 'f')
          await uSetPrefsValue(kFnameKey, v.value.toString());
        else if (v.key == 'l')
          await uSetPrefsValue(kLnameKey, v.value.toString());
      }

      setSpinner(false);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return MyHomePage(justLoggedIn: true,);
      }));
    }catch(e){

      if(e.toString().contains('wrong-password')){
        print(e);
        falseEmail = sp.getString('failedMail') ?? '';
        falseEmail += ',$email';
        await sp.setString('failedMail', falseEmail);
        print(await sp.getString('failedMail'));
        setSpinner(false);
        showRetrievePasswordDialog();
        return;
      }
      setSpinner(false);
      uShowErrorDialog(context, 'An error occured ! Please re-check inputs');
      print(e);
    }
  }

  void showSignUpAgainDiaolog( String signUpText){
    uShowCustomDialog(context: this.context,
        icon: Icons.warning,
        iconColor: Colors.red,
        text: signUpText,
        buttonList: [
          ['Sign-Up', kLightBlue, () {

            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupPage()));
          }
          ]
        ]);
  }

  void showRetrievePasswordDialog([String s='Login attempt error. Password and email do not match.']){
    uShowCustomDialog(context: this.context,
        icon: Icons.error,
        iconColor: Colors.red,
        text: s,
        buttonList: [
          ['Retrieve password', Colors.blue, () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/retrieve');
          }
          ]
        ]);
  }

//  Future<void> uploadUserDataToCloudDatabase(String id) async {
//    await FirebaseDatabase.instance.reference().child("cus").child(_email.replaceAll('.', '')).set(id);
//    ProfileObject profile= ProfileObject();
//    profile.e=_email;
//    profile.f=_fname;
//    profile.l=_sname;
//    await FirebaseDatabase.instance.reference().child("cus").child(id).set(profile.toMap());
//  }
//
//  Future<void> saveUserToPrefs(String id) async {
//    await uSetPrefsValue('id', id);
//    await uSetPrefsValue('email', _email);
//    await uSetPrefsValue('pno', _pno);
//    await uSetPrefsValue('fname', _fname);
//    await uSetPrefsValue('lname', _sname);
//    await uSetPrefsValue('state',_state);
//    await uSetPrefsValue('password',_password);
//    await uSetPrefsValue('uploaded','false');
//  }


}
