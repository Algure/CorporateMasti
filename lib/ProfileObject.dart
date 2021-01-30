class ProfileObject{
  String i;//customer id
  String e;//customer email
  String p;//customer phone number
  String a;//customer address
  String w;//wallet amount
  String f;//first name
  String l;//sur / last name
  String s;// profile pic url: to be downloaded in file

  toMap() {
    return {
      'i': i,
      'e':e,
      'p':p,
      'a':a,
      'w':w,
      'f':f,
      'l':l,
      's':s,
    };
  }//state

}