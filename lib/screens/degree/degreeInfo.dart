import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sliit_info_ctse/widgets/gradient_background.dart';
import 'package:sliit_info_ctse/widgets/loggedAppBar.dart';
import 'package:sliit_info_ctse/widgets/degreeCard.dart';

class degreeInfo extends StatefulWidget {
  //faculty attribute
  final String faculty;

  const degreeInfo({Key? key, required this.faculty}) : super(key: key);

  @override
  State<degreeInfo> createState() => _degreeInfoState();
}

class _degreeInfoState extends State<degreeInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildLoggedAppBar(context),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color.fromARGB(255, 239, 240, 239).withOpacity(0.5)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(1, 5, 1, 5),
                  child: Text(
                    'FACULTY OF ' + widget.faculty,
                    style: const TextStyle(fontSize: 26),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('degrees')
                          .where('faculty', isEqualTo: widget.faculty)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        // if(snapshot.connectionState == ConnectionState.waiting){
                        //   return const Center(child: CircularProgressIndicator());
                        // }
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                final DocumentSnapshot documentSnapshot =
                                    snapshot.data!.docs[index];
                                return degreeCard(
                                  name: documentSnapshot['name'],
                                  entry_req: documentSnapshot['entry_req'],
                                  description: documentSnapshot['description'],
                                  duration: documentSnapshot['duration'],
                                  faculty: widget.faculty,
                                );
                              });
                        } else if (snapshot.hasError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Server Error')));
                        }

                        return const Center(child: CircularProgressIndicator());
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //will be use later to display alert dialog box if there are no data
  showAlertDialog(BuildContext context) {
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Simple Alert"),
      content: Text("This is an alert message."),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
