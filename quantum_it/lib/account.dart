import 'dart:ui';

import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool isLogin = true;
  bool isChecked = false;
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isLogin == false) {
                          isLogin = true;
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isLogin ? Colors.red : Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40.0),
                          bottomRight: isLogin
                              ? Radius.circular(40.0)
                              : Radius.circular(0),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width / 2,
                      child: Center(
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                              fontSize: 18,
                              letterSpacing: 2,
                              color: Colors.blueGrey),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isLogin == true) {
                          isLogin = false;
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isLogin ? Colors.white : Colors.red,
                        borderRadius: BorderRadius.only(
                          bottomLeft: isLogin
                              ? Radius.circular(0)
                              : Radius.circular(40),
                          bottomRight: Radius.circular(40.0),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width / 2,
                      child: Center(
                        child: Text(
                          "SIGN UP",
                          style: TextStyle(
                              fontSize: 18,
                              letterSpacing: 2,
                              color: Colors.blueGrey),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.only(top: 20, left: 30, right: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40.0),
              ),
              height: MediaQuery.of(context).size.height / 1.45,
              width: MediaQuery.of(context).size.width,
              child: isLogin ? _login() : _signup(),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 10,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: Center(
                child: Text(
                  "REGISTER",
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 3,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _textField(
      {required String title,
      required TextEditingController controller,
      required String hinttext,
      required Icon icon,
      bool contact = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hinttext,
            suffixIcon: icon,
          ),
          style: TextStyle(
            fontSize: 18,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  _login() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "SignIn into your Account",
          style: TextStyle(
              color: Colors.red, fontSize: 26, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 33,
        ),
        _textField(
          title: "Email",
          controller: controllerEmail,
          hinttext: 'johndoe@gmail.com',
          icon: Icon(Icons.email),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 33,
        ),
        _textField(
          title: "Password",
          controller: controllerEmail,
          hinttext: 'Password',
          icon: Icon(Icons.lock_outline),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 75,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Forgot Password ? ",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            )
          ],
        ),
        Column(
            //TODO : yaha se aage hai
            ),
      ],
    );
  }

  _signup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Create an Account",
          style: TextStyle(
              color: Colors.red, fontSize: 26, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 33,
        ),
        _textField(
          title: "Name",
          controller: controllerName,
          hinttext: "John Doe",
          icon: Icon(Icons.person),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 33,
        ),
        _textField(
          title: "Email",
          controller: controllerEmail,
          hinttext: "johndoe@gmail.com",
          icon: Icon(Icons.email),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 33,
        ),
        _textField(
          title: "Contact No",
          controller: controllerNumber,
          hinttext: "9876543210",
          icon: Icon(
            Icons.call,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 33,
        ),
        _textField(
          title: "Password",
          controller: controllerEmail,
          hinttext: '*********',
          icon: Icon(Icons.lock_outline),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              checkColor: Colors.white,
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                });
              },
            ),
            Text(
              "I agree with ",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            Text(
              "term & condition",
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already have an Account ?",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (isLogin == false) {
                    isLogin = true;
                  }
                });
              },
              child: Text(
                "Sign In!",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
