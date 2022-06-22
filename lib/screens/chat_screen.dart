import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatRoom extends StatelessWidget {
  final Map<String, dynamic> userMap;
  final String chatRoomId;

  ChatRoom({required this.chatRoomId, required this.userMap});

  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser!.displayName,
        "message": _message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      _message.clear();
      await _firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .add(messages);
    } else {
      print("Enter Some Text");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue.shade300,size: 28,),
          onPressed: ()=> Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        title: StreamBuilder<DocumentSnapshot>(
          stream:
          _firestore.collection("users").doc(userMap['uid']).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Container(
                child: Column(
                  children: [
                    Text(userMap['name'], style: GoogleFonts.caveat(color: Colors.blue.shade300,fontWeight: FontWeight.w800, fontSize: 28),),
                    Text(userMap['status'], style: GoogleFonts.caveat(color: Colors.blue.shade300,fontWeight: FontWeight.w700, fontSize: 16),),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              height: size.height / 1.22,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chatroom')
                    .doc(chatRoomId)
                    .collection('chats')
                    .orderBy("time", descending: false)
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
            Container(
              color: Colors.blue.shade200,
              height: size.height / 13,
              width: size.width,
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                    width: 10,
                  ),

                  Container(
                    color: Colors.blue.shade200,
                    height: size.height / 16,
                    width: size.width / 1.1,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              color: Colors.blue.shade200,
                              height: size.height / 19,
                              width: size.width / 1.3,
                              child: TextField(
                                controller: _message,
                                style: GoogleFonts.caveat( color: Colors.white,fontWeight: FontWeight.bold, fontSize: 26),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Type your message here",
                                  hintStyle: GoogleFonts.caveat( color: Colors.white,fontWeight: FontWeight.bold, fontSize: 28),
                                ),
                              )
                            ),
                            IconButton(
                                icon: Icon(Icons.send, color: Colors.white,size: 28,), onPressed: onSendMessage),
                          ],

                        ),
                      ],
                    ),

                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    return map['type'] == "text"
        ? Container(
      width: size.width,
      alignment: map['sendby'] == _auth.currentUser!.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.blue.shade200.withOpacity(0.9),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(
              20,
            ),
            topRight: Radius.circular(20,),
            bottomRight: Radius.circular(
                map['sendby'] == _auth.currentUser!.displayName? 0 : 20),
            topLeft: Radius.circular(
                map['sendby'] == _auth.currentUser!.displayName ? 20 : 0),
          ),
        ),
        child: Text(
          map['message'],
          style: GoogleFonts.caveat(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    )
        : Container(
      height: size.height / 2.5,
      width: size.width,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      alignment: map['sendby'] == _auth.currentUser!.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
    );
  }
}



//