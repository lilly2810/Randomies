import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_flare/main.dart';
import 'package:flutter_flare/screens/welcome.dart';
import 'package:flutter_flare/screens/user.dart';
import '../firebase/fire.dart';
import 'home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String animationType = 'idle';
  String message = "";
  bool obscurePassword = true;
  bool isLoading = false;

  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  final passwordFocusNode = FocusNode();
  final emailFocusNode = FocusNode();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade200,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade200,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> MyApp()),);
          },
        ),
      ),
      body:
      Container(
        padding: EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: 280,
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
              child: Column(
                children: [

                  SignIn(),
                  SizedBox(
                    height: 10,
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: GestureDetector(
                      onTap: () => Navigator.push(context,MaterialPageRoute(builder: (_) => SignUpScreen())),
                      child: Text("Create Account", style: GoogleFonts.caveat(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500,),),
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

  Widget SignIn() {
    return GestureDetector  (
      onTap: () {
        if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
          setState(() {
            isLoading = true;
          });

          logIn(emailController.text, passwordController.text).then((user) async {
            if (user != null) {
              setState(() {
                animationType='hands_down';
                animationType = 'success';
                message= "Login Successfull";
                isLoading = false;
              });
              await Future.delayed(Duration(milliseconds: 1800));
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => UserList()));
            } else {

              setState(() {
                animationType = 'hands_down';
                animationType = 'fail';
                message ="Login Failed";
                isLoading = false;
              });
            }
          });
        } else {
          setState(() {
            animationType = 'fail';
            message = "Enter the credentials";
          });

        }
      },
      child: Container(
          height:  50,
          width:  202,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.blue.shade200,
          ),
          alignment: Alignment.center,
          child: Text(
            "Login",
            style: GoogleFonts.caveat(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          )),
    );
  }
}