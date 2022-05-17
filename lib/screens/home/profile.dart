import 'dart:io';
import 'package:chat/services/auth.dart';
import 'package:chat/services/database.dart';
import 'package:chat/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../shared/constants.dart';

class Profile extends StatefulWidget {
  final String uId;
  Profile({required this.uId});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  String userName = '';
  String email = '';
  String imageUrl = '';
  ImagePicker pickImage = ImagePicker();
  bool loading = true;
  @override
  void initState() {
    getUserDetails();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return loading ? const Loading() : Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/chatbg.png'),
                fit: BoxFit.cover
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          radius: 100,
        ),
          const SizedBox(height: 5,),
          InkWell(
            onTap: () async{
              final XFile? imageFile = await pickImage.pickImage(
                source: ImageSource.gallery,
              );
              File imageFile1 = File(imageFile!.path);
              String url = await DatabaseService(uId: widget.uId).uploadFileAndGetDownloadUrl(imageFile: imageFile1);
              await DatabaseService(uId:widget.uId).updateProfilePic(url);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              child: const Icon(
                Icons.add_a_photo_rounded,
                color: Colors.deepPurple,
              ),
            ),
          ),
            const SizedBox(height: 20,),
            Container(
              padding: const EdgeInsets.fromLTRB(30, 10, 10, 10),
              child: Text('User Name: $userName',
                style: outputTextStyle,
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.fromLTRB(30, 10, 10, 10),
              child: Text('User Name: $email',
                style: outputTextStyle,
              ),
            ),
         ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: (){
          _auth.signOut();
        },
        child: const Icon(Icons.logout,
        color: Colors.deepPurple,),
      ),
    );
  }
  Future getUserDetails() async{
    await DatabaseService(uId: widget.uId).getUserDetails()
        .then((value) {
      DocumentSnapshot temp = value;
      userName = temp.get('name');
      email = temp.get('email');
      imageUrl = temp.get('image');
    });
    loading = false;
    setState(() {
    });
  }
}

