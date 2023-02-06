import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:velocity_x/velocity_x.dart';
import 'registration.dart';
class OtpPage extends StatefulWidget {
  const OtpPage({Key? key}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();

  @override
  String toStringShort() => 'Rounded With Shadow';
}

class _OtpPageState extends State<OtpPage> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  bool isTapped = false;

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Offset distance = isTapped ? const Offset(5, 5) : const Offset(14, 14);
    double blur = isTapped ? 5.0 : 30.0;
    verifyButton(){
      return Listener(
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
                    // inset: isTapped,
                  ),
                  BoxShadow(
                    offset: distance,
                    color: const Color(0xffC2CCEB),
                    blurRadius: blur,
                    // inset: isTapped,
                  )
                ]),
            child: const Center(
                child: Text(
                  "Verify",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    letterSpacing: 1,
                    fontSize: 20,
                  ),
                )),
          ).onTap(()async{
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Registration(mobile: '8827657215',)));
          })
      );
    }
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 64,
      textStyle: GoogleFonts.poppins(
          fontSize: 20, color: const Color.fromRGBO(70, 69, 66, 1)),
      decoration: BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xffdefeff),
                Color(0xffdee6ff),
                Color(0xffeed9ff),
                Colors.white
              ],
              transform: GradientRotation(45)),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              offset: Offset(-10, -10),
              color: Color(0xffEAEFFF),
              blurRadius: 20,
            ),
            BoxShadow(
              offset: Offset(10, 10),
              color: Color(0xffC2CCEB),
              blurRadius: 20,
            )
          ]),
    );

    final cursor = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 21,
        height: 1,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(137, 146, 160, 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

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
          children: [
            const Spacer(flex: 2,),
            Text("Enter OTP",style: GoogleFonts.poppins(
                fontSize: 20, color: const Color.fromRGBO(70, 69, 66, 1)),),
            const Spacer(flex: 1,),
            Center(
              child: Pinput(
                length: 4,
                controller: controller,
                focusNode: focusNode,
                defaultPinTheme: defaultPinTheme,
                separator: const SizedBox(width: 16),
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xffEAEFFF),
                        offset: Offset(0, 3),
                        blurRadius: 16,
                      )
                    ],
                  ),
                ),
                androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsRetrieverApi,
                showCursor: true,
                cursor: cursor,
              ),
            ),
            const Spacer(flex: 2,),
            verifyButton(),
            const Spacer(flex: 5,),
          ],
        ),
      ),
    );
  }
}
