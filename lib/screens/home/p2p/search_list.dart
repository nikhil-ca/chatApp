import 'package:chat/models/auth_user.dart';
import 'package:chat/screens/home/p2p/search_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchList extends StatelessWidget {
  String name;
  String email;
  String imageUrl;
  bool loading = true;


  SearchList({required this.name, required this.email, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<FirebaseUser>(context);
    return ListView.builder(
      shrinkWrap: true,
        itemCount: 1,
        itemBuilder: (context, index){
        return SearchTile(name: name,email: email, uId:currentUser.userId, imageUrl: imageUrl,);
      });
  }
}
