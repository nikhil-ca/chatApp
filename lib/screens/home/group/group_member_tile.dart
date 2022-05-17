import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat/services/database.dart';

import '../p2p/chat_screen.dart';

class GroupMemberTile extends StatefulWidget {
  final String snapshot;
  final String userName;
  final String userId;
  GroupMemberTile({required this.snapshot, required this.userName, required this.userId
  });

  @override
  State<GroupMemberTile> createState() => _GroupMemberTileState();
}

class _GroupMemberTileState extends State<GroupMemberTile> {
  String? imageUrl;
  bool isLoading = true;

  @override
  void initState() {
    getImageUrl(widget.snapshot);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? const SizedBox(): InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ChatScreen(messageTo: widget.snapshot, chatRoomId: DatabaseService(uId: widget.userId).getChatRoomId(widget.snapshot, widget.userName),
                userName: widget.userName,uId:widget.userId)
        )
        );
      },
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl!),
          ),
          title: Text(widget.snapshot,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 20
            ),
          ),
        ),
      ),
    );
  }

  Future getImageUrl(String messageTo) async{
    await DatabaseService(uId: widget.userId).searchUser(messageTo)
        .then((value) {
      QuerySnapshot temp = value;
      setState(() {
        isLoading = false;
        imageUrl = temp.docs[0].get('image');
      });
    });
  }
}
