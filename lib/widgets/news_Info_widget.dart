import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sliit_info_ctse/widgets/newsCard.dart';

class newsInfo extends StatefulWidget {

  const newsInfo({Key? key,}) : super(key: key);

  @override
  State<newsInfo> createState() => _newsInfoState();
}

class _newsInfoState extends State<newsInfo> {
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        const SizedBox(height: 20,),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('news').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot = snapshot
                            .data!.docs[index];

                        //converting timestamp to string
                        Timestamp timeFrmServer = documentSnapshot['createdOn'];
                        DateTime datetimeConverted = timeFrmServer.toDate();
                        var formattedTime = DateFormat.yMMMd().add_jm().format(datetimeConverted);

                        return newsCard(
                          image: documentSnapshot['image'],
                          title: documentSnapshot['title'],
                          createdOn: formattedTime.toString(),
                          description: documentSnapshot['description'],
                        );
                      });
                } else if (snapshot.hasError) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Server Error')));
                }

                return const Center(child: CircularProgressIndicator());
              }
          ),
        )
      ],
    );
  }
}
