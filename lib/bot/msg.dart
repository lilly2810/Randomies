import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessagesScreen extends StatefulWidget {
  final List messages;
  const MessagesScreen({Key? key, required this.messages}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return ListView.separated(
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: widget.messages[index]['isUserMessage']
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(
                            20,
                          ),
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(
                              widget.messages[index]['isUserMessage'] ? 0 : 20),
                          topLeft: Radius.circular(
                              widget.messages[index]['isUserMessage'] ? 20 : 0),
                        ),
                        color: widget.messages[index]['isUserMessage']
                            ? Colors.blue.shade200.withOpacity(0.9)
                            : Colors.blue.shade200.withOpacity(0.9)),
                    constraints: BoxConstraints(maxWidth: w * 2 / 3),
                    child:
                    Text(widget.messages[index]['message'].text.text[0],style: GoogleFonts.caveat(fontWeight: FontWeight.w800,color: Colors.white, fontSize: 25,)), ),
              ],
            ),
          );
        },
        separatorBuilder: (_, i) => Padding(padding:EdgeInsets.only(top: 0)),
        itemCount: widget.messages.length);
  }
}