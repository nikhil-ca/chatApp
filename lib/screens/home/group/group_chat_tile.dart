import 'package:chat/services/encryption_service.dart';
import 'package:chat/shared/constants.dart';
import 'package:flutter/material.dart';

class GroupChatTile extends StatelessWidget {
  final dynamic message;
  final bool isSenderMe;
  final String groupId;
  final String sender;

  GroupChatTile({required this.message, required this.isSenderMe, required this.groupId, required this.sender});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: isSenderMe ? const EdgeInsets.fromLTRB(30, 10, 10,5):
      const EdgeInsets.fromLTRB(10, 10, 30, 5),
      alignment: isSenderMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        decoration: BoxDecoration(
            color: const Color(0xFF673ab7),
            borderRadius: isSenderMe ? const BorderRadius.only(
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
        child: Column(
          children: [
            Text(sender,
            style: inputTextStyle.copyWith(
              fontSize: 14,
              color: Colors.white
            ),
            ),
            const SizedBox(height: 5,),
            Text(EncryptionService().decrypt(message),
              style: inputTextStyle.copyWith(
                fontSize: 12
              ),
            ),
          ],
        ),

      ),
    );
  }
}
