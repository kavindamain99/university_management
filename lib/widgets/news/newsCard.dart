import 'package:flutter/material.dart';

class newsCard extends StatelessWidget {
  final String title;
  final String description;
  final String createdOn;
  final String image;

  const newsCard(
      {Key? key,
      required this.title,
      required this.description,
      required this.createdOn,
      required this.image})
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
                'News: ' + title,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
              ),
              subtitle: Text(
                'Posted On : ' + createdOn,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Container(
                    color: Colors.grey[50],
                    child: Center(
                      child: Expanded(
                        child: Image.network(
                          image,
                          width: 300,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 5),
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
            ),
          ],
        ),
      );
}
