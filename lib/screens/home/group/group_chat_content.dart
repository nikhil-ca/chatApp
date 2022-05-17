
import 'package:chat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat/screens/home/group/group_chat_room_tile.dart';


class GroupChatContent extends StatefulWidget {
  String uId;
  GroupChatContent({required this.uId});

  @override
  State<GroupChatContent> createState() => _GroupChatContentState();
}

class _GroupChatContentState extends State<GroupChatContent> {
  Stream<QuerySnapshot>? snap;
  String? myName;

  @override
  void initState() {
    getMyName().then((value) {
      DatabaseService(uId: widget.uId).streamGroupChatRoom(myName!).then((value) {
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

          shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context,index){
              return GroupChatRoomTile(snapshot: snapshot.data!.docs[index],userName: myName!,userId: widget.uId,);
            }
        ) : Container();
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
