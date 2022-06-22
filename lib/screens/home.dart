import 'package:flutter_flare/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flare/screens/user.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  String message ='';
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setStatus("Online");
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus("Online");
    } else {
      setStatus("Offline");
    }
  }
  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
try{
    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("name", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
        message= '';
      });
      print(userMap);
    });}catch(e){
  setState(() {
    message= 'User NOT Found';
  });

    }
  }
  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.blue.shade200,

      appBar: AppBar(
        backgroundColor: Colors.blue.shade200,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> UserList()),);
          },
        ),
        title: Text("Search Users", style: GoogleFonts.caveat(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700,)),
      ),
      body: Column(
        children: [
          SizedBox(
            height: size.height / 38,
          ),
          Row(
            children: [
              Container(
                height: size.height / 14,
                width: size.width,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Container(
                      height: size.height / 16,
                      width: size.width/1.3,
                      child: TextField(
                        cursorColor: Colors.blue.shade200,
                        controller: _search,
                        style: GoogleFonts.caveat( color: Colors.blue.shade300,fontWeight: FontWeight.bold, fontSize: 24),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.white.withOpacity(0.8),
                          filled: true,
                          focusColor: Colors.blue.shade200,

                          hintStyle: GoogleFonts.caveat( color: Colors.blue.shade300,fontWeight: FontWeight.bold, fontSize: 24),

                          suffixIcon: IconButton(
                            icon: Icon(Icons.search, color: Colors.blue.shade200,),
                            onPressed: ()=> onSearch(),
                          ),
                          hintText: "Search username",

                        ),

                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.height / 90,
          ),

          Text(message,style: GoogleFonts.caveat( color: Colors.white,fontWeight: FontWeight.bold, fontSize: 28),),
          SizedBox(
            height: size.height / 90,
          ),
          userMap != null
              ? Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(
                  20,
                ),
                topRight: Radius.circular(20,),
              ),
            ),
                child: ListTile(
            onTap: () {
                String roomId = chatRoomId(
                    _auth.currentUser!.displayName!,
                    userMap!['name']);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ChatRoom(
                      chatRoomId: roomId,
                      userMap: userMap!,
                    ),
                  ),
                );
            },
            leading: Icon(Icons.person, color: Colors.blue.shade300, size: 35,),
            title: Text(
                userMap!['name'],
                style: GoogleFonts.caveat(
                  color: Colors.blue.shade300,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(userMap!['email'],style: GoogleFonts.caveat(
                    color: Colors.blue.shade300,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                ),),
                Text(userMap!['status'],style: GoogleFonts.caveat(
                  color: Colors.blue.shade300,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),),
              ],
            ),
            trailing: Icon(Icons.chat, color: Colors.blue.shade300),
          ),
              )
              : Container(
          ),
        ],
      ),
    );
  }
}