import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sliit_info_ctse/widgets/gradient_background.dart';
import '../widgets/loggedAppBar.dart';

class InquaryAdmin extends StatefulWidget {
  const InquaryAdmin({Key? key}) : super(key: key);

  @override
  State<InquaryAdmin> createState() => _InquaryAdminState();
}

class _InquaryAdminState extends State<InquaryAdmin> {
  //collection reference
  final CollectionReference _inquiries =
      FirebaseFirestore.instance.collection('inquiries');

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
                color:
                    const Color.fromARGB(255, 240, 239, 239).withOpacity(0.5)),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(1, 5, 1, 5),
                  child: Text(
                    'Inquaries',
                    style: TextStyle(fontSize: 26),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _inquiries.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot documentSnapshot =
                                  snapshot.data!.docs[index];
                              return Card(
                                color: const Color.fromARGB(255, 240, 239, 239)
                                    .withOpacity(0.7),
                                shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(5)),
                                margin: const EdgeInsets.all(10),
                                child: ListTile(
                                  // tileColor: Colors.white70,
                                  title: Text(
                                    'Enquiry No: ${index + 1}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle:
                                      Text(documentSnapshot['inquiryDesc']),
                                  // leading: CircleAvatar(
                                  //     backgroundImage: NetworkImage(
                                  //         '${documentSnapshot['imagePath']}')),
                                  trailing: SizedBox(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              _deleteInquary(
                                                  documentSnapshot.id);
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //delete function
  Future<void> _deleteInquary(String userId) async {
    await _inquiries.doc(userId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User has been deleted successfully!')));
  }
}
