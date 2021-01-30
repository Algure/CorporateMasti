import 'dart:io';

import 'package:corporatemasti/Utilities/constants.dart';
import 'package:corporatemasti/Utilities/utilities.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ProfileObject.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  bool progress=false;
  double marginVal=8;
  double buttonTextSize=20;
  Color textFillColor=Color(0xFFEEEEEE);
  final picker= ImagePicker();

  String id='';//customer id
  String _email='';//customer email
  String _phoneNumber='';//customer phone number
  String _address='';//customer address
  String wallet='';//wallet amount
  String _fname='';//first name
  String _sname='';//sur / last name
  String imageUrl='';
  String newImageUrl='';

  FocusNode snameFocus=FocusNode();
  FocusNode fnameFocus=FocusNode();
  FocusNode emailFocus=FocusNode();
  FocusNode email2Focus=FocusNode();
  FocusNode phoneNumFocus=FocusNode();
  FocusNode passwordFocus=FocusNode();
  FocusNode addressFocus=FocusNode();
  FocusNode compoundFocus=FocusNode();

  @override
  void initState() {
    setProfileDetails();
  }

  @override
  Widget build(BuildContext context) {
    Color textFillColor=Color(0xFFEFEFEF);
    double buttonTextSize=20;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation:0,
        backgroundColor:Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          FlatButton(
            onPressed: (){
              attemptProfileUpdate();
            },
            splashColor: Colors.white,
            child: Icon(Icons.cloud_upload),
          )
        ],
      ),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: progress,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal:18.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children:[
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.white,
                        backgroundImage: imageUrl.isNotEmpty?FileImage(File(imageUrl), ):AssetImage('images/profileDark.png',),
                    ),
                      ),
                      Container(
                        height: 180,
                        margin: EdgeInsets.only(left:100),
                        alignment: Alignment.bottomCenter ,
                        child: FlatButton(
                            splashColor: Colors.white,
                            onPressed: (){
                              selectImage();
                            },
                            child: Icon(Icons.camera, color: Colors.black, size: 30, )),
                      )
                    ]
                  ),
                  Text('$_fname $_sname', style: TextStyle(color: kThemeOrange, fontSize: 26, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5,),
                  Text('$_email', style:kHintStyle),
                  SizedBox(height: 25,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                    Padding(
                      padding:  EdgeInsets.only(right:18.0),
                      child: Text('A/C',textAlign:TextAlign.start, style:TextStyle(color:Colors.grey, fontSize: 10)),
                    ),
                    Text('\$${wallet==null||wallet.isEmpty?'0':wallet}', style: TextStyle(color: kGreen, fontSize: 16)),
                  ]
                  ),
                  SizedBox(height: 25,),
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
                              controller: TextEditingController(text:_fname),
                              maxLength: 10,
                              maxLengthEnforced: true,
                              inputFormatters:[
                                LengthLimitingTextInputFormatter(10)
                              ],
                              decoration: InputDecoration(
                                  filled: true,
//                            prefixIcon: Icon(CupertinoIcons.person, color: Colors.white,),
                                  labelText: 'First Name',
                                  labelStyle: kHintStyle,
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
                              controller: TextEditingController(text:_sname),
                              maxLength: 10,
                              maxLengthEnforced: true,
                              inputFormatters:[
                                LengthLimitingTextInputFormatter(10)
                              ],
                              decoration: InputDecoration(
                                  filled: true,
//                              prefixIcon: Icon(CupertinoIcons.person, color: Colors.white,),
                                  labelText: 'Last Name',
                                  labelStyle:kHintStyle,
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
                          labelText: 'Email',
                          labelStyle: kHintStyle,
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
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: marginVal),
                    child: TextField(
                      onChanged: (string){_phoneNumber=string;},
                      focusNode: phoneNumFocus,
                      controller: TextEditingController(text: _phoneNumber),
                      decoration: InputDecoration(
                          filled: true,
                          prefixIcon: Icon(CupertinoIcons.phone, color: Colors.black,),
                          labelText: 'Phone Number',
                          labelStyle: kHintStyle,
                          fillColor: textFillColor,
                          focusedBorder: linedBorder,
                          enabledBorder: linedBorder,
                          disabledBorder: linedBorder
                      ),
                      textInputAction: TextInputAction.next,
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: marginVal),
                    child: TextField(
                      onChanged: (string){_address=string;},
                      focusNode: addressFocus,
                      controller: TextEditingController(text: _address),
                      decoration: InputDecoration(
                          filled: true,
                          prefixIcon: Icon(CupertinoIcons.location, color: Colors.black,),
                          labelText: 'Address',
                          labelStyle: kHintStyle,
                          fillColor: textFillColor,
                          focusedBorder: linedBorder,
                          enabledBorder: linedBorder,
                          disabledBorder: linedBorder
                      ),
                      textInputAction: TextInputAction.next,
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.text,
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
                      },
                    child: Padding(
                      padding:  EdgeInsets.all(18.0),
                      child: Text('Credit Wallet', style: TextStyle(color: Colors.black,fontSize: buttonTextSize, fontWeight: FontWeight.bold),),
                    ),
                    splashColor: Colors.white,),
                  ),
                  SizedBox(height:50)
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showProgress(bool b) {
    setState(() {
      progress=b;
    });
  }

  Future<void> setProfileDetails() async {
    showProgress(true);
    id=(await uGetSharedPrefValue(kIdKey)).toString();
    _fname= (await uGetSharedPrefValue(kFnameKey)).toString();
    _sname= (await uGetSharedPrefValue(kLnameKey )).toString();
    _email= (await uGetSharedPrefValue(kMailKey)).toString();
    _phoneNumber=((await uGetSharedPrefValue(kPhoneKey))??'').toString();
    _address= (await uGetSharedPrefValue(kAdressKey)).toString();
    wallet= (await uGetSharedPrefValue(kWalletKey)).toString();
    imageUrl= (await uGetSharedPrefValue(kProfilePicOnPhone)).toString();
    showProgress(false);
  }

  selectImage() async {
    showProgress(true);
    try {
      PickedFile tempFile = await picker.getImage(source: ImageSource.gallery);
      print('tempfile ${tempFile.toString()}');
      String compressedPath = await compressImage(
          File(tempFile.path).absolute.path);
      newImageUrl = compressedPath;
      imageUrl = compressedPath;
      showProgress(false);
    }catch(exception){
      print('error: $exception');
      showProgress(false);
    }
  }

  Future<String> compressImage(String imagePath) async {
    final directory= await getApplicationDocumentsDirectory();
    String path= directory.path+'/CorporateMasti';
    if(!Directory(path).existsSync()) await Directory(path).create();
    String fileId=getUniqueId();
    path+='/$fileId.jpg';
    File newFile=File(path);
    await newFile.create();
    File compressionFile= await FlutterImageCompress.compressAndGetFile(imagePath, path, quality: 25, rotate: 0);
    return compressionFile.path;
  }


  String getUniqueId() {
    List<String> idSrc=FirebaseDatabase.instance.reference().push().key.toString().split('/');
    String id=idSrc[idSrc.length-1];
    return(id.replaceAll('.', '').replaceAll('#', '').replaceAll('[', '').replaceAll(']', '').replaceAll('*', ''));
  }

  Future<bool> isOkToUpload() async {
    DateTime now= DateTime.now();
    String formattedDate=  DateFormat('YY:MM').format(now);
    SharedPreferences sp=await SharedPreferences.getInstance();
    if(sp.containsKey(formattedDate)){
      String uploadTimes= (await sp.get(formattedDate)).toString();
      int times= int.tryParse(uploadTimes)??0;
      if(times<=kMaxProfileUpdatesAMonth)
        return true;
      else
        return false;
    }
    await uSetPrefsValue(formattedDate, '0');
    return true;
  }

  Future<void> updateProfileUploadTime() async {
    DateTime now= DateTime.now();
    String formattedDate=  DateFormat('YY:MM').format(now);
    SharedPreferences sp=await SharedPreferences.getInstance();
    if(sp.containsKey(formattedDate)){
      String uploadTimes= (await sp.get(formattedDate)).toString();
      int times= int.tryParse(uploadTimes)??0;
      times++;
      await uSetPrefsValue(formattedDate, times.toString());
    }
    await uSetPrefsValue(formattedDate, '0');
    return true;
  }

  Future<void> attemptProfileUpdate() async {
    if(!detailsAreValid()){
      return;
    }
    showProgress(true);
    try {
      if (!(await isOkToUpload())) {
        showProgress(false);
        uShowErrorNotification(
            'You have exceeded profile update limit for this month.');
        return;
      }
      if (!(await uCheckInternet())) {
        showProgress(false);
        uShowNoInternetDialog(context);
        return;
      }
      ProfileObject profile = ProfileObject();
      profile.f = _fname;
      profile.l = _sname;
      profile.e =(await uGetSharedPrefValue(kMailKey)).toString(); //customer email
      profile.p = _phoneNumber; //customer phone number
      profile.a = _address; //customer address
      profile.w = (await uGetSharedPrefValue(kWalletKey)).toString(); //wallet amount
      profile.s = await getImageUrl();
      await FirebaseDatabase.instance.reference().child("PROFILE")
          .child(id)
          .set(profile.toMap());
      await saveProfileToPrefs(profile);
      await updateProfileUploadTime();
      uShowMessageNotification('Profile saved ✔✔');
    }catch(exception){
      print('error: $exception');
      uShowErrorNotification('An error occured.');
    }
    showProgress(false);

  }

  Future<String> getImageUrl() async{
    if(newImageUrl!=null && newImageUrl.isEmpty)
      return (await uGetSharedPrefValue(kProfilePicOnline)).toString();

    FirebaseStorage storage=FirebaseStorage.instance;
    String downloadUrl='';
    String picId=getUniqueIdWPath(newImageUrl);
    Reference ref=storage.ref().child('L').child(picId);
    UploadTask uploadTask=ref.putFile(File(newImageUrl));

    await uploadTask.then((snapshot) async {
      downloadUrl=await snapshot.ref.getDownloadURL();
    });
    print("download url: "+downloadUrl);
    List<String> downloadUrls=downloadUrl.split('/');
    return downloadUrls[downloadUrls.length-1];
  }

  String getUniqueIdWPath(String path) {
    List unis=path.split('/');
    return unis[unis.length-1].replaceAll('.jpg','');
  }

  saveProfileToPrefs(ProfileObject profile) async {
    await uSetPrefsValue(kFnameKey, profile.f);
    await uSetPrefsValue(kLnameKey, profile.l);
    await uSetPrefsValue(kMailKey, profile.e);
    await uSetPrefsValue(kPhoneKey, profile.p);
    await uSetPrefsValue(kAdressKey, profile.a);
    await uSetPrefsValue(kWalletKey, profile.w);
    await uSetPrefsValue(kProfilePicOnline, profile.s);
    await uSetPrefsValue(kProfilePicOnPhone, imageUrl);
  }

  bool detailsAreValid() {
    _fname = _fname.trim();
    if (_fname == null || _fname.isEmpty) {
      showProgress(false);
      uShowErrorDialog(this.context, 'First name cannot be empty');
      return false;
    } else if (_fname.contains(' ')) {
      showProgress(false);
      uShowErrorDialog(
          this.context, 'First name cannot contain white/empty space');
      return false;
    }else if(_fname.length>10){
      showProgress(false);
      uShowErrorDialog(
          this.context, 'First name length is too long');
      return false;
    }

    _sname = _sname.trim();
    if (_sname == null || _sname.isEmpty) {
      showProgress(false);
      uShowErrorDialog(this.context, 'Last/Sur name cannot be empty');
      return false;
    } else if (_sname.contains(' ')) {
      showProgress(false);
      uShowErrorDialog(
          this.context, 'Last/Sur name cannot contain white/empty space');
      return false;
    }else if(_sname.length>10){
      showProgress(false);
      uShowErrorDialog(
          this.context, 'Last name length is too long');
      return false;
    }

    return true;
  }
}
