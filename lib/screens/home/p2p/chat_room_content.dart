
import 'package:chat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chat_room_tile.dart';

class ChatRoomContent extends StatefulWidget {
  String uId;
  ChatRoomContent({required this.uId});

  @override
  State<ChatRoomContent> createState() => _ChatRoomContentState();
}

class _ChatRoomContentState extends State<ChatRoomContent> {
  Stream<QuerySnapshot>? snap;
  String? myName;
  String? imageUrl;

  @override
  void initState() {

    getMyName().then((value) {
      DatabaseService(uId: widget.uId).streamChatRoom(myName!).then((value) {
        setState(() {
          snap = value;
        });
      });
    });
      super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: snap,
      builder: (context,
          AsyncSnapshot<QuerySnapshot> snapshot){
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context,index) {
              final String messageTo = snapshot.data!.docs[index].get('users')[1] == myName ?
              snapshot.data!.docs[index].get('users')[0] : snapshot.data!.docs[index].get('users')[1];
              return ChatRoomTile(messageTo: messageTo,userName: myName!,userId: widget.uId,);
            }
        ) : const SizedBox();
      },
    );
  }
  Future getMyName() async{
    await DatabaseService(uId: widget.uId).getUserDetails()
        .then((value) {
        DocumentSnapshot temp = value;
        setState(() {
          myName = temp.get('name');
        });
        return myName;
    });
  }

}
