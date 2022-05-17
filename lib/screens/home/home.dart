import 'package:chat/screens/home/group/group_chat_room.dart';
import 'package:chat/screens/home/p2p/chat_room.dart';
import 'package:chat/screens/home/profile.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String uId;
  Home({required this.uId});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      ChatRoom(),
      const GroupChatRoom(),
      Profile(uId: widget.uId)
    ];
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/chatbg.png'),
                  fit: BoxFit.cover
              )
          ),
          child: screens[currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        currentIndex: currentIndex,
        onTap: (index) => setState(() =>
          currentIndex = index
        ),
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.black26,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outlined),
              label: 'Chat'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.group_outlined),
              label: 'Group'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Profile'
          )
        ],
      ),
    );
  }
}
