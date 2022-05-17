
import 'package:chat/services/database.dart';
import 'package:chat/services/helper_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat/screens/home/group/group_chat_tile.dart';

class GroupChat extends StatefulWidget {
  BuildContext context;
  final String groupName;
  final String myName;
  final String userId;

  GroupChat({required this.context, required this.groupName,required this.myName,
    required this.userId});

  @override
  State<GroupChat> createState() => _GroupChatState();


}

class _GroupChatState extends State<GroupChat> {

  Stream<QuerySnapshot>? chats;
  @override
  void initState() {
    DatabaseService(uId:widget.userId).getGroupChats(widget.groupName)
        .then((value) {
      setState(() {
        chats = value;
      });
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
                return GroupChatTile(message: snapshot.data!.docs[index].get('message'), isSenderMe:widget.myName == snapshot.data!.docs[index].get('sender'), groupId: widget.groupName,sender:snapshot.data!.docs[index].get('sender'));
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
