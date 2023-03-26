import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sliit_info_ctse/model/news_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sliit_info_ctse/widgets/gradient_background.dart';
import 'package:sliit_info_ctse/widgets/loggedAppBar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class add_News_screen extends StatefulWidget {
  const add_News_screen({Key? key}) : super(key: key);

  @override
  State<add_News_screen> createState() => _add_News_screenState();
}

class _add_News_screenState extends State<add_News_screen> {
  PlatformFile? pickedFile;
  late String uploadedImgUrl;

  // File Picker select image
  Future getImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  //upload to the firebase storage
  Future uploadFile() async {
    final path = 'uploads/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    UploadTask uploadTask = ref.putFile(file);

    String urlDownload = await (await uploadTask).ref.getDownloadURL();
    print('download url: $urlDownload');

    setState(() {
      uploadedImgUrl = urlDownload;
    });
  }

  //text editor controllers
  final title_editing_cntrlr = new TextEditingController();
  final desc_editing_cntrlr = new TextEditingController();

  //news form key
  final _news_formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //news title field
    final news_title_Field = TextFormField(
      autofocus: false,
      controller: title_editing_cntrlr,
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
        title_editing_cntrlr.text = val!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Padding(
            padding: EdgeInsets.all(9.0),
            child: FaIcon(FontAwesomeIcons.newspaper),
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "News Title",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //image picker button viewer
    final imagePickerButton = Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            RawMaterialButton(
              fillColor: Theme.of(context).colorScheme.secondary,
              child: const FaIcon(
                FontAwesomeIcons.fileImage,
                color: Colors.white,
              ),
              elevation: 2,
              onPressed: () {
                getImage();
              },
              padding: const EdgeInsets.all(15),
              shape: const CircleBorder(),
            ),
            if (pickedFile != null)
              Expanded(
                child: Container(
                  color: Colors.grey[50],
                  child: Center(
                    child: Expanded(
                      child: Image.file(
                        File(pickedFile!.path!),
                        width: 400,
                        // height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              )
          ],
        )
      ],
    );

    //description field
    final description_field = TextFormField(
      autofocus: false,
      controller: desc_editing_cntrlr,
      minLines: 1,
      maxLines: 6,
      keyboardType: TextInputType.multiline,
      //field validation
      validator: (val) {
        RegExp regex = new RegExp(r'^.{6,}$');
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
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Padding(
            padding: EdgeInsets.all(9.0),
            child: FaIcon(FontAwesomeIcons.pen),
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
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
            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            onPressed: () {
              submitData();
            },
            minWidth: MediaQuery.of(context).size.width,
            child: const Text(
              "Submit",
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
                        'Add a news',
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
                                  key: _news_formKey,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        imagePickerButton,
                                        const SizedBox(height: 30),
                                        news_title_Field,
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
    if (_news_formKey.currentState!.validate()) {
      await uploadFile().then((value) {
        saveDatatoFirestore();
      });
    }
  }

  saveDatatoFirestore() async {
    //initializinn firestore
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    news_model newsModel = news_model();

    //maping the values
    newsModel.title = title_editing_cntrlr.text;
    newsModel.description = desc_editing_cntrlr.text;
    newsModel.createdOn = DateTime.now();
    newsModel.image = uploadedImgUrl;

    await firebaseFirestore.collection('news').doc().set(newsModel.toMap());
    Fluttertoast.showToast(msg: "News added successfully");
    Navigator.pop(context);
  }
}
