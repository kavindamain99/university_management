import 'dart:ui';
import 'package:flutter/material.dart';

class eventCard extends StatelessWidget {
  final String event_name;
  final String description;
  final String date_time;
  final String venue;
  final String image_path;

  const eventCard(
      {Key? key,
      required this.event_name,
      required this.description,
      required this.date_time,
      required this.venue,
      required this.image_path})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        color: const Color.fromARGB(255, 240, 239, 239).withOpacity(0.5),
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(5)),
        margin: const EdgeInsets.fromLTRB(12, 15, 12, 12),
        elevation: 5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(
                'Event: ' + event_name,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
              ),
              subtitle: Text(
                'On : ' + date_time + '  At : ' + venue,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 4, // 40%
                  child: Container(
                    color: Colors.grey[50],
                    child: Center(
                      child: Expanded(
                        child: Image.network(
                          image_path,
                          width: 300,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6, // 60%
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 2),
                      const Text(
                        'About',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
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
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      );
}
