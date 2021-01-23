class TeamData{
  String i;//item id
  String e;//item data
  String t;//team id

  TeamData.withDetails(this.i, this.e, this.t);

  Map<String, String> toMap(){
    return {
      'i':i,
      'e':e,
      't':t
    };
  }

  TeamData.fromFirebase({var map, String teamId, String itemId}) {
    this.i=itemId;
    this.e=map.toString();
    this.t= teamId;
  }

  TeamData.fromMap(var map) {
    this.i=map['i'];
    this.e=map['e'];
    this.t= map['t'];
  }
}