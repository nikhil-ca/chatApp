import 'package:chat/services/database.dart';
import 'package:flutter/cupertino.dart';

class HelperFunction{

  static Future getChatRoomId(String uId, String messageTo) async{
    String user = await DatabaseService(uId: uId).getUserDetails();
    return DatabaseService(uId: uId).getChatRoomId(user, messageTo);
  }

  static ScrollController controller = ScrollController();
  static setScrollToBottom(){
    controller.animateTo(controller.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
  }

}