import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sliit_info_ctse/widgets/eventCard.dart';

class eventInfo extends StatefulWidget {

  const eventInfo({Key? key,}) : super(key: key);

  @override
  State<eventInfo> createState() => _eventInfoState();
}

class _eventInfoState extends State<eventInfo> {
  @override
  Widget build(BuildContext context) {
    return  Column(
        children: [
          const SizedBox(height: 20,),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('events').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot documentSnapshot = snapshot
                              .data!.docs[index];
                          return eventCard(
                            image_path: documentSnapshot['image_path'],
                            date_time: documentSnapshot['date_time'],
                            venue: documentSnapshot['venue'],
                            event_name: documentSnapshot['event_name'],
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
