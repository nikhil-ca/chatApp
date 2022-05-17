import 'package:chat/models/auth_user.dart';
import 'package:chat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchUserTile extends StatefulWidget {

  final String name;
  final String groupId;
  final String email;

  SearchUserTile({required this.name,required this.groupId,required this.email});

  @override
  State<SearchUserTile> createState() => _SearchUserTileState();
}

class _SearchUserTileState extends State<SearchUserTile> {
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
        subtitle: Text(widget.email),
        trailing: GestureDetector(
          onTap: ()async{
            await DatabaseService(uId: currentUser.userId).getUserDetails().then(
                    (value) {
                  setState(() => snap = value);
                });
            setState(() => userName = snap?.get('name'));
            DatabaseService(uId: currentUser.userId).addNewMemberToChat(widget.groupId, widget.name);
            Navigator.pop(context);
          },
          child: Container(
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.person_add_alt_1_sharp)
          ),
        ),
      ),
    );
  }
}
