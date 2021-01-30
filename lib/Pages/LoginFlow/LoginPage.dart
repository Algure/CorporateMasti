import 'package:corporatemasti/Pages/LoginFlow/RetrievePasswordPage.dart';
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

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showPassword=false;
  double marginVal=16;
  Color textFillColor=Color(0xFFEEEEEE);
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                      tag: 'mainLogo',
                      child: Image.asset('images/logo.png', height: 150,)),
                  SizedBox(height: 30,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: marginVal),
                    child: TextField(
                      onChanged: (string){email=string.toString();},
                      focusNode: emailFocus,
                      decoration: InputDecoration(
                          filled: false,
                          labelText: 'Enter email',
                          labelStyle: TextStyle(
                              color:emailFocus.hasFocus?hintColor:hintSelectedColor
                          ),
                          fillColor: textFillColor,
                          enabledBorder: linedBorder,
                          focusedBorder: linedFocusedBorder
                      ),
                      textInputAction: TextInputAction.next,
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: marginVal),

                    child: TextField(
                      onChanged: (string){password=string.toString();},
                      focusNode: paswordFocus,
                      decoration: InputDecoration(
                          filled: false,
                          suffixIcon: IconButton(icon: Icon(showPassword?Icons.visibility_off:Icons.visibility, color: Colors.grey,),
                            onPressed: toggleIconVisibility,),
                          labelText: 'Enter password',
                          labelStyle: TextStyle(
                              color:paswordFocus.hasFocus?hintColor:hintSelectedColor
                          ),
                          fillColor: textFillColor,
                          enabledBorder: linedBorder,
                          focusedBorder: linedFocusedBorder
                      ),
                      textInputAction: TextInputAction.done,
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: showPassword?false:true,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: kThemeOrange,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: FlatButton(onPressed: (){
                      checkDetails();
                    },
                      child: Text('Sign in', style: TextStyle(color: Colors.black),),
                      splashColor: Colors.white,),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: GestureDetector(onTap: (){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupPage()));
                          },
                            child: Text('Sign up', textAlign: TextAlign.start, style: TextStyle(color: kThemeOrange),),
                          ),
                        ),
                        SizedBox(width: 8,),
                        Icon(CupertinoIcons.chevron_right, color: kThemeOrange,size: 14,),
                        SizedBox(width: 20,)
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text('Click to ', textAlign: TextAlign.end, style: kHintStyle,),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: GestureDetector(onTap: (){
//                        launchRetrievePasswordUrl();
                      },
                        child: Text(' retrieve password', textAlign: TextAlign.start, style: TextStyle(color: kThemeOrange),),
                      ),
                    ),
                  ],
                ),
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
      if (password.isEmpty || password.length<6) {
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
        uShowCustomDialog(context: this.context,
            icon: CupertinoIcons.person_add,
            iconColor: Colors.blueGrey,
            text: 'Sorry: it appears we do not have your account.\nPlease quickly follow the sign-up process.',
            buttonList: [
              ['Sign-Up', kLightBlue, () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupPage()));
              }
              ]
            ]);
        return;
      }
      bool error=false;
      print('gotten to sign IN');//Debug method
      FirebaseAuth fbauth = FirebaseAuth.instance;
      var userCred = await fbauth.signInWithEmailAndPassword(
          email: email, password: password);

      if (userCred == null || userCred.user.uid == null) {
        setSpinner(false);
        uShowErrorDialog(context, 'An error occured.');
        return;
      }
      String id = userCred.user.uid.toString();
      DataSnapshot userDataSnapshot = await FirebaseDatabase.instance.reference().child('PROFILE').child(id).once();

      print('userSnapshot: ${userDataSnapshot.value.toString()}');
      //if user is a registered seller, download his info.

      if (userDataSnapshot == null || userDataSnapshot.value == null) {
        setSpinner(false);
        uShowErrorDialog(context,'Sorry! it appears there is an error with your information.');
        return;
      }
      print (userDataSnapshot.value.toString());

      await saveUserData(id: id, userDataSnapshot: userDataSnapshot);
      setSpinner(false);
      moveToHomePage();
    }catch(e){

      if(e.toString().contains('wrong-password')){
        print(e);
        await saveEmailAsFailed(email);
        setSpinner(false);
        showRetrievePasswordDialog();
        return;
      }
      setSpinner(false);
      uShowErrorDialog(context, 'An error occured ! Please re-check inputs');
      print(e);
    }
  }

  void moveToHomePage(){
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return MyHomePage(justLoggedIn: true,);
    }));
  }

  void moveToRetrievePassPage(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return RetrievePasswordPage(justLoggedIn: true,);
    }));
  }

  Future<void> saveUserData({var userDataSnapshot, String id}) async {
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
    await uSetPrefsValue('id', id);

  }

  Future<void> saveEmailAsFailed(String email) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String falseEmail = sp.getString('failedMail') ?? '';
    falseEmail = sp.getString('failedMail') ?? '';
    falseEmail += ',$email';
    await sp.setString('failedMail', falseEmail);
    print(await sp.getString('failedMail'));
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

}
