class inquiry_model{

  //attributes
  String? name;
  String? email;
  String? contactNo;
  String? inquiryDesc;
  String? createdBy;


  inquiry_model({
    this.name,
    this.email,
    this.contactNo,
    this.inquiryDesc,
    this.createdBy,

  });

  //send data to the cloud firestore
  Map<String, dynamic> toMap(){
    return{
      'name': name,
      'email': email,
      'contactNo': contactNo,
      'inquiryDesc': inquiryDesc,
      'createdBy': createdBy,

    };
  }

  //retrieve data from the server
  inquiry_model.fromSnapshot(snapshot):
        name = snapshot.data()['name'],
        email = snapshot.data()['email'],
        contactNo = snapshot.data()['contactNo'],
        inquiryDesc = snapshot.data()['inquiryDesc'],
        createdBy = snapshot.data()['createdBy'];

}