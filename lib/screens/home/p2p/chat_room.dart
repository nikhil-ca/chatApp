
import 'package:chat/models/auth_user.dart';
import 'package:chat/screens/home/p2p/chat_room_content.dart';
import 'package:chat/screens/home/p2p/search.dart';
import 'package:chat/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ChatRoom extends StatefulWidget {


  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  final AuthService _auth = AuthService();
  Stream<QuerySnapshot>? snap;
  @override
  Widget build(BuildContext context) {

    final currentUser = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[50],
        title: const Text('Chats',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            fontSize: 30
          ),),
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>const Search()
              ));
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.search,
              color: Colors.deepPurple,),
            ),
          )
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child:Container
              (padding: const EdgeInsets.only(top: 5),
                child: ChatRoomContent(uId:currentUser.userId)
            ),
            ),
          ],
        ),
      ),
    );
  }
}
