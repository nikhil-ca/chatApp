import 'package:chat/models/auth_user.dart';
import 'package:chat/screens/home/p2p/search_list.dart';
import 'package:chat/services/database.dart';
import 'package:chat/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  QuerySnapshot? searchSnapshot;
  String name = '';
  String email = '';
  String imageUrl = '';
  bool empty = false;

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<FirebaseUser>(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/chatbg.png'),
                  fit: BoxFit.cover
              )
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                color: Colors.deepPurple,
                child: Row(
                      children :[
                        Expanded(
                            child: TextField(
                              controller: searchController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'username',
                                hintStyle: TextStyle(color: Colors.white54),
                                border: InputBorder.none,
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
                                imageUrl = searchSnapshot?.docs[0].get('image');
                              }
                              searchController.text = '';
                              setState(() {
                              });
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: buttonStyle,
                            child: const Icon(Icons.search_sharp,
                            color: Colors.white,),
                          ),
                        )
                      ]
                    ),
              ),
              searchSnapshot == null ? const SizedBox(): empty ? const Card(
                color: Colors.white,
                shadowColor: Colors.deepPurple,
                child: Text('User not found (UserName is case sensitive)',
                style: TextStyle(
                  color: Colors.red
                ),
                ),
              )
                  : SearchList(name: name,email: email,imageUrl:imageUrl),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: (){
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back_sharp),
      ),
    );
  }
}
