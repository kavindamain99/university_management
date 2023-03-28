import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class degreeCard extends StatelessWidget {
  final String name;
  final String description;
  final String duration;
  final String entry_req;
  final String faculty;

  const degreeCard(
      {Key? key,
      required this.name,
      required this.description,
      required this.duration,
      required this.entry_req,
      required this.faculty})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        color: const Color.fromARGB(255, 240, 239, 239).withOpacity(0.7),
        shape: RoundedRectangleBorder(
            // side: const BorderSide(color:  width: 2),
            borderRadius: BorderRadius.circular(5)),
        margin: const EdgeInsets.fromLTRB(12, 15, 12, 12),
        elevation: 5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const FaIcon(
                FontAwesomeIcons.graduationCap,
                color: Color(0xff002F66),
                size: 55,
              ),
              title: Text(
                'Degree: ' + name,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
              ),
              subtitle: Text(
                'Duration: ' + duration + ' Years',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 5),
                const Text(
                  'About',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    description,
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Entry Requirements',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    entry_req,
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      );
}
