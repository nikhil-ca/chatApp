import 'package:chat/screens/home/group/search_user_tile.dart';
import 'package:chat/screens/home/p2p/search_tile.dart';
import 'package:flutter/material.dart';

class SearchUserList extends StatelessWidget {
  String name;
  String email;
  String groupId;


  SearchUserList({required this.name, required this.email,required this.groupId});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 1,
        itemBuilder: (context, index){
          return SearchUserTile(name: name,email: email, groupId: groupId,);
        });
  }
}
