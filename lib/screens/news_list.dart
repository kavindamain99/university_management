import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sliit_info_ctse/widgets/gradient_background.dart';
import 'package:sliit_info_ctse/widgets/loggedAppBar.dart';

class newsList extends StatefulWidget {
  const newsList({Key? key}) : super(key: key);

  @override
  State<newsList> createState() => _newsListState();
}

class _newsListState extends State<newsList> {
  //collection reference
  final CollectionReference _news =
      FirebaseFirestore.instance.collection('news');

  //text editor controllers
  final title_editing_cntrlr = TextEditingController();
  final desc_editing_cntrlr = TextEditingController();

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
                    'Available News',
                    style: TextStyle(fontSize: 26),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: _news.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot documentSnapshot =
                                  snapshot.data!.docs[index];

                              //converting timestamp to string
                              Timestamp timeFrmServer =
                                  documentSnapshot['createdOn'];
                              DateTime datetimeConverted =
                                  timeFrmServer.toDate();
                              var formattedTime = DateFormat.yMMMd()
                                  .add_jm()
                                  .format(datetimeConverted);

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
                                    documentSnapshot['title'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                      'Created on ' + formattedTime.toString()),
                                  leading: const CircleAvatar(
                                      child: FaIcon(
                                    FontAwesomeIcons.newspaper,
                                    color: Colors.white,
                                  )),
                                  trailing: SizedBox(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Color.fromARGB(
                                                  255, 22, 63, 24),
                                            ),
                                            onPressed: () {
                                              _updateNews(documentSnapshot);
                                            }),
                                        IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              _deleteNews(documentSnapshot.id);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // print(currentUser.acc_type);
          Navigator.pushNamed(context, '/add_news');
          // Add your onPressed code here!
        },
        backgroundColor: const Color(0xff002F66),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  //delete function
  Future<void> _deleteNews(String newsID) async {
    await _news.doc(newsID).delete();

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have successfully deleted a news')));
  }

  //update function
  Future<void> _updateNews([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      title_editing_cntrlr.text = documentSnapshot['title'].toString();
      desc_editing_cntrlr.text = documentSnapshot['description'].toString();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: title_editing_cntrlr,
                  decoration: const InputDecoration(
                    labelText: 'Degree Name',
                  ),
                ),
                TextField(
                  controller: desc_editing_cntrlr,
                  minLines: 1,
                  maxLines: 8,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String? newsTitle = title_editing_cntrlr.text;
                    final String? descriptionNews = desc_editing_cntrlr.text;

                    if (newsTitle != null) {
                      if (action == 'update') {
                        await _news.doc(documentSnapshot!.id).update({
                          "title": newsTitle,
                          "description": descriptionNews,
                        });
                      }

                      title_editing_cntrlr.text = '';
                      desc_editing_cntrlr.text = '';

                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Updated Successfully')));
                    }
                  },
                )
              ],
            ),
          );
        });
  }
}
