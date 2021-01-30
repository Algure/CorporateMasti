import 'dart:io';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:corporatemasti/Pages/LoginFlow/LoginPage.dart';
import 'package:corporatemasti/Pages/LoginFlow/TeamChoosePage.dart';
import 'package:corporatemasti/Utilities/constants.dart';
import 'package:corporatemasti/Utilities/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ProfileObject.dart';
import '../NewsPage.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool showPassword=false;
  double marginVal=8;
  Color textFillColor=Color(0xFFDDDDDD);
  AnimationController _controller;
  CurvedAnimation slideInLeftAnim;

  String _email;
  String _email2;
  String _pno;
  String _fname;
  String _sname;
  String _state;
  String _password;
  String _password2;
  bool progress=false;
  String selectedState='Nigeria';
  CupertinoPicker stateCupPicker;
  GlobalKey<AutoCompleteTextFieldState<String>>key=new GlobalKey();
  Widget stateDropDown;

  FocusNode snameFocus=FocusNode();
  FocusNode fnameFocus=FocusNode();
  FocusNode emailFocus=FocusNode();
  FocusNode email2Focus=FocusNode();
  FocusNode phoneNumFocus=FocusNode();
  FocusNode passwordFocus=FocusNode();
  FocusNode password2Focus=FocusNode();
  FocusNode compoundFocus=FocusNode();

  Color hintColor=Colors.grey;
  Color hintSelectedColor=Colors.grey;

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    Color textFillColor=Color(0xFFEEEEEE);
    double marginVal=8;
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: progress,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 55,),
                      Hero(
                          tag: 'mainLogo',
                          child: Image.asset('images/logo.png', height: 150,)),
                      SizedBox(height: 15,),
                      Container(
                        height: 70,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal:marginVal),
                                child: TextField(
                                  onChanged: (string){_fname=string;},
                                  focusNode: fnameFocus,
                                  maxLength: 10,
                                  maxLengthEnforced: true,
                                  inputFormatters:[
                                    LengthLimitingTextInputFormatter(10)
                                  ],
                                  decoration: InputDecoration(
                                    filled: true,
//                            prefixIcon: Icon(CupertinoIcons.person, color: Colors.white,),
                                    labelText: 'Enter first name',
                                    labelStyle: TextStyle(
                                        color:fnameFocus.hasFocus?hintColor:hintSelectedColor
                                    ),
                                    counterStyle: kHintStyle,
                                    fillColor: textFillColor,
                                    focusedBorder: linedBorder,
                                    enabledBorder: linedBorder,
                                    disabledBorder: linedBorder
                                  ),
                                  textInputAction: TextInputAction.next,
                                  style: TextStyle(color: Colors.black),
                                  keyboardType: TextInputType.name,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal:marginVal),
                                child: TextField(
                                  onChanged: (string){_sname=string;},
                                  focusNode: snameFocus,
                                  maxLength: 10,
                                  maxLengthEnforced: true,
                                  inputFormatters:[
                                    LengthLimitingTextInputFormatter(10)
                                  ],
                                  decoration: InputDecoration(
                                      filled: true,
//                              prefixIcon: Icon(CupertinoIcons.person, color: Colors.white,),
                                      labelText: 'Enter last name',
                                      labelStyle: TextStyle(
                                          color:snameFocus.hasFocus?hintColor:hintSelectedColor
                                      ),
                                      hintStyle: TextStyle(
                                          color: Colors.grey
                                      ),
                                      counterStyle: kHintStyle,
                                      helperStyle: TextStyle(color: Colors.blue),
                                      fillColor: textFillColor,
                                      focusedBorder: linedBorder,
                                      enabledBorder: linedBorder,
                                      disabledBorder: linedBorder
                                  ),
                                  textInputAction: TextInputAction.next,
                                  style: TextStyle(color: Colors.black),
                                  keyboardType: TextInputType.name,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: marginVal),
                        child: TextField(
                          onChanged: (string){_email=string;},
                          focusNode: emailFocus,
                          controller: TextEditingController(text: _email),
                          decoration: InputDecoration(
                              filled: true,
                              prefixIcon: Icon(CupertinoIcons.mail, color: Colors.black,),
                              labelText: 'Enter email',
                              labelStyle: TextStyle(
                                  color:emailFocus.hasFocus?hintColor:hintSelectedColor
                              ),
                              fillColor: textFillColor,
                              focusedBorder: linedBorder,
                              enabledBorder: linedBorder,
                              disabledBorder: linedBorder
                          ),
                          textInputAction: TextInputAction.next,
                          style: TextStyle(color: Colors.black),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text('Enter and confirm password.\nPassword must be at least 6 characters long.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 10),),
                      SizedBox(height: 10,),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: marginVal),
                        child: TextField(
                          onChanged: (string){_password=string;},
                          focusNode: passwordFocus,
                          controller: TextEditingController(text: _password),
                          decoration: InputDecoration(
                              filled: true,
                              prefixIcon: Icon(CupertinoIcons.lock, color: Colors.black,),
                              suffixIcon: IconButton(icon: Icon(showPassword?Icons.visibility:Icons.visibility_off, color: Colors.grey,), onPressed: toggleIconVisibility,),
                              labelText: 'Enter password',
                              labelStyle: TextStyle(
                                  color:passwordFocus.hasFocus?hintColor:hintSelectedColor
                              ),
                              fillColor: textFillColor,
                              focusedBorder: linedBorder,
                              enabledBorder: linedBorder,
                              disabledBorder: linedBorder
                          ),
                          textInputAction: TextInputAction.next,
                          style: TextStyle(color: Colors.black),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: showPassword?false:true,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: marginVal),
                        child: TextField(
                          onChanged: (string){_password2=string;},
                          focusNode: password2Focus,
                          decoration: InputDecoration(
                              filled: true,
                              prefixIcon: Icon(CupertinoIcons.lock, color: Colors.black,),
                              suffixIcon: IconButton(icon: Icon(showPassword?Icons.visibility:Icons.visibility_off, color: Colors.grey,), onPressed: toggleIconVisibility,),
                              labelText: 'Confirm password',
                              labelStyle: TextStyle(
                                  color:password2Focus.hasFocus?hintColor:hintSelectedColor
                              ),
                              fillColor: textFillColor,
                              focusedBorder: linedBorder,
                              enabledBorder: linedBorder,
                              disabledBorder: linedBorder
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
                          attemptSave();
//                        Navigator.push(context, MaterialPageRoute(builder: (context)=>TeamChoosePage()));
                        },
                          child: Text('Sign up', style: TextStyle(color: Colors.black),),
                          splashColor: Colors.white,),
                      ),
                      SizedBox(height: 30,),
                      Container(
                        height: 45,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Text('Already have an account?', textAlign: TextAlign.end, style: kHintStyle,),
                            ),
                            SizedBox(width: 10,),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: GestureDetector(onTap: (){
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                              },
                                child: Text('Sign in', textAlign: TextAlign.start, style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: kThemeOrange),),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 100,),
                    ],
                  ),
                ),
              ]
          ),
        ),
      ),
    );

  }

  void showProgress(bool b){
    progress=b;
    setState(() {

    });
  }

  Future<void> attemptSave() async {
    showProgress(true);
    try {
      _fname = _fname.trim();
      if (_fname == null || _fname.isEmpty) {
        showProgress(false);
        uShowErrorDialog(this.context, 'First name cannot be empty');
        return;
      } else if (_fname.contains(' ')) {
        showProgress(false);
        uShowErrorDialog(
            this.context, 'First name cannot contain white/empty space');
        return;
      }else if(_fname.length>10){
        showProgress(false);
        uShowErrorDialog(
            this.context, 'First name length is too long');
        return;
      }

      _sname = _sname.trim();
      if (_sname == null || _sname.isEmpty) {
        showProgress(false);
        uShowErrorDialog(this.context, 'Last/Sur name cannot be empty');
        return;
      } else if (_sname.contains(' ')) {
        showProgress(false);
        uShowErrorDialog(
            this.context, 'Last/Sur name cannot contain white/empty space');
        return;
      }else if(_sname.length>10){
        showProgress(false);
        uShowErrorDialog(
            this.context, 'Last name length is too long');
        return;
      }

      _email = _email.trim();
      if (_email == null || _email.isEmpty) {
        showProgress(false);
        uShowErrorDialog(this.context, 'email cannot be empty');
        return;
      } else if (!_email.contains('@') || !_email.contains('.com') ||
          _email.contains(' ')) {
        showProgress(false);
        uShowErrorDialog(this.context, 'Invalid email');
        return;
      }

//      _pno = _pno.trim();
//      if (_pno == null || _pno.isEmpty) {
//        showProgress(false);
//        uShowErrorDialog(this.context, 'Phone number cannot be empty');
//        return;
//      } else if (_pno.length != 11) {
//        showProgress(false);
//        uShowErrorDialog(this.context, 'Invalid phone number');
//        return;
//      }

      if (_password.isEmpty || _password2.isEmpty) {
        showProgress(false);
        uShowErrorDialog(this.context, 'Password cannot be empty');
        return;
      } else if (_password2 != _password) {
        showProgress(false);
        uShowErrorDialog(this.context, 'Password does not match');
        return;
      }else if (_password2.length<6) {
        showProgress(false);
        uShowErrorDialog(this.context, 'Password is too short');
        return;
      }
      if (!(await uCheckInternet())) {
        showProgress(false);
        uShowNoInternetDialog(this.context);
        return;
      }
      attemptSignUp();
    }catch(e){
      showProgress(false);
      uShowErrorDialog(context, 'An error occured. Please check inputs.');
    }
  }

  Future<void> attemptSignUp() async {
    print('sign up mail $_email');
    try {
      DataSnapshot snapshot = await FirebaseDatabase.instance.reference().child(
          "cus").child(_email.replaceAll('.', '')).once();
      if (snapshot != null && snapshot.value.toString() != "null") {
        print('sign up mail value ${snapshot.value.toString()}');
        showProgress(false);
        uShowCustomDialog(
          context: this.context,
          icon: CupertinoIcons.person,
          iconColor: Colors.blueGrey,
          text: 'It appears this email is registered.\nSign-up with another email.',
        );
        return;
      }
      bool hasError = false;
      FirebaseAuth fbauth = FirebaseAuth.instance;
      var userCred = await fbauth.createUserWithEmailAndPassword(
          email: _email, password: _password).catchError((onError)
      {
        if(onError != null){
          print('error string ${onError.toString()}');
          hasError = true;
        }
      });
      if (userCred==null||userCred.user.uid == null || hasError) {
        showProgress(false);
        showProfileErrorDialog();
        return;
      }
      String id = userCred.user.uid.toString();
      await uploadUserDataToCloudDatabase(id);
      await saveUserToPrefs(id);

      print('ran others');

      showProgress(false);
      moveToTeamChoosePage();
    }catch(exception){
      print('exception: ${exception.toString()}');
      showProgress(false);
      uShowErrorDialog(this.context,'An error occured');
    }
  }

  void showProfileErrorDialog(){
    uShowCustomDialog(
      context: this.context,
      icon: CupertinoIcons.person,
      iconColor: Colors.blueGrey,
      text: 'An error occured !',
    );
  }

  void moveToTeamChoosePage(){
    Navigator.pop(this.context);
    Navigator.push(this.context, MaterialPageRoute(builder: (context){
      return TeamChoosePage();
    }));
  }

  Future<void> uploadUserDataToCloudDatabase(String id) async {
    await FirebaseDatabase.instance.reference().child("cus").child(_email.replaceAll('.', '')).set(id);
    ProfileObject profile= ProfileObject();
    profile.e=_email;
    profile.f=_fname;
    profile.l=_sname;
    await FirebaseDatabase.instance.reference().child("PROFILE").child(id).set(profile.toMap());
  }

  Future<void> saveUserToPrefs(String id) async {
    await uSetPrefsValue('id', id);
     await uSetPrefsValue('email', _email);
    await uSetPrefsValue('pno', _pno);
    await uSetPrefsValue('fname', _fname);
    await uSetPrefsValue('lname', _sname);
    await uSetPrefsValue('state',_state);
    await uSetPrefsValue('password',_password);
    await uSetPrefsValue('uploaded','false');
  }

  toggleIconVisibility(){
    showPassword=!showPassword;
    setState(() {
    });
  }

//  Widget getPicker(){
//    if(Platform.isIOS){
//      return  CupertinoPicker(
//          squeeze: 3,
//          diameterRatio: 1.5,
//          useMagnifier: true,
//          magnification: 1.2,
//          itemExtent: 35, onSelectedItemChanged: (dex){
//        _state=kStateList[dex].value.toString();
//      }, children: kCupertinoStateList);
//    }
//    return DropdownButtonHideUnderline(
//      child: ButtonTheme(
//          alignedDropdown: true,
//          child: DropdownButton<String>(
//              value: _state,
//              hint: Text('Select state', style: TextStyle(color: hintColor),),
//              dropdownColor: kLightBlue,
//              isDense: true,
//              style: kStatePickerTextStyle,
//              items: kStateList,
//              onChanged: (value){
//                _state=value.toString();
//                print(_state);
//                setState(() {
//                  _state=value.toString();
//                });
//              })),
//    );
//  }
}
