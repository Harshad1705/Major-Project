import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:velocity_x/velocity_x.dart';
List<BoxShadow> myShadows = [
  const BoxShadow(
    offset:Offset(-5, -5),
    color: Color(0xffEAEFFF),
    blurRadius: 10,
  ),
  const BoxShadow(
    offset: Offset(5, 5),
    color: Color(0xffC2CCEB),
    blurRadius: 10,
  )
];
class ComplaintPage extends StatefulWidget {
  const ComplaintPage({Key? key}) : super(key: key);

  @override
  State<ComplaintPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  List<Widget> compPages = [
    const NewComplaint(),
    const RegisteredComplaint(),
  ];
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: context.screenWidth,
          decoration: const BoxDecoration(
            color: Vx.white,
          ),
          child: Column(
            children: [
              GNav(
                  onTabChange: (index){
                    setState(()=>pageIndex = index);
                  },
                  tabBorderRadius: 20,
                  tabBackgroundGradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Color(0xffF0FCFD),
                      Color(0xffEAF0FF),
                      Color(0xffF9F2FF),
                    ],
                  ),
                  style: GnavStyle.oldSchool,
                  tabs: [
                    GButton(
                      icon: Icons.reviews_rounded,
                      text: 'New Complaint',
                      textStyle: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GButton(
                      icon: Icons.rate_review,
                      text: 'Registered Complaint',
                      textStyle: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]).p(10),
              compPages[pageIndex],
            ],
          ),
        ),
      ),
    );
  }
}


class NewComplaint extends StatefulWidget {
  const NewComplaint({Key? key}) : super(key: key);

  @override
  State<NewComplaint> createState() => _NewComplaintState();
}

class _NewComplaintState extends State<NewComplaint> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'c',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: EdgeInsets.only(top: context.screenWidth*0.02),
        height: context.screenHeight/1.5,
        width: context.screenWidth/1.05,
        decoration:  BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xffF0FCFD),
                Color(0xffEAF0FF),
                Color(0xffF9F2FF),
                Colors.white
              ],
              transform: GradientRotation(45)),
          boxShadow: myShadows,
        ),
        child: Center(
          child: Text(
            "New Complaint Page",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 15,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class RegisteredComplaint extends StatefulWidget {
  const RegisteredComplaint({Key? key}) : super(key: key);

  @override
  State<RegisteredComplaint> createState() => _RegisteredComplaintState();
}

class _RegisteredComplaintState extends State<RegisteredComplaint> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'c',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: EdgeInsets.only(top: context.screenWidth*0.02),
        height: context.screenHeight/1.5,
        width: context.screenWidth/1.05,
        decoration:  BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xffF0FCFD),
                Color(0xffEAF0FF),
                Color(0xffF9F2FF),
                Colors.white
              ],
              transform: GradientRotation(45)),
          boxShadow: myShadows,
        ),
        child: Center(
          child: Text(
            "Registered Complaint",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 15,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}


