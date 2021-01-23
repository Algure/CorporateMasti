class EventsObject{

  String imageUrl;
  String title;
  String value;
  String widgetType;
  String clickLink;

  EventsObject({this.title,this.value, this.imageUrl, this.widgetType, this.clickLink});

  EventsObject.fromString(String data){
    List<String> sList=data.split("<");
    widgetType=sList[0];
    title=sList[1];
    value=sList[2];
    imageUrl=sList[3];
    clickLink=sList[4];
  }

  @override
  String toString() {
    return("${widgetType}<${title}<${value}<${imageUrl}<${clickLink}");
  }



}