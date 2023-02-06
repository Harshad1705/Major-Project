import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:vibration/vibration.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:telephony/telephony.dart';
import 'package:women_security/User/Pages/map_page.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../Utils/text_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> categories = ["Emergency","Category 1","Category 2", "Category 3", "Category 4","Category 5"];
  String selectedCategory = "Emergency";
  bool isSOSTapped = false;
  late TwilioFlutter twilioFlutter;
  int timer = 5;
  String timeStamp = "";
  final telephony = Telephony.instance;

  _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  @override
  void initState() {
    twilioFlutter = TwilioFlutter(
        accountSid: 'ACd469a89a65ab509ed664bb6cddabc571',
        authToken: '4208f2f3d57a9c2a6ffe64485b4263a7',
        twilioNumber: '+12253205456');
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Offset distanceN = isSOSTapped ? const Offset(5, 5) : const Offset(10, 10);
    double blurN = isSOSTapped ? 5.0 : 20.0;
    List<BoxShadow> myShadows = [
      BoxShadow(
        offset: -distanceN,
        color: !isSOSTapped? const Color(0xffEAEFFF): Vx.red500,
        blurRadius: blurN,
      ),
      BoxShadow(
        offset: distanceN,
        color: !isSOSTapped? const Color(0xffC2CCEB): Vx.red500,
        blurRadius: blurN,
      )
    ];
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 1),
        width: context.screenWidth,
        decoration: const BoxDecoration(
          // color: Vx.white,
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Color(0xffF0FCFD),
                Color(0xffEAF0FF),
                Color(0xffF9F2FF),
              ],
              // transform: GradientRotation(45)
          ),
        ),
        child: Column(
          children: [
            getSOSButton(myShadows),
            getCategory(myShadows),
            const Spacer(),
            Text(
              "We Are Here To Help You!",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                letterSpacing: 1,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
  void sendSms(String message, String receiver) async {
    // twilioFlutter.sendSMS(
    //     toNumber: '+918827657215', messageBody: 'I Need Urgent Help Please Help me! i Have Trouble - $selectedCategory');
  }
  _sendSMS(String message, String receiver) async {
    await telephony.requestSmsPermissions;
    int size = TextData.addedPreferences.length;
    for(int i = 0; i < size; i++){
      telephony.sendSms(
          to: TextData.addedPreferences.elementAt(i)[2],
          message: message
      );
    }
  }
  getSOSButton(var myShadows){
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      margin: EdgeInsets.only(top: context.screenHeight*0.15),
      height: context.screenHeight/3,
      width: context.screenHeight/3,
      decoration:  BoxDecoration(
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
      child: Center(
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            height: context.screenHeight/4,
            width: context.screenHeight/4,
            decoration:  BoxDecoration(
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
              boxShadow: [
                BoxShadow(
                  offset: const Offset(-10, -10),
                  color: !isSOSTapped? const Color(0xffEAEFFF): Vx.red500,
                  blurRadius: 10,
                  inset: isSOSTapped,
                ),
                BoxShadow(
                  offset: const Offset(10, 10),
                  color: !isSOSTapped? const Color(0xffC2CCEB): Vx.red500,
                  blurRadius: 10,
                  inset: isSOSTapped,
                )
              ],
            ),
            child: Lottie.asset("assets/SOS.json",animate: isSOSTapped, height: 100, width: 100)
        ).onInkTap(() async{
          setState(() => isSOSTapped = true);
          _determinePosition();
          _sendSMS("I am in Trouble! Please help me ⚠🆘", '8827657215');
          vibrate(500);
          dialogBox();
        }),
      ),
    );
  }
  vibrate(int dr) async{
    if (await Vibration.hasVibrator()??true) {
      Vibration.vibrate(duration: dr);
    }
  }
  dialogBox(){
    return AwesomeDialog(
        context: context,
        autoHide: const Duration(seconds: 6),
        dialogType: DialogType.question,
        animType: AnimType.bottomSlide,
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        customHeader: count(),
        title: 'NEED HELP!',
        titleTextStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: Vx.red500,
          fontSize: 15,
          letterSpacing: 1,
        ),
        btnCancelText: "No",
        btnOkText: "Yes",
        desc: 'Do You Want To Continue?',
        btnCancelOnPress: () {},
        btnOkOnPress: () {
        },
        dialogBorderRadius: BorderRadius.circular(30),
        onDismissCallback: (value){
          setState(() {
            isSOSTapped = false;
          });
          if(value == DismissType.other || value == DismissType.btnOk){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MapPage()));
          }
        }
    ).show();
  }
  count(){
    return CircularCountDownTimer(
      // Countdown duration in Seconds.
      duration: 6,

      // Width of the Countdown Widget.
      width: MediaQuery.of(context).size.width / 5,

      // Height of the Countdown Widget.
      height: MediaQuery.of(context).size.height / 5,

      // Ring Color for Countdown Widget.
      ringColor: Colors.greenAccent[100]!,


      // Filling Color for Countdown Widget.
      fillColor: Colors.redAccent.shade200,


      // Background Color for Countdown Widget.
      backgroundColor: Vx.red600,
      
      
      // Border Thickness of the Countdown Ring.
      strokeWidth: 10.0,

      // Begin and end contours with a flat edge and no extension.
      strokeCap: StrokeCap.round,

      // Text Style for Countdown Text.
      textStyle: const TextStyle(
        fontSize: 33.0,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),

      // Format for the Countdown Text.
      textFormat: CountdownTextFormat.S,

      // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
      isReverse: true,

      // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
      isReverseAnimation: true,

      // Handles visibility of the Countdown Text.
      isTimerTextShown: true,

      // Handles the timer start.
      autoStart: true,

      // This Callback will execute when the Countdown Changes.
      onChange: (String tStamp) async{
        // Here, do whatever you want
        if(timeStamp != tStamp){
          timeStamp = tStamp;
          if (await Vibration.hasVibrator()??true) {
            Vibration.vibrate(duration: 100);
          }
        }
        debugPrint('Countdown Changed $timeStamp');
      },
    );
  }
  getCategory(var myShadows) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      margin: EdgeInsets.only(top: context.screenHeight*0.05),
      height: context.screenHeight/15,
      width: context.screenWidth/1.2,
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
        ],
      ),
      child: DropdownButtonFormField(
        alignment: Alignment.center,
        enableFeedback: true,
        isDense: true,
        borderRadius: BorderRadius.circular(30),
        menuMaxHeight: context.screenHeight/2,
        dropdownColor: const Color(0xffEAEFFF),
        isExpanded: true,
        decoration: const InputDecoration(
          alignLabelWithHint: false,
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 50,right: 20),
        ),
        hint: Center(
          child: Text(
            "Emergency",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 15,
              letterSpacing: 1,
            ),
          ),
        ),
        iconSize: 30,
        items: categories.map((item) => DropdownMenuItem<String>(
          value: item,
          child: AnimatedContainer(
              alignment: Alignment.center,
              duration: const Duration(seconds: 1),
              height: context.screenHeight / 15,
              width: context.screenHeight / 1.2,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius:
                BorderRadius.circular(15),
              ),
              child: Center(child: Text(item,style: GoogleFonts.poppins(
                letterSpacing: 1,
                fontSize: 15,
              ),))),
        ))
            .toList(),
        onChanged: (Object? value) {
          setState(() {
            selectedCategory = value.toString();
          });
        },)
    );
  }
}
