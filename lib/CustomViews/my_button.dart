import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  MyButton({this.buttonColor, @required this.text, this.textColor, @required this.onPressed});
  Color buttonColor;
  String text;
  Function onPressed;
  Color textColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: buttonColor??Colors.black,
          borderRadius: BorderRadius.circular(5)
      ),
      child: FlatButton(onPressed:onPressed,
        child: Text(text, style: TextStyle(color: textColor??Colors.white),),
        splashColor: Colors.white,),
    );
  }
}
