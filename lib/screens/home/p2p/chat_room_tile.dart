import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'package:chat/services/database.dart';

class ChatRoomTile extends StatefulWidget {
  final String messageTo;
  final String userName;
  final String userId;
  ChatRoomTile({required this.messageTo, required this.userName, required this.userId
  });

  @override
  State<ChatRoomTile> createState() => _ChatRoomTileState();
}

class _ChatRoomTileState extends State<ChatRoomTile> {
  String? imageUrl;
  bool isLoading = true;
  @override
  void initState() {
    getImageUrl(widget.messageTo);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print(widget.messageTo);
    return isLoading ? const SizedBox() :InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ChatScreen(messageTo: widget.messageTo, chatRoomId: DatabaseService(uId: widget.userId).getChatRoomId(widget.messageTo, widget.userName),
                userName: widget.userName,uId:widget.userId)
        )
        );
      },
      child: Card(
        color: Colors.white,
        child: ListTile(

          leading:  CircleAvatar(
            backgroundImage: NetworkImage(imageUrl!),
            radius: 20,
          ),
          title: Text(widget.messageTo,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15
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
