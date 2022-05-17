import 'package:chat/models/auth_user.dart';
import 'package:chat/screens/home/group/search_user_list.dart';
import 'package:chat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SearchUser extends StatefulWidget {
  final String groupId;

  SearchUser({required this.groupId});

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  TextEditingController searchController = TextEditingController();
  QuerySnapshot? searchSnapshot;
  String name = '';
  String email = '';
  bool empty = true;

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<FirebaseUser>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              color: Colors.deepPurple,
              child: Row(
                  children :[
                    Expanded(
                        child: TextField(
                          autofocus: true,
                          controller: searchController,
                          decoration: const InputDecoration(
                              hintText: 'username',
                              hintStyle: TextStyle(color: Colors.white54),
                              border: InputBorder.none
                          ),
                        )
                    ),
                    GestureDetector(
                      onTap: () {
                        DatabaseService(uId: currentUser.userId).searchUser(searchController.text).then((value){

                          setState(() => searchSnapshot = value);
                          print(searchSnapshot);
                          empty = searchSnapshot!.docs.isEmpty;
                          if(!empty) {
                            name = searchSnapshot?.docs[0].get('name');
                            email = searchSnapshot?.docs[0].get('email');
                          }
                          searchController.text = '';
                          setState(() {
                          });
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFD1C4E9),
                                  Color(0xFF9575CD)
                                ]
                            ),
                            borderRadius: BorderRadius.circular(40)
                        ),
                        child: const Icon(Icons.search_sharp,
                          color: Colors.white,),
                      ),
                    )
                  ]
              ),
            ),
            searchSnapshot == null ? const SizedBox() : empty ? const Card(
              color: Colors.white,
              shadowColor: Colors.deepPurple,
              child: Text('User not found (UserName is case sensitive)',
                style: TextStyle(
                    color: Colors.red
                ),
              ),
            )
                : SearchUserList(name: name, email: email, groupId: widget.groupId),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
