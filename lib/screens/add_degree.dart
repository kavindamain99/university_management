import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sliit_info_ctse/model/degree_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sliit_info_ctse/widgets/gradient_background.dart';
import 'package:sliit_info_ctse/widgets/loggedAppBar.dart';

class add_Degree_screen extends StatefulWidget {
  const add_Degree_screen({Key? key}) : super(key: key);

  @override
  State<add_Degree_screen> createState() => _add_Degree_screenState();
}

class _add_Degree_screenState extends State<add_Degree_screen> {
  //account types
  final faculties = [
    'SCIENCE',
    'ENVIRONMENT',
    'NURSING',
    'OCEAN TECH',
    'EDUCATION',
    'ARTS AND SOCIAL',
    'MEDICINE'
  ];

  //text editor controllers
  final degree_name = TextEditingController();
  final entry_req = TextEditingController();
  final duration_editing_cntrlr = TextEditingController();
  final desc_editing_cntrlr = TextEditingController();

  //faculty type
  String? faculty;

  //signup form key
  final _degree_formKey = GlobalKey<FormState>();

  //menu item
  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontSize: 16),
        ),
      );

  @override
  Widget build(BuildContext context) {
    //Degree title field
    final degree_titlt_Field = TextFormField(
      autofocus: false,
      controller: degree_name,
      keyboardType: TextInputType.text,
      //field validation
      validator: (val) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if (val!.isEmpty) {
          return ("field cannot be empty");
        }
        if (!regex.hasMatch(val)) {
          return ("minimum length is 3 characters");
        }
        return null;
      },
      onSaved: (val) {
        degree_name.text = val!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Padding(
            padding: EdgeInsets.all(9.0),
            child: FaIcon(FontAwesomeIcons.graduationCap),
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Degree Titile",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //entry requirement field
    final entry_req_field = TextFormField(
      autofocus: false,
      controller: entry_req_editing_cntrlr,
      minLines: 1,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      //field validation
      validator: (val) {
        if (val!.isEmpty) {
          return ("field cannot be empty");
        }
        return null;
      },
      onSaved: (val) {
        entry_req_editing_cntrlr.text = val!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Padding(
            padding: EdgeInsets.all(9.0),
            child: FaIcon(FontAwesomeIcons.certificate),
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Entry Requirements",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //Faculty field
    final faculty_TypeField = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 0.8),
      ),
      padding: const EdgeInsets.fromLTRB(20, 1, 20, 1),
      child: DropdownButtonFormField<String>(
        value: faculty,
        isExpanded: true,
        hint: const Text('Select Faculty'),
        items: faculties.map(buildMenuItem).toList(),
        onChanged: (value) => setState(() => faculty = value),
      ),
    );

    //duration field
    final duration_field = TextFormField(
      autofocus: false,
      controller: duration_editing_cntrlr,
      keyboardType: TextInputType.text,
      //duration field validation
      validator: (val) {
        if (val!.isEmpty) {
          return ("field cannot be empty");
        }
        return null;
      },
      onSaved: (val) {
        duration_editing_cntrlr.text = val!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Padding(
            padding: EdgeInsets.all(9.0),
            child: FaIcon(FontAwesomeIcons.clock),
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Duration",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //description field
    final description_field = TextFormField(
      autofocus: false,
      controller: desc_editing_cntrlr,
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
        desc_editing_cntrlr.text = val!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: const Padding(
            padding: EdgeInsets.all(9.0),
            child: FaIcon(FontAwesomeIcons.pen),
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Description",
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
              "Add Degree",
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
                        'Add a Degree',
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
                            // color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Form(
                                  key: _degree_formKey,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        const SizedBox(height: 50),
                                        degree_titlt_Field,
                                        const SizedBox(height: 20),
                                        entry_req_field,
                                        const SizedBox(height: 20),
                                        faculty_TypeField,
                                        const SizedBox(height: 20),
                                        duration_field,
                                        const SizedBox(height: 20),
                                        description_field,
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
    if (_degree_formKey.currentState!.validate()) {
      saveDatatoFirestore();
    }
  }

  saveDatatoFirestore() async {
    //initializinn firestore
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    degree_model degreeModel = degree_model();

    //maping the values
    degreeModel.name = degree_name.text;
    degreeModel.entry_req = entry_req_editing_cntrlr.text;
    degreeModel.duration = duration_editing_cntrlr.text;
    degreeModel.description = desc_editing_cntrlr.text;
    degreeModel.faculty = faculty;

    await firebaseFirestore
        .collection('degrees')
        .doc()
        .set(degreeModel.toMap());
    Fluttertoast.showToast(msg: "Data added successfully");
    Navigator.pop(context);
  }
}
