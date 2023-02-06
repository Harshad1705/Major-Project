import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'signup_signin.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final CarouselController controller = CarouselController();

  List<String> lottieList = [
    "assets/WomenTrouble.json",
    "assets/SOS.json",
    "assets/CopMotor.json",
    "assets/WomenSaved.json",
  ];
  List<String> notations = [
    "Are You In Trouble?",
    "Just Press SOS",
    "And You Will Get Instant Help",
    "Without Any Document Work"
  ];
  bool isTapped = false;
  @override
  Widget build(BuildContext context) {
    Offset distance = isTapped ? const Offset(5, 5) : const Offset(14, 14);
    double blur = isTapped ? 5.0 : 30.0;
    return Scaffold(
      body: Container(
        width: context.screenWidth,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xffF0FCFD),
                Color(0xffEAF0FF),
                Color(0xffF9F2FF),
                Colors.white
              ],
              transform: GradientRotation(45)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(
              flex: 2,
            ),
            Text("Women Safety",style: GoogleFonts.poppins(
                fontSize: 20, color: const Color.fromRGBO(70, 69, 66, 1)),),
            const Spacer(
              flex: 2,
            ),
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              height: context.screenHeight / 2,
              width: context.screenHeight / 2.3,
              decoration: BoxDecoration(
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
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(-5, -5),
                      color: Color(0xffEAEFFF),
                      blurRadius: 5,
                      inset: true,
                    ),
                    BoxShadow(
                      offset: Offset(5, 5),
                      color: Color(0xffC2CCEB),
                      blurRadius: 5,
                      inset: true,
                    )
                  ]),
              child: CarouselSlider.builder(
                  itemCount: 4,
                  carouselController: controller,
                  options: CarouselOptions(
                    height: 300,
                    aspectRatio: 9 / 16,
                    viewportFraction: 1.2,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.easeInOut,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                  itemBuilder: (BuildContext context, int itemIndex,
                          int pageViewIndex) =>
                      Lottie.asset(lottieList[itemIndex],
                          width: context.screenWidth * 1.2,
                          height: context.screenHeight)),
            ),
            const Spacer(
              flex: 3,
            ),
            Listener(
              onPointerUp: (_) => setState(() => isTapped = false),
              onPointerDown: (_) => setState(() => isTapped = true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                height: context.screenHeight / 12,
                width: context.screenHeight / 5,
                decoration: BoxDecoration(
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
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        offset: -distance,
                        color: const Color(0xffEAEFFF),
                        blurRadius: blur,
                        inset: isTapped,
                      ),
                      BoxShadow(
                        offset: distance,
                        color: const Color(0xffC2CCEB),
                        blurRadius: blur,
                        inset: isTapped,
                      )
                    ]),
                child: Center(
                    child: Text("Get Started",style: GoogleFonts.poppins(
                        fontSize: 20, color: const Color.fromRGBO(70, 69, 66, 1)),),),
              ).onTap(() {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SignupIn()));
              }),
            ),
            const Spacer(
              flex: 5,
            ),
          ],
        ),
      ),
    );
  }
}
