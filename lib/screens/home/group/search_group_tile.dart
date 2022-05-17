import 'package:chat/models/auth_user.dart';

import 'package:chat/services/database.dart';
import 'package:chat/screens/home/group/group_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchGroupTile extends StatefulWidget {

  final String name;

  SearchGroupTile({required this.name});

  @override
  State<SearchGroupTile> createState() => _SearchGroupTileState();
}

class _SearchGroupTileState extends State<SearchGroupTile> {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<FirebaseUser>(context);
    String? userName;
    DocumentSnapshot? snap;

    return Card(
      color: Colors.white,
      shadowColor: Colors.deepPurple,
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.deepPurple,
        ),
        title: Text(widget.name),
        trailing: GestureDetector(
          onTap: ()async{
            await DatabaseService(uId: currentUser.userId).getUserDetails().then(
                    (value) {
                  setState(() => snap = value);
                });
            setState(() => userName = snap?.get('name'));
            DatabaseService(uId: currentUser.userId).addNewMemberToChat(widget.name, userName!);
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => GroupChatScreen(groupName: widget.name,
                    userName: userName!,uId:currentUser.userId)
            ));
          },
          child: Container(
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.messenger_rounded)
          ),
        ),
      ),
    );
  }
}
