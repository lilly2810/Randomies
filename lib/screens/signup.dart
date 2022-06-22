import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_flare/screens/welcome.dart';
import '../firebase/fire.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String animationType = 'idle';
  String message = "";
  bool obscurePassword = true;

  Map<String, dynamic>? userMap;
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  bool isLoading = false;
  final passwordFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final nameFocusNode = FocusNode();

  @override

  void initState() {
    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        setState(() {
          message = "";
          animationType = 'hands_up';
        });
      } else {
        setState(() {
          message = "";
          animationType = 'hands_down';
        });
      }
    });

    emailFocusNode.addListener(() {
      if (emailFocusNode.hasFocus) {
        setState(() {
          message = "";
          animationType = 'hands_down';
          animationType = 'test';
        });
      } else {
        setState(() {
          message = "";
          animationType = 'hands_down';
          animationType = 'idle';
        });
      }
    });

    super.initState();
  }
  Future<bool> onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
try{
    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("name", isEqualTo: nameController.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
    });
    return (userMap != null);}catch (e) {
  print(e);
  return false;
}

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade200,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade200,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => WelcomeScreen()),);
          },
        ),
      ),
      body:
      Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: 220,
              width: 380,
              child: FlareActor(
                'assets/Teddy.flr',
                alignment: Alignment.bottomCenter,
                fit: BoxFit.contain,
                animation: animationType,
                callback: (animation) {
                  setState(() {
                    animationType = 'hands_down';
                    animationType = 'idle';
                  });
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                color: Colors.white,
              ),
              child: Column(
                children: <Widget>[
                  TextFormField(

                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Username",
                      contentPadding: EdgeInsets.all(20),
                      prefixIcon: Icon(Icons.person),
                    ),
                    focusNode: nameFocusNode,
                    controller: nameController,
                  ),
                  Divider(),
                  TextFormField(

                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Email",
                      contentPadding: EdgeInsets.all(20),
                      prefixIcon: Icon(Icons.mail_sharp),
                    ),
                    focusNode: emailFocusNode,
                    controller: emailController,
                  ),
                  Divider(),
                  TextFormField(
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Password",
                      prefixIcon: Icon(Icons.vpn_key),
                      suffixIcon: IconButton(
                        onPressed: () =>
                            setState(() {
                              obscurePassword = !obscurePassword;
                            }),
                        icon: Icon(
                            obscurePassword ? Icons.visibility : Icons
                                .visibility_off
                        ),
                      ),
                      contentPadding: EdgeInsets.all(20),
                    ),
                    controller: passwordController,
                    focusNode: passwordFocusNode,
                  ),
                ],
              ),
            ),
            Container(
              height: 200,
              width: 380,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                    width: 20,
                  ),
                  SignUp(),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: GestureDetector(
                      onTap: () => Navigator.push(context,MaterialPageRoute(builder: (_) => LoginScreen())),
                      child: Text("Login", style: GoogleFonts.caveat(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w500,),),
                    ),),
                  SizedBox(
                    height: 20,
                    width: 10,
                  ),
                  Container(
                    height: 50,
                    child:
                    Text(message, style: GoogleFonts.caveat(color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 28),),
                  ),
                  SizedBox(
                    height: 10,
                    width: 300,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget SignUp() {
    return GestureDetector(
      onTap: () async{
        if (nameController.text.isNotEmpty &&
            emailController.text.isNotEmpty &&
            passwordController.text.isNotEmpty) {
        bool valid = await onSearch();
        print(valid);
        if (valid== true) {
          // username exists
          setState(() {
            message='Username not available';
            animationType='fail';
          });
        }
     else{
          setState(() {
            message="";
            animationType='idle';
            isLoading = true;
          });

          createAccount(nameController.text, emailController.text,
              passwordController.text).then((user) async {
            if (user != null) {
              setState(() {
                animationType = 'hands_down';
                animationType = 'success';
                message = "Account Created";
                isLoading = false;
              });
              await Future.delayed(Duration(milliseconds: 1800));
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => LoginScreen()));
            } else {
              setState(() {
                animationType = 'hands_down';
                animationType = 'fail';
                message = "Account Creation Failed";
                isLoading = false;
              });
            }
          });
        }
        } else {
          setState(() {
            animationType = 'hands_down';
            animationType = 'fail';
            message = "Enter the required credentials";
          });

        }
      },
      child: Container(
          height: 50,
          width: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.blue.shade200,
          ),
          alignment: Alignment.center,
          child: Text(
            "Create Account",
            style: GoogleFonts.caveat(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }
}