
import 'package:chat/screens/home/group/search_group_tile.dart';
import 'package:flutter/material.dart';

class GroupList extends StatelessWidget {
  String groupName;
  bool loading = true;

  GroupList({required this.groupName,});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 1,
        itemBuilder: (context, index){
          return SearchGroupTile(name: groupName);
        });
  }
}
