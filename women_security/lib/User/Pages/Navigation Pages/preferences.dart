import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../Utils/shared_preferences.dart';
import '../../Utils/text_data.dart';

class Preferences extends StatefulWidget {
  const Preferences({Key? key}) : super(key: key);

  @override
  State<Preferences> createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  bool isAdd = false;
  bool nextTapped = false;
  bool canSave = false;
  bool _keyboardVisible = false;
  String name = "";
  String relation = "";
  String mobileNumber = "";
  String email = "";
  List<String> keys = [];

  @override
  Widget build(BuildContext context) {
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    Offset distance = nextTapped ? const Offset(5, 5) : const Offset(14, 14);
    double blur = nextTapped ? 5.0 : 30.0;

    return !isAdd
        ? Scaffold(
            body: AnimatedContainer(
              duration: const Duration(seconds: 1),
              width: context.screenWidth,
              height: context.screenHeight,
              decoration: const BoxDecoration(
                color: Vx.black,
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
                  const Spacer(
                    flex: 2,
                  ),
                  Text(
                    "Prefrences",
                    style: GoogleFonts.lato(fontSize: 40),
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  getCard(),
                  const Spacer(),
                  Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
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
                      borderRadius: BorderRadius.circular(20),
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
                      ],
                    ),
                    child: Text(
                      "Add New Member",
                      style: GoogleFonts.lato(fontSize: 15),
                    ).centered(),
                  ).onInkTap(() {
                    setState(() {
                      isAdd = true;
                    });
                  }),
                  const Spacer(),
                ],
              ),
            ),
          )
        : WillPopScope(
            onWillPop: () async {
              setState(() {
                isAdd = false;
              });
              return false;
            },
            child: Scaffold(
              body: AnimatedContainer(
                duration: const Duration(seconds: 1),
                width: context.screenWidth,
                height: context.screenHeight,
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
                    const Spacer(),
                    Text(
                      "Add Preference",
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: const Color.fromRGBO(70, 69, 66, 1)),
                    ),
                    const Spacer(),
                    getCardAdd(),
                    const Spacer(),
                    !_keyboardVisible
                        ? Flexible(child: getNextButton(distance, blur))
                        : const SizedBox(),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          );
  }

  getNextButton(var distanceN, var blurN) {
    return Listener(
      onPointerUp: (_) => setState(() => nextTapped = false),
      onPointerDown: (_) => setState(() => nextTapped = true),
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
                offset: -distanceN,
                color: const Color(0xffEAEFFF),
                blurRadius: blurN,
                inset: !canSave,
              ),
              BoxShadow(
                offset: distanceN,
                color: const Color(0xffC2CCEB),
                blurRadius: blurN,
                inset: !canSave,
              )
            ]),
        child: Center(
          child: Text(
            "Save",
            style: GoogleFonts.poppins(
                fontSize: 20, color: const Color.fromRGBO(70, 69, 66, 1)),
          ),
        ),
      ).onTap(() {
        setState(() {
          if (name != "" &&
              relation != "" &&
              mobileNumber != "" &&
              email != "") {
            TextData.addedPreferences
                .add([name, relation, mobileNumber, email]);
            for(int i = 0; i < TextData.addedPreferences.length; i++){
              keys.add(TextData.addedPreferences.elementAt(i)[0].toString());
            }
            SharedPrefs.setKeys(keys);
            SharedPrefs.setPreferences([name, relation, mobileNumber, email], name);
            name = relation = mobileNumber = email = "";
          }
          if (canSave) {
            canSave = false;
            isAdd = false;
          } else {
            isAdd = true;
          }
        });
      }),
    );
  }

  getCard() {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        // margin: EdgeInsets.only(top: 40),
        height: context.screenHeight / 1.6,
        width: context.screenWidth / 1.1,
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
          borderRadius: BorderRadius.circular(20),
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
          ],
        ),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              child: TextData.addedPreferences.isEmpty
                  ? Center(
                      child: Text(
                        "No Preferences Added ",
                        style: GoogleFonts.lato(fontSize: 20),
                      ),
                    )
                  : AnimatedList(
                      key: _listKey,
                      initialItemCount: TextData.addedPreferences.count(),
                      itemBuilder: (context, value, animation) {
                        return _buildItems(value, TextData.addedPreferences.elementAt(value), animation);
                      },
                    ),
            ),
            // Positioned(
            //   left: 300,
            //     top: 580,
            //     child: FloatingActionButton(
            //   onPressed: () {},
            //   child: Icon(Icons.add,size: 30,),
            //   backgroundColor: Colors.redAccent.shade400,
            // ))
          ],
        ),
      ),
    );
  }
  Widget _buildItems(int value, List<String> item, Animation<double> animation){
    return ScaleTransition(
      scale: animation,
      child: Center(
        child: Container(
          height: context.screenHeight / 5,
          width: context.screenWidth / 1.2,
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
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text("Name: ${item[0]}",
                    style: GoogleFonts.lato(fontSize: 18),
                  ).centered(),
                  const Spacer(),
                  Text(
                    "Relation: ${item[1]}",
                    style: GoogleFonts.lato(fontSize: 18),
                  ).centered(),
                  const Spacer(),
                  Text(
                    "Mobile: ${item[2]}",
                    style: GoogleFonts.lato(fontSize: 18,),
                  ).centered(),
                  const Spacer(),
                  Text(
                    "Email: ${item[3]}",
                    style: GoogleFonts.lato(fontSize: 18),
                  ).centered(),
                  const Spacer(),
                ],
              ).p(10),
              const Center(child: Icon(Icons.delete_forever, color: Colors.redAccent,size: 30,),).px(30).onInkTap(() async{
                var removedItem = TextData.addedPreferences.elementAt(value);
                SharedPrefs.deletePreferenceKey(removedItem[0]);
                TextData.addedPreferences.remove(TextData.addedPreferences.elementAt(value));
                keys.clear();
                for(int i = 0; i < TextData.addedPreferences.length; i++){
                  keys.add(TextData.addedPreferences.elementAt(i)[0].toString());
                }
                await SharedPrefs.setKeys(keys);
                // ignore: prefer_function_declarations_over_variables
                AnimatedListRemovedItemBuilder builder = (context, animation){
                  return _buildItems(value,removedItem, animation);
                };
                _listKey.currentState?.removeItem(
                    value,
                    builder
                );
                SnackBar snackBar = const SnackBar(
                    content: Text("Preference Removed ✅")
                );
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              })
            ],
          ),
        ),
      ).py(10),
    );
  }
  getCardAdd() {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      height: context.screenHeight / 2,
      width: context.screenWidth / 1.1,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          getDetails("Full Name", TextInputType.name),
          getDetails("Relation", TextInputType.name),
          getDetails("Mobile Number", TextInputType.phone),
          getDetails("Email(Optional)", TextInputType.emailAddress),
        ],
      ),
    );
  }

  getDetails(String hint, var type) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      height: context.screenHeight / 12,
      width: context.screenHeight / 2.6,
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
          boxShadow: const [
            BoxShadow(
              offset: Offset(-5, -5),
              color: Color(0xffEAEFFF),
              blurRadius: 5,
              // inset: true,
            ),
            BoxShadow(
              offset: Offset(5, 5),
              color: Color(0xffC2CCEB),
              blurRadius: 5,
              // inset: true,
            )
          ]),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.always,
        textAlign: TextAlign.left,
        maxLength: 50,
        cursorColor: Colors.red,
        cursorHeight: 20,
        keyboardType: type,
        onChanged: (value) {
          setState(() {
            if (hint == "Full Name") {
              name = value;
            } else if (hint == "Relation") {
              relation = value;
            } else if (hint == "Mobile Number") {
              mobileNumber = value;
            } else {
              email = value;
            }
            var regx = RegExp(r"/[^A-z\s\d][\\\^]?/g");
            if (mobileNumber.length >= 10 &&
                regx.matchAsPrefix(mobileNumber) == null) {
              canSave = true;
            } else {
              canSave = false;
            }
          });
        },
        style: const TextStyle(
          letterSpacing: 1,
          fontSize: 20,
        ),
        decoration: InputDecoration(
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.redAccent,
            )),
            counterText: "",
            contentPadding: const EdgeInsets.all(25),
            isDense: true,
            border: InputBorder.none,
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
