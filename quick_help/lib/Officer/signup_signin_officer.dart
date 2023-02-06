import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:quick_help/Officer/home_page_officer.dart';
import 'package:quick_help/Officer/navigation_officer.dart';
import 'package:quick_help/Officer/registration_officer.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

enum MobilVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class SignUpSignInOfficer extends StatefulWidget {
  const SignUpSignInOfficer({Key? key}) : super(key: key);

  @override
  State<SignUpSignInOfficer> createState() => _SignUpSignInOfficerState();
}

class _SignUpSignInOfficerState extends State<SignUpSignInOfficer> {
  MobilVerificationState currentState =
      MobilVerificationState.SHOW_MOBILE_FORM_STATE;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final focusNode = FocusNode();
  bool isTapped = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('officers');
  String verificationID = "";

  bool showLoading = false;
  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });
    bool hasFirestoreData = false;
    await users
        .doc(phoneController.text)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        hasFirestoreData = true;
      }
      print(documentSnapshot.data());
    });
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        showLoading = false;
      });
      if (authCredential.user != null) {
        // Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return hasFirestoreData
              ? Navigation()
              : RegistrationOfficer(mobile: phoneController.text);
        }));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message.toString()),
      ));
    }
  }

  bool isTapped_1 = false;
  getMobileFormWidget(context) {
    Offset distance = isTapped ? const Offset(5, 5) : const Offset(14, 14);
    double blur = isTapped ? 5.0 : 30.0;
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
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
              flex: 1,
            ),
            const Icon(
              Icons.account_circle,
              size: 50,
              color: Vx.red400,
            ),
            const Spacer(
              flex: 1,
            ),
            Text(
              "Mobile Verification",
              style: GoogleFonts.poppins(
                  fontSize: 20, color: const Color.fromRGBO(70, 69, 66, 1)),
            ),
            const Spacer(
              flex: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 10,
                  width: MediaQuery.of(context).size.width / 8,
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
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30)),
                      boxShadow: [
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
                  child: const Center(
                      child: Text(
                    "  +91",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )),
                ),
                AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    height: MediaQuery.of(context).size.height / 12,
                    width: MediaQuery.of(context).size.height / 2.6,
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
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            bottomRight: Radius.circular(30)),
                        boxShadow: [
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
                    child: Center(
                      child: TextFormField(
                        controller: phoneController,
                        maxLength: 10,
                        cursorColor: Colors.black,
                        cursorHeight: 20,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(
                          letterSpacing: 1,
                          fontSize: 20,
                        ),
                        decoration: const InputDecoration(
                          counterText: "",
                          contentPadding: EdgeInsets.all(15),
                          isDense: true,
                          border: InputBorder.none,
                          hintText: "Enter A Number",
                        ),
                      ),
                    )),
              ],
            ),
            const Spacer(
              flex: 2,
            ),
            Listener(
                onPointerUp: (_) => setState(() => isTapped = false),
                onPointerDown: (_) => setState(() => isTapped = true),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  height: MediaQuery.of(context).size.height / 12,
                  width: MediaQuery.of(context).size.height / 5,
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
                          color: Color(0xffEAEFFF),
                          blurRadius: blur,
                          inset: isTapped,
                        ),
                        BoxShadow(
                          offset: distance,
                          color: Color(0xffC2CCEB),
                          blurRadius: blur,
                          inset: isTapped,
                        )
                      ]),
                  child: const Center(
                      child: Text(
                    "Get OTP",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 1,
                      fontSize: 20,
                    ),
                  )),
                ).onTap(() async {
                  if (phoneController.text.length >= 10 &&
                      phoneController.text.length < 11) {
                    setState(() {
                      showLoading = true;
                    });
                    await _auth.verifyPhoneNumber(
                        phoneNumber: "+91${phoneController.text}",
                        verificationCompleted: (phoneAuthCredential) async {
                          setState(() {
                            showLoading = false;
                          });
                          signInWithPhoneAuthCredential(phoneAuthCredential);
                        },
                        verificationFailed: (verificationFailed) async {
                          setState(() {
                            showLoading = true;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    verificationFailed.message.toString())),
                          );
                        },
                        codeSent: (verificationId, resendingToken) async {
                          setState(() {
                            showLoading = false;
                            currentState =
                                MobilVerificationState.SHOW_OTP_FORM_STATE;
                            this.verificationID = verificationId;
                          });
                        },
                        codeAutoRetrievalTimeout: (verificationId) async {});
                  } else {
                    SnackBar snakBar =
                        SnackBar(content: Text("Please Enter Valid Number!"));
                    ScaffoldMessenger.of(context).showSnackBar(snakBar);
                  }
                })),
            const Spacer(
              flex: 5,
            ),
          ],
        ),
      ),
    );
  }

  getOTPFormWidget(BuildContext context) {
    Offset distance = isTapped ? const Offset(5, 5) : const Offset(14, 14);
    double blur = isTapped ? 5.0 : 30.0;
    verifyButton() {
      return Listener(
          onPointerUp: (_) => setState(() => isTapped = false),
          onPointerDown: (_) => setState(() => isTapped = true),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            height: MediaQuery.of(context).size.height / 12,
            width: MediaQuery.of(context).size.height / 5,
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
          ).onTap(() async {
            PhoneAuthCredential phoneAuthCredential =
                PhoneAuthProvider.credential(
                    verificationId: verificationID,
                    smsCode: otpController.text);
            signInWithPhoneAuthCredential(phoneAuthCredential);
          }));
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
          borderRadius: BorderRadius.circular(10),
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
        width: MediaQuery.of(context).size.width,
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
            const Spacer(
              flex: 2,
            ),
            Text(
              "Enter OTP",
              style: GoogleFonts.poppins(
                  fontSize: 20, color: const Color.fromRGBO(70, 69, 66, 1)),
            ),
            const Spacer(
              flex: 1,
            ),
            Center(
              child: Pinput(
                length: 6,
                controller: otpController,
                focusNode: focusNode,
                defaultPinTheme: defaultPinTheme,
                separator: const SizedBox(width: 16),
                onCompleted: (str) {
                  PhoneAuthCredential phoneAuthCredential =
                      PhoneAuthProvider.credential(
                          verificationId: verificationID,
                          smsCode: otpController.text);
                  signInWithPhoneAuthCredential(phoneAuthCredential);
                },
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
                showCursor: true,
                cursor: cursor,
              ),
            ),
            const Spacer(
              flex: 2,
            ),
            verifyButton(),
            const Spacer(
              flex: 5,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
          padding: const EdgeInsets.all(16),
          child: showLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : currentState == MobilVerificationState.SHOW_MOBILE_FORM_STATE
                  ? getMobileFormWidget(context)
                  : getOTPFormWidget(context)),
    );
  }
}
