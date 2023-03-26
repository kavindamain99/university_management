class news_model{
  //attributes
  String? title;
  String? image;
  String? description;
  DateTime? createdOn;


  //constructor
news_model({
    this.title,
    this.image,
    this.description,
    this.createdOn,
});

//send data to the cloud firestore
Map<String, dynamic> toMap(){
  return{
    'title' : title,
    'image' : image,
    'description' : description,
    'createdOn' : createdOn,
  };
}
}