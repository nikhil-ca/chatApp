
import 'package:chat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'group_member_tile.dart';

class GroupMemberList extends StatefulWidget {
  final String uId;
  final String groupName;
  GroupMemberList({required this.uId, required this.groupName});

  @override
  State<GroupMemberList> createState() => _GroupMemberListState();
}

class _GroupMemberListState extends State<GroupMemberList> {
  Stream<QuerySnapshot>? snap;
  String? myName;
  List<String>? groupMembers;

  @override
  void initState() {
    // TODO: implement initState

    getMyName().then((value) {
      DatabaseService(uId: widget.uId).streamGroupCred(widget.groupName).then((value) {
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
            itemCount: List.from(snapshot.data!.docs[0].get('users')).length,
            itemBuilder: (context,index){
              return GroupMemberTile(snapshot: List.from(snapshot.data!.docs[0].get('users'))[index],userName: myName!,userId: widget.uId,);
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
