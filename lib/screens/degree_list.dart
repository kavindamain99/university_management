import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sliit_info_ctse/widgets/gradient_background.dart';
import '../widgets/loggedAppBar.dart';

class degreeList extends StatefulWidget {
  const degreeList({Key? key}) : super(key: key);

  @override
  State<degreeList> createState() => _degreeListState();
}

class _degreeListState extends State<degreeList> {
  //collection reference
  final CollectionReference _degrees =
      FirebaseFirestore.instance.collection('degrees');

  //text editor controllers
  final deg_name_editing_cntrlr = TextEditingController();
  final entry_req_editing_cntrlr = TextEditingController();
  final duration_editing_cntrlr = TextEditingController();
  final desc_editing_cntrlr = TextEditingController();

  //account types
  final faculties = [
    'SCIENCE',
    'ENVIRONMENT',
    'NURSING',
    'OCEAN TECH',
    'EDUCATION',
    'ARTS & SOCIAL',
    'MEDICINE'
  ];

  //faculty type
  String? faculty;

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
                    'Available Degrees',
                    style: TextStyle(fontSize: 26),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: _degrees.snapshots(),
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
                                    documentSnapshot['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(documentSnapshot['faculty']),
                                  leading: const CircleAvatar(
                                      backgroundImage: AssetImage(
                                          'assets/images/degree_icon.png')),
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
                                              _updateDegree(documentSnapshot);
                                            }),
                                        IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              _deleteDegree(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // print(currentUser.acc_type);
          Navigator.pushNamed(context, '/add_degree');
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
  Future<void> _deleteDegree(String degreeId) async {
    await _degrees.doc(degreeId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a Degree')));
  }

  //update function
  Future<void> _updateDegree([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      deg_name_editing_cntrlr.text = documentSnapshot['name'].toString();
      entry_req_editing_cntrlr.text = documentSnapshot['entry_req'].toString();
      duration_editing_cntrlr.text = documentSnapshot['duration'].toString();
      desc_editing_cntrlr.text = documentSnapshot['description'].toString();
      faculty = documentSnapshot['faculty'].toString();
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
                  controller: deg_name_editing_cntrlr,
                  decoration: const InputDecoration(
                    labelText: 'Degree Name',
                  ),
                ),
                TextField(
                  controller: duration_editing_cntrlr,
                  decoration: const InputDecoration(
                    labelText: 'Degree Duration',
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: faculty,
                  isExpanded: true,
                  items: faculties.map(buildMenuItem).toList(),
                  onChanged: (value) => setState(() => faculty = value),
                ),
                TextField(
                  controller: entry_req_editing_cntrlr,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 8,
                  decoration:
                      const InputDecoration(labelText: 'Entry requirements'),
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
                    final String? degreeName = deg_name_editing_cntrlr.text;
                    final String? entryReq = entry_req_editing_cntrlr.text;
                    final String? durationDeg = duration_editing_cntrlr.text;
                    final String? facultyDeg = faculty;
                    final String? descriptionDeg = desc_editing_cntrlr.text;

                    if (degreeName != null) {
                      if (action == 'update') {
                        await _degrees.doc(documentSnapshot!.id).update({
                          "name": degreeName,
                          "entry_req": entryReq,
                          "duration": durationDeg,
                          "description": descriptionDeg,
                          "faculty": facultyDeg
                        });
                      }

                      deg_name_editing_cntrlr.text = '';
                      entry_req_editing_cntrlr.text = '';
                      duration_editing_cntrlr.text = '';
                      desc_editing_cntrlr.text = '';

                      setState(() {
                        faculty = '';
                      });

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

  //menu item
  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontSize: 16),
        ),
      );
}
