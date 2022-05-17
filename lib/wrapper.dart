import 'package:chat/models/auth_user.dart';
import 'package:chat/screens/authenticate/authenticate.dart';
import 'package:chat/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<FirebaseUser?>(context);
    if(user == null){
      return const Authenticate();
    }else{
      return Home(uId:user.userId);
    }
  }
}
