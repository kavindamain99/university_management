import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sliit_info_ctse/widgets/button_widget.dart';
import 'package:sliit_info_ctse/model/user_model.dart';
import 'package:sliit_info_ctse/widgets/appbar_widget.dart';
import 'package:sliit_info_ctse/widgets/gradient_background.dart';
import 'package:sliit_info_ctse/widgets/profile_widget.dart';
import 'package:sliit_info_ctse/widgets/textfield_widget.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  //firebase user authneication state
  User? user = FirebaseAuth.instance.currentUser;
  user_model currentUser = user_model();

  //collection reference
  final CollectionReference _users =
  FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _users.doc(user!.uid).get().then(
            (val){
          setState(() {
            currentUser = user_model.fromMap(val.data());
          });
        }
    );
  }


  //text editor controllers
  final f_name_editing_cntrlr = TextEditingController();
  final l_name_editing_cntrlr = TextEditingController();
  final email_editing_cntrlr = TextEditingController();



  @override
  Widget build(BuildContext context) {

    f_name_editing_cntrlr.text = currentUser.f_name.toString();
    l_name_editing_cntrlr.text = currentUser.l_name.toString();
    email_editing_cntrlr.text = currentUser.email.toString();

    return Scaffold(
      appBar: buildAppBar(context),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color:
                    const Color.fromARGB(255, 240, 239, 239).withOpacity(0.5)),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              physics: const BouncingScrollPhysics(),
              children: [
                ProfileWidget(
                  imagePath: "${currentUser.imagePath}",
                  isEdit: true,
                  onClicked: () async {},
                ),
                const SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller:  f_name_editing_cntrlr,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                    ),
                  ),
                  TextField(
                    controller: l_name_editing_cntrlr,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                    ),
                  ),
                  TextField(
                    controller: email_editing_cntrlr,
                    decoration: const InputDecoration(labelText: 'Email / Username'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: const Text('Update'),
                    onPressed: () async {
                      final String? f_name = f_name_editing_cntrlr.text;
                      final String? l_name = l_name_editing_cntrlr.text;
                      final String? email = email_editing_cntrlr.text;

                      if (f_name != null) {

                          print('Fname : $f_name');
                          print('Lname : $l_name');
                          print('Email : $email');
                          print('UID: ${currentUser.uid}');
                          await _users.doc(currentUser.uid).update({
                            "f_name" : f_name,
                            "l_name" : l_name,
                            "email" : email,
                          });

                          f_name_editing_cntrlr.text = '';
                          l_name_editing_cntrlr.text = '';
                          email_editing_cntrlr.text = '';

                        // Navigator.of(context).pop();
                        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        //     content: Text('Updated Successfully')));
                      }
                    },
                  )
                ],
              ),
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }



}