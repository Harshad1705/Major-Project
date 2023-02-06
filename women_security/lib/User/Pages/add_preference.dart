// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:velocity_x/velocity_x.dart';
// import 'package:women_security/Pages/Navigation%20Pages/preferences.dart';
//
// import '../Utils/text_data.dart';
//
// class AddPreference extends StatefulWidget {
//   const AddPreference({Key? key}) : super(key: key);
//
//   @override
//   State<AddPreference> createState() => _AddPreferenceState();
// }
//
// class _AddPreferenceState extends State<AddPreference> {
//   bool nextTapped = false;
//   List<String> prefData = ["", "", "", ""];
//   @override
//   Widget build(BuildContext context) {
//     final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
//     Offset distance = nextTapped ? const Offset(5, 5) : const Offset(14, 14);
//     double blur = nextTapped ? 5.0 : 30.0;
//     return Material(
//       child: Scaffold(
//         body: AnimatedContainer(
//           duration: const Duration(seconds: 1),
//           width: context.screenWidth,
//           height: context.screenHeight,
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   Color(0xffF0FCFD),
//                   Color(0xffEAF0FF),
//                   Color(0xffF9F2FF),
//                   Colors.white
//                 ],
//                 transform: GradientRotation(45)),
//           ),
//           child: Column(
//             children: [
//               Spacer(),
//               Text(
//                 "Add Preference",
//                 style: GoogleFonts.poppins(
//                     fontSize: 20, color: const Color.fromRGBO(70, 69, 66, 1)),
//               ),
//               Spacer(),
//               Hero(tag: "addMember", child: getCard()),
//               Spacer(),
//               !isKeyboard?getNextButton(distance,blur):SizedBox(),
//               Spacer(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   getNextButton(var distanceN, var blurN){
//     return Listener(
//       onPointerUp: (_) => setState(() => nextTapped = false),
//       onPointerDown: (_) => setState(() => nextTapped = true),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 100),
//         height: context.screenHeight / 12,
//         width: context.screenHeight / 5,
//         decoration: BoxDecoration(
//             gradient: const LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   Color(0xffF0FCFD),
//                   Color(0xffEAF0FF),
//                   Color(0xffF9F2FF),
//                   Colors.white
//                 ],
//                 transform: GradientRotation(45)),
//             borderRadius: BorderRadius.circular(30),
//             boxShadow: [
//               BoxShadow(
//                 offset: -distanceN,
//                 color: const Color(0xffEAEFFF),
//                 blurRadius: blurN,
//               ),
//               BoxShadow(
//                 offset: distanceN,
//                 color: const Color(0xffC2CCEB),
//                 blurRadius: blurN,
//               )
//             ]),
//         child: Center(
//           child: Text(
//             "Save",
//             style: GoogleFonts.poppins(
//                 fontSize: 20,
//                 color: const Color.fromRGBO(70, 69, 66, 1)),
//           ),
//         ),
//       ).onTap(() {
//         setState(() {
//           TextData.addedPreferences.add(prefData);
//           print(TextData.addedPreferences);
//           isAdd = false;
//         });
//       }),
//     );
//   }
//
//   getCard() {
//     return AnimatedContainer(
//       duration: const Duration(seconds: 1),
//       height: context.screenHeight/2,
//       width: context.screenWidth / 1.1,
//       decoration: BoxDecoration(
//           gradient: const LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Color(0xffF0FCFD),
//                 Color(0xffEAF0FF),
//                 Color(0xffF9F2FF),
//                 Colors.white
//               ],
//               transform: GradientRotation(45)),
//           borderRadius: BorderRadius.circular(50),
//           boxShadow: const [
//             BoxShadow(
//               offset: Offset(-10, -10),
//               color: Color(0xffEAEFFF),
//               blurRadius: 20,
//             ),
//             BoxShadow(
//               offset: Offset(10, 10),
//               color: Color(0xffC2CCEB),
//               blurRadius: 20,
//             )
//           ]),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           getDetails("Full Name",TextInputType.name,0),
//           getDetails("Relation",TextInputType.name,1),
//           getDetails("Mobile Number",TextInputType.name,2),
//           getDetails("Email(Optional)",TextInputType.name,3),
//         ],
//       ),
//     );
//   }
//
//   getDetails(String hint, var type, int storeIndex) {
//     return AnimatedContainer(
//       duration: const Duration(seconds: 1),
//       height: context.screenHeight / 12,
//       width: context.screenHeight / 2.6,
//       decoration: BoxDecoration(
//           gradient: const LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Color(0xffF0FCFD),
//                 Color(0xffEAF0FF),
//                 Color(0xffF9F2FF),
//                 Colors.white
//               ],
//               transform: GradientRotation(45)),
//           borderRadius: BorderRadius.circular(30),
//           boxShadow: const [
//             BoxShadow(
//               offset: Offset(-5, -5),
//               color: Color(0xffEAEFFF),
//               blurRadius: 5,
//               // inset: true,
//             ),
//             BoxShadow(
//               offset: Offset(5, 5),
//               color: Color(0xffC2CCEB),
//               blurRadius: 5,
//               // inset: true,
//             )
//           ]),
//       child: TextFormField(
//         textAlign: TextAlign.left,
//         maxLength: 50,
//         cursorColor: Colors.red,
//         cursorHeight: 20,
//         keyboardType: type,
//         onChanged: (value){
//           setState(() {
//             prefData[storeIndex] = value;
//           });
//         },
//         style: const TextStyle(
//           letterSpacing: 1,
//           fontSize: 20,
//         ),
//         decoration: InputDecoration(
//           counterText: "",
//           contentPadding: const EdgeInsets.all(25),
//           isDense: true,
//           border: InputBorder.none,
//           hintText: hint,
//           hintStyle: TextStyle(fontSize: 20)
//         ),
//       ),
//     );
//   }
// }
