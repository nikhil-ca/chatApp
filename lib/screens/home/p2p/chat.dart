
import 'package:chat/screens/home/p2p/chat_tile.dart';
import 'package:chat/services/database.dart';
import 'package:chat/services/helper_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Chat extends StatefulWidget {
  BuildContext context;
  final String chatRoomId;
  final String myName;
  final String userId;

  Chat({required this.context, required this.chatRoomId,required this.myName,
  required this.userId});

  @override
  State<Chat> createState() => _ChatState();


}

class _ChatState extends State<Chat> {
  Stream<QuerySnapshot>? chats;
  @override
    void initState() {
      DatabaseService(uId:widget.userId).getChats(widget.chatRoomId)
          .then((value) {
        setState(() {
          chats = value;
        });
        print(widget.chatRoomId);
      });
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: chats,
      builder: (context,
          AsyncSnapshot<QuerySnapshot> snapshot) {
        return snapshot.hasData ? ListView.builder(
          controller: HelperFunction.controller,
          itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index){
            print(widget.myName);
            print(snapshot.data!.docs[index].get('sender'));
            return ChatTile(message: snapshot.data!.docs[index].get('message'), sender:widget.myName == snapshot.data!.docs[index].get('sender'), chatRoomId: widget.chatRoomId,);
        }
        )
            : Container();
      }
    );
  }

  Future getUserName(String uId) async{
    return await DatabaseService(uId: uId).getUserDetails();
  }
}
