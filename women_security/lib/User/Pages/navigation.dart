import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../Utils/shared_preferences.dart';
import '../Utils/text_data.dart';
import 'Navigation Pages/complaint_page.dart';
import 'Navigation Pages/home_page.dart';
import 'Navigation Pages/me_page.dart';
import 'Navigation Pages/preferences.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int index = 0;
  int pageIndex = 0;

  getPref()async{
    List<String>? keys = SharedPrefs.getKeys();
    keys != null?TextData.addedPreferences = await SharedPrefs.getPreferences(keys):null;
  }
  @override
  void initState() {
    getPref();
    super.initState();
  }

  List<Widget> pages = [
    const HomePage(),
    const ComplaintPage(),
    const Preferences(),
    const MePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        items: const [
          Icon(Icons.home_outlined),
          Icon(Icons.note_add_sharp),
          Icon(Icons.change_circle),
          Icon(Icons.person)
        ],
        backgroundColor: const Color(0xffF9F2FF),
        onTap: (index) {
          setState(() {
            pageIndex = index;
          });
        },
      ),
      body: pages[pageIndex],
    );
  }
}


// bottomNavigationBar:  GNav(
//   onTabChange: (index){
//     liquidController.animateToPage(page: index, duration: 200);
//   },
//   tabBorderRadius: 20,
//   tabBackgroundGradient: const LinearGradient(
//       begin: Alignment.topLeft,
//       end: Alignment.bottomRight,
//       colors: [
//         Color(0xffF0FCFD),
//         Color(0xffEAF0FF),
//         Color(0xffF9F2FF),
//         Colors.white
//       ],
//       transform: GradientRotation(45)),
//   style: GnavStyle.google,
//     tabs: [
//   GButton(
//     icon: Icons.home,
//     text: 'Home',
//     textStyle: GoogleFonts.roboto(
//       fontWeight: FontWeight.bold,
//     ),
//   ),
//   GButton(
//     icon: Icons.map,
//     text: 'Map',
//     textStyle: GoogleFonts.roboto(
//       fontWeight: FontWeight.bold,
//     ),
//   ),
//   GButton(
//     icon: Icons.app_registration,
//     text: 'Complaint',
//     textStyle: GoogleFonts.roboto(
//       fontWeight: FontWeight.bold,
//     ),
//   ),
//   GButton(
//     icon: Icons.account_circle_sharp,
//     text: 'Me',
//     textStyle: GoogleFonts.roboto(
//       fontWeight: FontWeight.bold,
//     ),
//   ),
// ]),
