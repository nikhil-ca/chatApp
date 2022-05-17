import 'package:chat/services/helper_function.dart';
import 'package:chat/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat/services/database.dart';
import 'package:chat/screens/home/group/group_chat_screen.dart';

class GroupChatRoomTile extends StatelessWidget {
  final DocumentSnapshot snapshot;
  final String userName;
  final String userId;
  GroupChatRoomTile({required this.snapshot, required this.userName, required this.userId
  });

  @override
  Widget build(BuildContext context) {
    final String groupName = snapshot.get('groupId');
    final String imageUrl = snapshot.get('image');
    return imageUrl.isEmpty ? const Loading() : InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => GroupChatScreen(groupName:groupName, userName: userName,uId:userId)
        )
        );
      },
      child: Card(
        color: Colors.white,
        child: ListTile(

          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          title: Text(groupName,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 17,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}
