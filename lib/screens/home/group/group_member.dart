import 'dart:io';
import 'package:chat/models/auth_user.dart';
import 'package:chat/screens/home/group/group_member_list.dart';
import 'package:chat/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../services/database.dart';

class GroupMembers extends StatefulWidget {
  final String groupName;
  GroupMembers({required this.groupName});

  @override
  State<GroupMembers> createState() => _GroupMembersState();
}

class _GroupMembersState extends State<GroupMembers> {

  String? imageUrl;
  bool isLoading = true;
  ImagePicker pickImage = ImagePicker();

  @override
  void initState() {
    getGroupPic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<FirebaseUser>(context);
    return isLoading ? const Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(widget.groupName,
          textAlign: TextAlign.left,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),),
      ),
      body:Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/chatbg.png'),
                fit: BoxFit.cover
            )
        ),
        child: Column(
             children: [
              const SizedBox(height: 10,),
              CircleAvatar(
                backgroundImage: NetworkImage(imageUrl!),
                radius: 100,
              ),
              const SizedBox(height: 5,),
               InkWell(
                 onTap: () async{
                   final XFile? imageFile = await pickImage.pickImage(
                     source: ImageSource.gallery,
                   );
                   File imageFile1 = File(imageFile!.path);
                   String url = await DatabaseService(uId: '').uploadFileAndGetDownloadUrl(imageFile: imageFile1);
                   await DatabaseService(uId:'').updateGroupPic(url, widget.groupName);
                 },
                 child: Container(
                   padding: const EdgeInsets.all(10),
                   child: const Icon(
                     Icons.add_a_photo_rounded,
                     color: Colors.deepPurple,
                   ),
                 ),
               ),
              Flexible(
                child: Container
                  (padding: const EdgeInsets.only(top: 5),
                    child: GroupMemberList(uId: currentUser.userId, groupName: widget.groupName,),
                ),
              ),
            ],
          ),
      ),
    );
  }
  Future getGroupPic() async{
    await DatabaseService(uId:'').searchGroup(widget.groupName).then((value){
      QuerySnapshot snapshot = value;
      imageUrl = snapshot.docs[0].get('image');
      isLoading = false;
      setState(() {});
    });
  }
}
