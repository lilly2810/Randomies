import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flare/screens/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'msg.dart';
import '../screens/home.dart';

class Bott extends StatefulWidget {
  const Bott({Key? key}) : super(key: key);

  @override
  _BottState createState() => _BottState();
}

class _BottState extends State<Bott> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.blue.shade200,size: 28,),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> UserList()),);
          },
        ),
        elevation: 10.0,
        title: Column(
          children: [
            Text('KITTU', style: GoogleFonts.caveat(color: Colors.blue.shade300, fontWeight: FontWeight.w900),),
        Text('Chat Bot', style: GoogleFonts.caveat(color: Colors.blue.shade300, fontWeight: FontWeight.w600,fontSize: 16),),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [

            Expanded(child: MessagesScreen(messages: messages)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              color: Colors.blue.shade200,
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: _controller,
                        style: GoogleFonts.caveat( color: Colors.white,fontWeight: FontWeight.bold, fontSize: 24),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type your message here",
                          hintStyle:GoogleFonts.caveat( color: Colors.white,fontWeight: FontWeight.bold, fontSize: 26),
                        ),
                      )),
                  IconButton(
                      onPressed: () {
                        sendMessage(_controller.text);
                        _controller.clear();
                      },
                      icon: Icon(Icons.send, color: Colors.white,))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  sendMessage(String text) async {
    if (text.isEmpty) {
      print('Message is empty');
    } else {
      setState(() {
        addMessage(Message(text: DialogText(text: [text])), true);
      });

      DetectIntentResponse response = await dialogFlowtter.detectIntent(
          queryInput: QueryInput(text: TextInput(text: text)));
      if (response.message == null) return;
      setState(() {
        addMessage(response.message!);
      });
    }
  }

  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
  }
}