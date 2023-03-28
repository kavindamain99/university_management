import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sliit_info_ctse/widgets/gradient_background.dart';
import '../widgets/loggedAppBar.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<String> configs = [
    "Degree Info Configuration",
    "Event Info Configuration",
    "News Info Configuration",
    "Staff Configuration",
    "Student Configuration",
    "Inquary Configuration",
  ];

  List<String> configsLinks = [
    '/degreeList',
    '/eventList',
    '/newsList',
    '/staffList',
    '/studentList',
    '/inquaryAdminList',
  ];

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
                  color: const Color.fromARGB(255, 240, 239, 239)
                      .withOpacity(0.5)),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(1, 5, 1, 5),
                    child: Text(
                      'Admin Configurations',
                      style: TextStyle(fontSize: 26),
                    ),
                  ),
                  ListView.builder(
                    itemBuilder: (BuildContext context, index) {
                      return Card(
                        color: const Color.fromARGB(255, 240, 239, 239)
                            .withOpacity(0.7),
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5)),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xff002F66),
                            child: IconButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.gear,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, configsLinks[index]);
                              },
                            ),
                          ),
                          title: Text(configs[index]),
                          onTap: () {
                            Navigator.pushNamed(context, configsLinks[index]);
                          },
                        ),
                      );
                    },
                    itemCount: configs.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(5),
                    scrollDirection: Axis.vertical,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
