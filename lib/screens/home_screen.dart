import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:sliit_info_ctse/screens/admin_screen.dart';
import 'package:sliit_info_ctse/widgets/events_Info_widget.dart';
import 'package:sliit_info_ctse/widgets/gradient_background.dart';
import 'package:sliit_info_ctse/widgets/news_Info_widget.dart';
import 'package:sliit_info_ctse/widgets/lecturer_info_widget.dart';

import '../model/user_model.dart';
import '../services/auth_service.dart';
import 'degrees_info.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPage = 0;
  PageController pageController = PageController();
  bool loading = true;

  //authservice
  final AuthService _auth = AuthService();
  user_model currentUser = user_model();

  @override
  void initState() {
    // init state
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .get()
        .then((val) {
      setState(() {
        currentUser = user_model.fromMap(val.data());
        loading = false;
        // if(currentUser.acc_type == 'Lecturer')Navigator.pushNamedAndRemoveUntil(context, '/admin', (route) => false);
      });
    }).onError((error, stackTrace){
      print(error);
      setState(() {
        loading = false;
      });
    });


  }

  List<_Photo> _photos(BuildContext context) {
    return [
      _Photo(
          assetName: 'assets/images/science.jpg',
          title: "SCIENCE",
          subtitle: "Exploring the wonders of the natural world",
          tileColor: 0xff0077be),
      _Photo(
          assetName: 'assets/images/engineering.jpg',
          title: "ENGINEERING",
          subtitle: "Innovating solutions to complex problems",
          tileColor: 0xff3d8b38),
      _Photo(
          assetName: 'assets/images/nursing.jpg',
          title: "NURSING",
          subtitle: "Caring for the health and well-being of others",
          tileColor: 0xffdb4545),
      _Photo(
          assetName: 'assets/images/arts&social.jpg',
          title: "ARTS & SOCIAL",
          subtitle: "Nurturing creativity and understanding in society",
          tileColor: 0xff7a4c8e),
      _Photo(
          assetName: 'assets/images/medicine.jpg',
          title: "MEDICINE",
          subtitle: "Advancing healthcare through research and practice",
          tileColor: 0xfff7941e),
      _Photo(
          assetName: 'assets/images/environment.jpg',
          title: "ENVIRONMENT",
          subtitle: "Protecting our planet for future generations",
          tileColor: 0xff009944),
      _Photo(
          assetName: 'assets/images/education.jpg',
          title: "EDUCATION",
          subtitle: "Empowering individuals through knowledge and learning",
          tileColor: 0xfff15a29),
    ];
  }

  adminRedirect(){
    if(loading){
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    else if(currentUser.acc_type == 'Lecturer'){
      return const AdminScreen();
    }else{
      return renderBody(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return adminRedirect();
  }

  Scaffold renderBody(BuildContext context) {
    return Scaffold(
    backgroundColor: Color.fromARGB(255, 11, 170, 82),
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        "KMMS University",
        style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.w600,
            fontSize: 25),
      ),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.logout_rounded,
            color: Color.fromARGB(255, 255, 255, 255),
            size: 35,
          ),
          onPressed: () {
            _auth.signOut();
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed Out Successfully')));
            Navigator.pushReplacementNamed(context, '/');
          },
          padding: const EdgeInsets.only(right: 10),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/userprofile');
          },
          child: Padding(
              padding: EdgeInsets.all(9.0),
              child: currentUser.imagePath != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(currentUser.imagePath!),
                    )
                  : const CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://firebasestorage.googleapis.com/v0/b/sliit-info-ctse.appspot.com/o/uploads%2Fimages.jpeg?alt=media&token=26ec85c5-b045-45da-8b57-05332a9b6665'),
                    )),
        ),
      ],
    ),
    body: GradientBackground(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color.fromARGB(255, 239, 240, 239).withOpacity(0.5)),
          child: PageView(
            controller: pageController,
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.count(
                    restorationId: 'grid_view_demo_grid_offset',
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    padding: const EdgeInsets.all(8),
                    childAspectRatio: 1,
                    children: _photos(context).map<Widget>((photo) {
                      return _GridDemoPhotoItem(
                        photo: photo,
                      );
                    }).toList(),
                  ),
                ),
              ),
              Column(
                children: const [
                  Padding(
                    padding: EdgeInsets.fromLTRB(1, 5, 1, 5),
                    child: Text(
                      'Events',
                      style: TextStyle(fontSize: 26),
                    ),
                  ),
                  Expanded(child: eventInfo()),
                ],
              ),
              Column(
                children: const [
                  Padding(
                    padding: EdgeInsets.fromLTRB(1, 5, 1, 5),
                    child: Text(
                      'News',
                      style: TextStyle(fontSize: 26),
                    ),
                  ),
                  Expanded(child: newsInfo()),
                ],
              ),
              Column(
                children: const [
                  Padding(
                    padding: EdgeInsets.fromLTRB(1, 5, 1, 5),
                    child: Text(
                      'Acedemic Staff',
                      style: TextStyle(fontSize: 26),
                    ),
                  ),
                  Expanded(child: lecturersInfo()),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    floatingActionButton: currentUser.acc_type == 'Admin'
        ? FloatingActionButton(
            onPressed: () {
              // print(currentUser.acc_type);
              Navigator.pushNamed(context, '/admin');
              // Add your onPressed code here!
            },
            backgroundColor: const Color(0xff002F66),
            child: const Icon(
              Icons.admin_panel_settings_sharp,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          )
        : currentUser.acc_type == 'Student'
            ? FloatingActionButton(
                onPressed: () {
                  // print(currentUser.acc_type);
                  Navigator.pushNamed(context, '/inquiries');
                  //  onPressed code here!
                },
                backgroundColor: const Color(0xff002F66),
                child: const Icon(
                  Icons.question_answer,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              )
            : null,
    bottomNavigationBar: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.graduationCap), label: 'Faculties'),
        BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.calendarDays), label: 'Events'),
        BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.newspaper), label: 'News'),
        BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.person), label: 'Staff'),
      ],
      currentIndex: _selectedPage,
      onTap: onTapped,
    ),
  );
  }

  void onTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 1000), curve: Curves.easeIn);
  }
}

class _Photo {
  _Photo({
    required this.assetName,
    required this.title,
    required this.subtitle,
    required this.tileColor,
  });

  final String assetName;
  final String title;
  final String subtitle;
  final int tileColor;
}

/// Allow the text size to shrink to fit in the space
class _GridTitleText extends StatelessWidget {
  const _GridTitleText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: AlignmentDirectional.centerStart,
      child: Text(text),
    );
  }
}

class _GridDemoPhotoItem extends StatelessWidget {
  const _GridDemoPhotoItem({
    Key? key,
    required this.photo,
  }) : super(key: key);

  final _Photo photo;

  @override
  Widget build(BuildContext context) {
    final Widget image = Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        photo.assetName,
        fit: BoxFit.cover,
      ),
    );

    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  degreeInfo(faculty: photo.title))),
      child: GridTile(
        footer: Material(
          color: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
          ),
          clipBehavior: Clip.antiAlias,
          child: GridTileBar(
            backgroundColor: Color(photo.tileColor),
            title: _GridTitleText(photo.title),
            subtitle: _GridTitleText(photo.subtitle),
          ),
        ),
        child: image,
      ),
    );
  }
}
