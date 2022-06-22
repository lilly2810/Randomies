import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flare/screens/home.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bot/bot.dart';
import 'chat_screen.dart';
import '../firebase/fire.dart';

class UserList extends StatefulWidget {
  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> with WidgetsBindingObserver{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Map<String, dynamic>? userMap;

  bool isLoading = false;

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

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Bott()),);},
        child: Column(
          children: [
            Icon(Icons.person, color: Colors.blue.shade300,),
            Text("kittu", style: GoogleFonts.caveat(fontSize: 18,fontWeight: FontWeight.w600 ,color: Colors.blue.shade300),)
          ],
        ),
      ),
      backgroundColor: Colors.blue.shade200,
      appBar: AppBar(
        elevation: 2.0,
        backgroundColor: Colors.blue.shade200,
        leading: IconButton(
          icon: Icon(Icons.search),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()),);
          },
        ),
        title: Text("Users", style: GoogleFonts.caveat(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700,)),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: () => logOut(context))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
              width: 10,
            ),
            Container(
              height: size.height / 1.25,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('users')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        return messages(size, map, context);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    return Container(
      width: size.width,
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
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
                map['name']);

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ChatRoom(
                  chatRoomId: roomId,
                  userMap: map,
                ),
              ),
            );
          },
          leading: Icon(Icons.person, color: Colors.blue.shade300, size: 35,),
          title: Text(
            map['name'],
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
              Text(map['email'],style: GoogleFonts.caveat(
                color: Colors.blue.shade300,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),),
              Text(map['status'],style: GoogleFonts.caveat(
                color: Colors.blue.shade300,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),),
            ],
          ),
          trailing: Icon(Icons.chat, color: Colors.blue.shade300),
        )
      ),
    );

  }
}



//