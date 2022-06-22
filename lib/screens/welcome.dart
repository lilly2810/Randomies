import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';
import 'signup.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String animationType = 'idle';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body:
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 1,
          ),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                  width: 50,
                ),
                Text(" W E L C O M E ", style: GoogleFonts.caveat(fontSize: 45, color: Colors.blue.shade300, fontWeight: FontWeight.w900
                ),),
                SizedBox(
                  height: 40,
                  width: 10,
                ),
                Text(" Chat with KITTU \n if not randomies", style: GoogleFonts.caveat(fontSize: 32, color: Colors.blueGrey.withOpacity(0.7), fontWeight: FontWeight.w600
                ),),
                SizedBox(
                  height: 1,
                  width: 90,
                ),
                Container(
                  height: 250,
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
                  child: Column(
                    children: [

                      ElevatedButton(

                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(300, 40),
                          maximumSize: const Size(300, 40),
                          primary: Colors.blue.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()),),
                        child: Text(
                          "Log In",
                          style: GoogleFonts.caveat(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
                        ),
                      ),
                      ElevatedButton(

                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(300, 40),
                          maximumSize: const Size(300, 40),
                          primary: Colors.blue.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUpScreen()),),
                        child: Text(
                          "Create Account",
                          style: GoogleFonts.caveat( color: Colors.white, fontSize: 20,fontWeight: FontWeight.w900),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                        width: 10,
                      ),

                    ],

                  ),),
              ],
            ),
          ),
        )
    );
  }
}
