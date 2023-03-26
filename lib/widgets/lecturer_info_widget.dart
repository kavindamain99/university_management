import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sliit_info_ctse/widgets/lecturer_card.dart';

class lecturersInfo extends StatefulWidget {
  const lecturersInfo({
    Key? key,
  }) : super(key: key);

  @override
  State<lecturersInfo> createState() => _lecturersInfoState();
}

class _lecturersInfoState extends State<lecturersInfo> {
  final CollectionReference _lecturers =
  FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
              stream: _lecturers
                  .where('acc_type', isEqualTo: 'Lecturer')
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                        snapshot.data!.docs[index];
                        return lecturerCard(
                          image_path: documentSnapshot['imagePath'],
                          l_name: documentSnapshot['l_name'],
                          f_name: documentSnapshot['f_name'],
                          email: documentSnapshot['email'],
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
    );
  }
}