class degree_model{

  //attributes
  String? name;
  String? faculty;
  String? entry_req;
  String? duration;
  String? description;

  degree_model({
    this.name,
    this.faculty,
    this.entry_req,
    this.duration,
    this.description,
});

  //send data to the cloud firestore
Map<String, dynamic> toMap(){
  return{
    'name': name,
    'faculty': faculty,
    'entry_req': entry_req,
    'duration': duration,
    'description': description,
  };
 }

 //retrieve data from the server
degree_model.fromSnapshot(snapshot):
      name = snapshot.data()['name'],
      faculty = snapshot.data()['faculty'],
      entry_req = snapshot.data()['entry_req'],
      duration = snapshot.data()['duration'],
      description = snapshot.data()['description'];

}