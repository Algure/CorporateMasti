import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const TextStyle kPageTitleStyle=TextStyle(color: kGreen, fontWeight: FontWeight.bold, fontSize: 15, );
const double kWidgetWidth=200;

const TextStyle kTitleStyle= TextStyle(color: kGreen, fontWeight: FontWeight.bold, fontSize: 10);
const TextStyle kSubtitleStyle=  TextStyle(color: Colors.black,  fontSize: 12);
const TextStyle kTeamStyle=  TextStyle(color: Colors.white,  fontSize: 10);
const double kWidgetsMargin=15;

const kNavSelectedColor=Colors.black;
const kBackgroundColor=Color(0xFFEEEEEE);
const kDialogLight=Color(0xFFEEEEFF);
const kThemeBlue=Colors.blueAccent;
const kThemeOrange=Color(0xFFfdca40);
const Color kGreen =Color(0xFF007600);
const Color kLightBlue =Colors.blue;
const kNavTextStyleSmall=TextStyle(
    color: Colors.white,
    fontSize: 9
);
const kHintStyle= TextStyle(
    color: Colors.grey
);

const linedBorder = UnderlineInputBorder(
  borderRadius: BorderRadius.all(
      Radius.circular(5)
  ),
  borderSide: BorderSide(color:Colors.yellow, width: 1.5),

);

const linedFocusedBorder = UnderlineInputBorder(
  borderRadius: BorderRadius.all(
      Radius.circular(5)
  ),
  borderSide: BorderSide(color:Colors.yellowAccent, width: 1),

);

const kIdKey='id';
const kMailKey='email';
const kPhoneKey='pno';
const kFnameKey='fname';
const kLnameKey='lname';
const kStateKey='state';
const kPasswordKey='password';
const kUploadedKey='uploaded';
const kResetKey='Reset';
const kAdressKey='address';
const kFavTeam='kFavTeam';
