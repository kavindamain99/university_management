import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sliit_info_ctse/model/user_model.dart';
import 'package:sliit_info_ctse/services/auth_service.dart';

//authservice
final AuthService _auth = AuthService();
user_model currentUser = user_model();

//firestore reference to get the the profile picture
@override
void initState() {
  FirebaseFirestore.instance
      .collection("users")
      .doc(_auth.currentUser!.uid)
      .get()
      .then((val) {
    currentUser = user_model.fromMap(val.data());
  });
}

AppBar buildLoggedAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: const Text(
      "KMMS University",
      style: TextStyle(
          color: Color(0xff002F66), fontWeight: FontWeight.w600, fontSize: 25),
    ),
    leading: Navigator.of(context).canPop() ? IconButton(
      icon:
          const Icon(Icons.arrow_back, color: Color.fromARGB(255, 2, 186, 70)),
      onPressed: () {
        Navigator.pop(context);
      },
    ): null,
    actions: [
      IconButton(
        icon: const Icon(
          Icons.logout_rounded,
          color: Color.fromARGB(255, 2, 186, 70),
          size: 35,
        ),
        onPressed: () {
          _auth.signOut();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Signed Out Successfully')));
          Navigator.pushReplacementNamed(context, '/');
        },
        padding: const EdgeInsets.only(right: 10),
      ),
      GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/userprofile');
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://firebasestorage.googleapis.com/v0/b/sliit-info-ctse.appspot.com/o/uploads%2Fimages.jpeg?alt=media&token=26ec85c5-b045-45da-8b57-05332a9b6665'),
            ),
          )),
    ],
  );
}
