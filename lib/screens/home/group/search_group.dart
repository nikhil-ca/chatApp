
import 'package:chat/screens/home/group/group_list.dart';
import 'package:chat/services/database.dart';
import 'package:chat/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat/screens/home/group/search_group.dart';


class SearchGroup extends StatefulWidget {
  const SearchGroup({Key? key}) : super(key: key);

  @override
  State<SearchGroup> createState() => _SearchGroupState();
}

class _SearchGroupState extends State<SearchGroup> {
  TextEditingController searchController = TextEditingController();
  QuerySnapshot? searchSnapshot;
  String groupName = '';
  bool empty = true;

  @override
  Widget build(BuildContext context) {
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
                            autofocus: true,
                            controller: searchController,
                            decoration: const InputDecoration(
                                hintText: 'group name...',
                                hintStyle: TextStyle(color: Colors.white54),
                                border: InputBorder.none
                            ),
                          )
                      ),
                      GestureDetector(
                        onTap: () {
                          DatabaseService(uId: '').searchGroup(searchController.text).then((value){

                            setState(() => searchSnapshot = value);
                            empty = searchSnapshot!.docs.isEmpty;
                            if(!empty) {
                              groupName = searchSnapshot?.docs[0].get('groupId');
                            }
                            setState(() {});
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
              searchSnapshot == null ?  Container(color: Colors.white,) : empty ? const Card(
                color: Colors.white,
                shadowColor: Colors.deepPurple,
                child: Text('Group not found (Group name is case sensitive)',
                  style: TextStyle(
                      color: Colors.red
                  ),
                ),
              )
              : GroupList(groupName: groupName),
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
