import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sliit_info_ctse/services/auth_service.dart';
import 'package:sliit_info_ctse/widgets/gradient_background.dart';
import 'package:sliit_info_ctse/widgets/loggedAppBar.dart';

import '../model/inquiry_model.dart';

class add_InquiryScreen extends StatefulWidget {
  const add_InquiryScreen({Key? key}) : super(key: key);

  @override
  State<add_InquiryScreen> createState() => _add_InquiryScreenState();
}

class _add_InquiryScreenState extends State<add_InquiryScreen> {
  final AuthService _authService = AuthService();

  //text editor controllers
  final name_editing_cntrlr = TextEditingController();
  final contactNo_editing_cntrlr = TextEditingController();
  final inquiry_editing_cntrlr = TextEditingController();

  // form key
  final _inquiry_formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //Degree title field
    final studentName_Field = TextFormField(
      autofocus: false,
      controller: name_editing_cntrlr,
      keyboardType: TextInputType.text,
      //field validation
      validator: (val) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (val!.isEmpty) {
          return ("field cannot be empty");
        }
        if (!regex.hasMatch(val)) {
          return ("minimum length is 3 characters");
        }
        return null;
      },
      onSaved: (val) {
        name_editing_cntrlr.text = val!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Padding(
            padding: EdgeInsets.all(9.0),
            child: FaIcon(FontAwesomeIcons.person),
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Your Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //entry requirement field
    final contactNo_field = TextFormField(
      autofocus: false,
      controller: contactNo_editing_cntrlr,
      keyboardType: TextInputType.phone,
      //field validation
      validator: (val) {
        if (val!.isEmpty) {
          return ("field cannot be empty");
        }
        return null;
      },
      onSaved: (val) {
        contactNo_editing_cntrlr.text = val!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Padding(
            padding: EdgeInsets.all(9.0),
            child: FaIcon(FontAwesomeIcons.phone),
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Contact Number",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //description field
    final inquiryDesc_field = TextFormField(
      autofocus: false,
      controller: inquiry_editing_cntrlr,
      minLines: 1,
      maxLines: 6,
      keyboardType: TextInputType.multiline,
      //field validation
      validator: (val) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (val!.isEmpty) {
          return ("field cannot be empty");
        }
        if (!regex.hasMatch(val)) {
          return ("minimum length is 6 characters");
        }
        return null;
      },
      onSaved: (val) {
        inquiry_editing_cntrlr.text = val!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: const Padding(
            padding: EdgeInsets.all(9.0),
            child: FaIcon(FontAwesomeIcons.pen),
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Please type your enquiry here",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //submit button
    final submitBtn = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(25),
        color: Colors.orange,
        child: MaterialButton(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            onPressed: () {
              submitData();
            },
            minWidth: MediaQuery.of(context).size.width,
            child: const Text(
              "Submit Inquiry",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )));

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: buildLoggedAppBar(context),
        body: GradientBackground(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(255, 240, 239, 239)
                        .withOpacity(0.5)),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(1, 5, 1, 5),
                      child: Text(
                        'Add a enquiry',
                        style: TextStyle(fontSize: 26),
                      ),
                    ),
                    Center(
                      child: SingleChildScrollView(
                          child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: const Color.fromARGB(255, 240, 239, 239)
                                    .withOpacity(0.7)),
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Form(
                                  key: _inquiry_formKey,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        studentName_Field,
                                        const SizedBox(height: 20),
                                        contactNo_field,
                                        const SizedBox(height: 20),
                                        inquiryDesc_field,
                                        const SizedBox(height: 40),
                                        submitBtn,
                                      ])),
                            )),
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  //functions
  void submitData() async {
    if (_inquiry_formKey.currentState!.validate()) {
      saveDatatoFirestore();
    }
  }

  saveDatatoFirestore() async {
    //initializinn firestore
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    inquiry_model inquiryModel = inquiry_model();

    //maping the values
    inquiryModel.name = name_editing_cntrlr.text;
    inquiryModel.email = _authService.currentUser?.email;
    inquiryModel.contactNo = contactNo_editing_cntrlr.text;
    inquiryModel.inquiryDesc = inquiry_editing_cntrlr.text;
    inquiryModel.createdBy = _authService.currentUser?.uid.toString();

    await firebaseFirestore
        .collection('inquiries')
        .doc()
        .set(inquiryModel.toMap());
    Fluttertoast.showToast(msg: "Inquiry submitted successfully");
    Navigator.pop(context);
  }
}
