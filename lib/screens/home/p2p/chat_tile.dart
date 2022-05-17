import 'package:chat/services/encryption_service.dart';
import 'package:chat/shared/constants.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final dynamic message;
  final bool sender;
  final String chatRoomId;

  ChatTile({required this.message, required this.sender, required this.chatRoomId});

  @override
  Widget build(BuildContext context) {

    print(sender);
    return Container(
      padding: sender ? const EdgeInsets.fromLTRB(30, 10, 10,5):
      const EdgeInsets.fromLTRB(10, 10, 30, 5),
      alignment: sender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFF673AB7),
          borderRadius: sender ? const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
            bottomLeft: Radius.circular(25)
          )
              : const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
            bottomRight: Radius.circular(25),
          )
        ),
        child: Text(EncryptionService().decrypt(message),
          style: inputTextStyle,
          ),

      ),
    );
  }
}
