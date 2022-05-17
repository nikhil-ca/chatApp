import 'package:chat/models/auth_user.dart';
import 'package:chat/screens/home/p2p/chat_screen.dart';
import 'package:chat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/loading.dart';

class SearchTile extends StatefulWidget {

  final String name;
  final String email;
  final String imageUrl;
  final String uId;

  SearchTile({required this.name,required this.email, required this.uId, required this.imageUrl});

  @override
  State<SearchTile> createState() => _SearchTileState();
}

class _SearchTileState extends State<SearchTile> {
  bool loading = true;
  String? userName;

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<FirebaseUser>(context);
    return loading ? const Loading() :Card(
      color: Colors.white,
      shadowColor: Colors.deepPurple,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(widget.imageUrl),
          radius: 20,
        ),
        title: Text(widget.name),
        subtitle: Text(widget.email),
        trailing: GestureDetector(
          onTap: ()async{
            DatabaseService(uId: currentUser.userId).createChatRoom(widget.name);
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => ChatScreen(messageTo: widget.name, chatRoomId: DatabaseService(uId: currentUser.userId).getChatRoomId(widget.name, userName!),
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
  Future getUserDetails() async{
    await DatabaseService(uId:widget.uId ).getUserDetails()
        .then((value) {
      DocumentSnapshot temp = value;
      userName = temp.get('name');
      loading = false;
    });
    setState(() {
    });
  }
}
