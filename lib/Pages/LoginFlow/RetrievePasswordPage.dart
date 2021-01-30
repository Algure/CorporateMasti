import 'package:corporatemasti/Pages/LoginFlow/SignupPage.dart';
import 'package:corporatemasti/Utilities/constants.dart';
import 'package:corporatemasti/Utilities/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RetrievePasswordPage extends StatefulWidget {
  @override
  _RetrievePasswordPageState createState() => _RetrievePasswordPageState();
}

class _RetrievePasswordPageState extends State<RetrievePasswordPage> {
  bool progress=false;
  String _email;

  @override
  void initState() {

    showFailedMails();
  }

  @override
  Widget build(BuildContext context) {
    showFailedMails();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ModalProgressHUD(
        inAsyncCall: progress,
        color: Colors.black.withOpacity(0.4),
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
                SizedBox(height: 30,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    onChanged: (string){this._email=string;},
                    decoration: InputDecoration(
                        filled: true,
                        prefixIcon: Icon(CupertinoIcons.mail, color: Colors.black,),
                        labelText: 'Enter registered email address',
                        labelStyle: kHintStyle,
                        fillColor: Colors.white.withOpacity(0.2)
                    ),
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: Colors.black),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),

                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: FlatButton(onPressed: (){
                    sendRmail();
                  },
                    child: Text('Retrieve password', style: TextStyle(color: Colors.white),),
                    splashColor: Colors.white,),
                )
              ],
            ),
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

  Future<void> showFailedMails([String s='first']) async {
    SharedPreferences sp=await SharedPreferences.getInstance();
    await sp.reload();
    print('$s test failed mails ${sp.getString('failedMail')}');
  }

  void sendRmail() async{
    showProgress(true);
    SharedPreferences sp=await SharedPreferences.getInstance();
    _email=_email.trim();
    if(_email==null || _email.isEmpty ){
      showProgress(false);
      uShowErrorDialog(this.context,'email cannot be empty');
      return;
    }else if(!_email.contains('@')|| !_email.contains('.com')|| _email.contains(' ')){
      showProgress(false);
      uShowErrorDialog(this.context,'Invalid email');
      return;
    }

    try {
      if (!(await uCheckInternet())) {
        showProgress(false);
        uShowNoInternetDialog(this.context);
        return;
      }
      DataSnapshot snapshot = await FirebaseDatabase.instance.reference().child(
          "cus").child(_email.replaceAll('.', '')).once();
      if (snapshot == null || snapshot.value == null) {
        showProgress(false);
        showReSignUpDialog();
        return;
      }
      bool error = false;
      FirebaseAuth fbauth = FirebaseAuth.instance;
      await fbauth.sendPasswordResetEmail(email: _email).catchError((onError) =>
          () {
        if (onError != null) error = true;
      }
      );
      if (!error) {
        await notifyAccRetrived(_email);
        showRecoveryMailSentDialog();
        showProgress(false);
      } else {
        showProgress(false);
        uShowErrorNotification( 'Sorry. An error occured !!!');
      }
    }catch(error){
      showProgress(false);
      uShowErrorNotification( 'Sorry. An error occured !!!');
      print('error $error');
    }
  }

  Future<void> notifyAccRetrived(String mail) async {
    SharedPreferences sp=await SharedPreferences.getInstance();
    String failedEmails=await sp.getString('failedEmail')??'';
    String newmail=failedEmails.replaceAll(_email,"");
    await uSetPrefsValue('failedEmail',newmail);
    await showFailedMails('after send Mail');
  }

  void showRecoveryMailSentDialog(){
    uShowCustomDialog(context: this.context,
      icon: CupertinoIcons.mail_solid,
      iconColor: Colors.blueGrey,
      text: 'Recovery email has been sent to $_email. Please check your mail and reset password before attempting login.',
        buttonList: [
          ['Continue', kThemeOrange, () {
            Navigator.pop(context);//pop dialog
            Navigator.pop(context);//pop retrieve page
          }
          ]
        ]
    );
  }

  void showReSignUpDialog(){
    uShowCustomDialog(context: this.context,
        icon: CupertinoIcons.person,
        iconColor: Colors.blueGrey,
        text: 'Sorry. This email is not registered on Gmart.ng!!!',
        buttonList: [
          ['Sign-Up', kThemeOrange, () {
           Navigator.pop(context);//close dialog
           Navigator.pop(context);//pop retrieve page
           Navigator.pop(context);//pop login page
           Navigator.push(context, MaterialPageRoute(builder:(context)=>SignupPage()));
          }
          ]
        ]
    );
  }
}
