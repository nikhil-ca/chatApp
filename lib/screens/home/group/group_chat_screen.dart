import 'package:chat/models/auth_user.dart';
import 'package:chat/screens/home/group/group_chat.dart';
import 'package:chat/screens/home/group/group_member.dart';
import 'package:chat/screens/home/group/search_user.dart';
import 'package:chat/services/database.dart';
import 'package:chat/services/helper_function.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupChatScreen extends StatefulWidget {

  final String groupName;
  final String userName;
  final String uId;

  GroupChatScreen({required this.groupName,required this.userName,
    required this.uId});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {

  Stream <QuerySnapshot>? chats;
  String? imageUrl;
  bool isLoading = true;
  TextEditingController message = TextEditingController();

  @override
  void initState() {
    getGroupPic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final currentUser = Provider.of<FirebaseUser>(context);
    final double screenHeight = MediaQuery.of(context).size.height;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return isLoading ? const Loading() : Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Row(
          children: [
            Expanded(
                child: InkWell(
                  onTap: ()=> Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    child:
                    const Icon(Icons.arrow_back_sharp),
                  ),
                )),
            const SizedBox(width: 5,),
            Expanded(
              child: CircleAvatar(
                backgroundImage: NetworkImage(imageUrl!),
              ),
            ),
          ],
        ),
        title: InkWell(
          onTap: (){
            Navigator.push(context,
                MaterialPageRoute(builder:
                (context) => GroupMembers(groupName: widget.groupName)));
          },
            child: Container(
              padding: const EdgeInsets.all(5),
                child: Text(widget.groupName)
            )
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder:
                  (context) => SearchUser(groupId: widget.groupName)
                  )
              );
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.person_add_outlined),
            ),
          ),
          InkWell(
            onTap: (){
              DatabaseService(uId: currentUser.userId).removeMemberFromChat(widget.groupName, widget.userName);
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              child:Row(
                children: const [
                  Text('exit-group'),
                  SizedBox(width: 3,),
                  Icon(Icons.exit_to_app_rounded),
                ],
              ),
            ),
          )
        ],
      ),
      body: Container(
        height: screenHeight - keyboardHeight,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/chatbg.png'),
                fit: BoxFit.cover
            )
        ),
        child: Column(
          children: [
            Flexible(
              child: GroupChat(context: context,groupName: widget.groupName, myName: widget.userName, userId: currentUser.userId,),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.fromLTRB(5,0, 5, 10),
                width: MediaQuery.of(context)
                    .size
                    .width,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                  decoration: BoxDecoration(
                      color: Colors.deepPurple[200],
                      borderRadius: BorderRadius.circular(50)
                  ),
                  child: SingleChildScrollView(
                    child: Row(
                      children: [
                        const SizedBox(width: 10,),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 10),
                            decoration:  BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50)
                            ),
                            child: TextField(
                              controller: message,
                              decoration:const InputDecoration().copyWith(
                                  hintText: 'message...',
                                  border: InputBorder.none
                              ),

                            ),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        GestureDetector(
                            onTap: (){
                              if(message.text.isNotEmpty) {
                                HelperFunction.setScrollToBottom();
                                DatabaseService(uId: currentUser.userId)
                                    .addGroupChat(
                                    widget.groupName, widget.userName,
                                    message.text);
                                setState(() {
                                  message.text = '';
                                });
                              }
                            },
                            child:   Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.deepPurple[600]
                              ),
                              child: const Icon(
                                Icons.send_outlined,
                                color: Colors.white,
                              ),
                            )
                        ),
                        const SizedBox(width: 10,)
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Future getGroupPic() async{
    await DatabaseService(uId:widget.uId).searchGroup(widget.groupName).then((value){
      QuerySnapshot snapshot = value;
      imageUrl = snapshot.docs[0].get('image');
      isLoading = false;
      setState(() {});
    });
  }

}
