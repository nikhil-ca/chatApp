import 'package:chat/models/auth_user.dart';
import 'package:chat/screens/home/group/search_group.dart';
import 'package:chat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat/screens/home/group/group_chat_content.dart';

class GroupChatRoom extends StatefulWidget {
  const GroupChatRoom({Key? key}) : super(key: key);

  @override
  State<GroupChatRoom> createState() => _GroupChatRoomState();
}

class _GroupChatRoomState extends State<GroupChatRoom> {

  bool showAddSearch = false;
  TextEditingController groupName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Groups',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            fontSize: 30
          ),),
        actions: [
          InkWell(
            onTap: (){
              setState(() {
                showAddSearch = true;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.group_add_outlined,
              color: Colors.deepPurple,),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/chatbg.png'),
                fit: BoxFit.cover
            )
        ),
        child: Column(
          children: [
            showAddSearch ? Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
              child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 5),
                        child: TextField(
                          controller: groupName,
                          decoration: const InputDecoration().
                          copyWith(hintText: 'Group Name...',
                          border: InputBorder.none),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5,),
                    InkWell(
                      onTap: () {
                        if(groupName.text.isNotEmpty) {
                          DatabaseService(uId: currentUser.userId)
                              .createGroupChat(
                              groupName.text);
                          setState(() {
                            groupName.text = '';
                            showAddSearch = false;
                          });
                        }else{
                          setState(() {
                            showAddSearch = false;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),

                          child: const Icon(
                            Icons.arrow_right_alt_rounded
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
            ) : const SizedBox(),
            Container
                (padding: const EdgeInsets.only(top: 5),
                  child: GroupChatContent(uId:currentUser.userId)
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context)=>
                const SearchGroup()
              )
              );
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.person_search_sharp),
      ),
    );
  }
}
