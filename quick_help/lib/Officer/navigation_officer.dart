import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:quick_help/Officer/history_page_officer.dart';
import 'package:quick_help/Officer/home_page_officer.dart';
import 'package:quick_help/Officer/me_page_officer.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int index = 0;
  int pageIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  List<Widget> pages = [
    const HomePageOfficer(),
    const History(),
    const MePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:  GNav(
          onTabChange: (index){
            setState(() {
              pageIndex = index;
            });
          },
          tabBorderRadius: 20,
          tabBackgroundGradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xffF0FCFD),
                Color(0xffEAF0FF),
                Color(0xffF9F2FF),
                Colors.white
              ],
              transform: GradientRotation(45)),
          style: GnavStyle.google,
          tabs: [
            GButton(
              icon: Icons.home,
              text: 'Home',
              textStyle: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
              ),
            ),
            GButton(
              icon: Icons.app_registration,
              text: 'Complaint',
              textStyle: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
              ),
            ),
            GButton(
              icon: Icons.account_circle_sharp,
              text: 'Me',
              textStyle: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
      body: pages[pageIndex],
    );
  }
}

