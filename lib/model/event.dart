class event_model{

  //attributes
  String? event_name;
  String? venue;
  String? image_path;
  String? date_time;
  String? description;

  event_model({
    this.event_name,
    this.venue,
    this.image_path,
    this.date_time,
    this.description,
  });

  //send data to the cloud firestore
  Map<String, dynamic> toMap(){
    return{
      'event_name': event_name,
      'venue': venue,
      'image_path': image_path,
      'date_time': date_time,
      'description': description,
    };
  }
}