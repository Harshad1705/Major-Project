import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:women_security/User/Pages/start_page.dart';

class MePage extends StatefulWidget {
  const MePage({Key? key}) : super(key: key);

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<bool> isButtonTapped = [false,false,false,false,false,false];
  @override
  Widget build(BuildContext context) {
    List<BoxShadow> myShadows = [
      const BoxShadow(
        offset: Offset(-2, -2),
        color: Color(0xffEAEFFF),
        blurRadius: 10,
      ),
      const BoxShadow(
        offset: Offset(2, 2),
        color: Color(0xffC2CCEB),
        blurRadius: 10,
      )
    ];
    Offset distance = isButtonTapped[5] ? const Offset(2, 2) : const Offset(10, 10);
    double blur = isButtonTapped[5] ? 5.0 : 10.0;
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 1),
        width: context.screenWidth,
        decoration: const BoxDecoration(
          color: Vx.white,
        ),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            margin: EdgeInsets.only(top: context.screenHeight * 0.05),
            height: context.screenHeight / 1.2,
            width: context.screenWidth / 1.05,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Color(0xffF0FCFD),
                    Color(0xffEAF0FF),
                    Color(0xffF9F2FF),
                  ],
                  transform: GradientRotation(45)),
              boxShadow: myShadows,
            ),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  margin: EdgeInsets.only(top: context.screenHeight * 0.02),
                  height: context.screenHeight / 5,
                  width: context.screenHeight / 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(300),
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
                  child: Lottie.asset("assets/police.json",animate: false),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    getSettingContentBar("Setting", myShadows,0),
                    getSettingContentBar("Profile", myShadows,1),
                    getSettingContentBar("Have a suggestions", myShadows,2),
                    getSettingContentBar("Report a bug", myShadows,3),
                    getSettingContentBar("Share", myShadows,4),
                    Listener(
                      onPointerUp: (_) => setState(() => isButtonTapped[5] = false),
                      onPointerDown: (_) => setState(() => isButtonTapped[5] = true),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        margin: EdgeInsets.only(top: context.screenHeight * 0.04),
                        height: context.screenHeight / 15,
                        width: context.screenWidth / 3,
                        decoration: BoxDecoration(
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
                          boxShadow: [
                            BoxShadow(
                              offset: -distance,
                              color: const Color(0xffEAEFFF),
                              blurRadius: blur,
                            ),
                            BoxShadow(
                              offset: distance,
                              color: const Color(0xffC2CCEB),
                              blurRadius: blur,
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Logout",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Vx.red500,
                              fontSize: 15,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ).onTap(() async{
                        await _auth.signOut();
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(context, PageTransition(child: const StartPage(), type: PageTransitionType.size, alignment: Alignment.center));
                      }),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getSettingContentBar(String text, var myShadows,int index) {
    Offset distanceN = isButtonTapped[index] ? const Offset(2, 2) : const Offset(10, 10);
    double blurN = isButtonTapped[index] ? 5.0 : 10.0;
    return Listener(
      onPointerUp: (_) => setState(() => isButtonTapped[index] = false),
      onPointerDown: (_) => setState(() => isButtonTapped[index] = true),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        margin: EdgeInsets.only(top: context.screenHeight * 0.02),
        height: context.screenHeight / 15,
        width: context.screenWidth / 1.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Color(0xffF0FCFD),
                Color(0xffEAF0FF),
                Color(0xffF9F2FF),
              ],
              ),
          boxShadow: [
            BoxShadow(
              offset: -distanceN,
              color: const Color(0xffEAEFFF),
              blurRadius: blurN,
            ),
            BoxShadow(
              offset: distanceN,
              color: const Color(0xffC2CCEB),
              blurRadius: blurN,
            )
          ],
        ),
        child: Center(
          child: Text(
            text,
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
