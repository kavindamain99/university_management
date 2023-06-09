import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sliit_info_ctse/model/user_model.dart';
import 'package:sliit_info_ctse/widgets/appbar_widget.dart';
import 'package:sliit_info_ctse/widgets/button_widget.dart';
import 'package:sliit_info_ctse/widgets/gradient_background.dart';
import 'package:sliit_info_ctse/widgets/profile_widget.dart';

import '../services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //text editor controllers
  final email_editing_cntrlr = TextEditingController();
  final password_editing_cntrlr = TextEditingController();

  //firebase user authneication state
  final AuthService _auth = AuthService();
  user_model currentUser = user_model();

  //collection reference
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .get()
        .then((val) {
      setState(() {
        currentUser = user_model.fromMap(val.data());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GradientBackground(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromARGB(255, 240, 239, 239)
                      .withOpacity(0.5)),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  ProfileWidget(
                    imagePath: "${currentUser.imagePath}",
                    onClicked: () {
                      Navigator.pushNamed(context, '/edit_profile');
                    },
                  ),
                  const SizedBox(height: 24),
                  buildName(currentUser),
                  const SizedBox(height: 48),
                  buildAbout(currentUser),
                  const SizedBox(height: 54),
                  Center(child: accDeleteButton()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildName(user_model user) => Column(
        children: [
          Text(
            "${user.f_name} ${user.l_name}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            "${user.email}",
            style: TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget accDeleteButton() => ButtonWidget(
        text: 'Delete My Account',
        onClicked: () {
          _deleteAcc();
        },
      );

  Widget buildAbout(user_model user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'First Name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "${user.f_name}",
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 20),
            const Text(
              'Last Name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "${user.l_name}",
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 20),
            const Text(
              'Account Type',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "${user.acc_type}",
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );

  // //delete function
  // Future<void> _deleteUserAcc(String userId) async {
  //   await _users.doc(userId).delete();
  //
  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text('Account deleted!')));
  // }
  //
  // Future<void> _deleteAcc() async{
  //
  //   final String userId = _auth.currentUser!.uid;
  //   try {
  //     await _auth.currentUser!.delete();
  //     Navigator.of(context).pushNamed('/');
  //     await _deleteUserAcc(userId);
  //
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'requires-recent-login') {
  //       print('The user must reauthenticate before this operation can be executed.');
  //     }
  //   }
  // }

  Future<void> _deleteAcc() async {
    if (_auth.currentUser != null) {
      await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return Padding(
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
                    controller: email_editing_cntrlr,
                    decoration: const InputDecoration(
                      labelText: 'Username/Email',
                    ),
                  ),
                  TextField(
                    controller: password_editing_cntrlr,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: const Text('Confirm Delete'),
                    onPressed: () async {
                      final String? email = email_editing_cntrlr.text;
                      final String? password = password_editing_cntrlr.text;

                      if (email != null && password != null) {
                        await AuthService().deleteUser(email, password);
                        email_editing_cntrlr.text = '';
                        password_editing_cntrlr.text = '';
                        Navigator.of(context).pushNamed('/');
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Account Deleted Successfully')));
                      }
                    },
                  )
                ],
              ),
            );
          });
    }
  }
}
