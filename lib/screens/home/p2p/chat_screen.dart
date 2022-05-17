import 'package:chat/models/auth_user.dart';
import 'package:chat/screens/home/p2p/chat.dart';
import 'package:chat/services/database.dart';
import 'package:chat/services/helper_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/loading.dart';

class ChatScreen extends StatefulWidget {

  final String messageTo;
  final String chatRoomId;
  final String userName;
  final String uId;

  ChatScreen({required this.messageTo,required this.chatRoomId,required this.userName,
  required this.uId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  Stream <QuerySnapshot>? chats;
  String? imageUrl;
  bool isLoading = true;
  TextEditingController message = TextEditingController();

  @override
  void initState() {
    getImageUrl(widget.messageTo);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    final currentUser = Provider.of<FirebaseUser>(context);
        return isLoading ? const Loading() :Scaffold(
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
            title: Text(widget.messageTo),
            backgroundColor: Colors.deepPurple,
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
                Flexible(
                    child: Chat(context: context,chatRoomId: widget.chatRoomId, myName: widget.userName, userId: currentUser.userId,)
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
                                  decoration: const InputDecoration().copyWith(
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
                                      .addChat(
                                      widget.chatRoomId, widget.userName,
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
                                    color: Colors.deepPurple
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
  Future getImageUrl(String messageTo) async{
    await DatabaseService(uId: widget.uId).searchUser(messageTo)
        .then((value) {
      QuerySnapshot temp = value;
      setState(() {
        isLoading = false;
        imageUrl = temp.docs[0].get('image');
      });
    });
  }

}
