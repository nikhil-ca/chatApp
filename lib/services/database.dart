
import 'package:chat/services/encryption_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService{

  final String uId;
  final CollectionReference users = FirebaseFirestore.instance.collection('users');
  final CollectionReference chatRoom = FirebaseFirestore.instance.collection('chatRoom');
  final CollectionReference groupChat = FirebaseFirestore.instance.collection('groupChat');
  final CollectionReference allUsers = FirebaseFirestore.instance.collection('allUsers');
  final CollectionReference allGroups = FirebaseFirestore.instance.collection('allGroups');
  final CollectionReference activeMembers = FirebaseFirestore.instance.collection('activeMembers');
  final FirebaseStorage storage = FirebaseStorage.instance;

  DatabaseService({required this.uId});

  //Search for user by their username
  Future searchUser(String userName) async{
    return await users.where('name', isEqualTo: userName).get();
  }
  Future checkUser(String userName) async{
    QuerySnapshot snap = await users.where('name', isEqualTo: userName).get();
    if (snap.docs.isEmpty){
      return false;
    }else{
      return true;
    }
  }

  //Searching for a group Name
  Future searchGroup(String groupId) async{
    return await groupChat.where('groupId', isEqualTo: groupId).get();
  }

  //Upload user details during registration
  Future uploadUserInfo(String name, String email) async{
    return await users.doc(uId).set(
        {
          'name': name,
          'email': email,
          'image':'https://firebasestorage.googleapis.com/v0/b/chatapp-71927.appspot.com/o/profilePic%2Fdefault.jpg?alt=media&token=67e2a25a-3d40-4dbc-a168-eadc91f98bbe'
        });
  }
  //Adding registered userName to allUsers array
  Future addInAllUsers(String uid) async{
    DocumentSnapshot snapshot = await getUserDetails();
    String userName = snapshot.get('name');
    var list = [userName];
    return await allUsers.doc('users').update({'users': FieldValue.arrayUnion(list)});
  }

  Future getUserDetails() async{
    return await users.doc(uId).get();

  }

  //Creating a chat group
  Future createGroupChat(String groupId) async{
    DocumentSnapshot snap = await getUserDetails();
    String user = snap.get('name');
    return await groupChat.doc(groupId).set({
      'groupId': groupId,
      'users':[user],
      'image': 'https://firebasestorage.googleapis.com/v0/b/chatapp-71927.appspot.com/o/profilePic%2Fgroup_default.png?alt=media&token=b6dbad6a-e663-41fd-89ce-4ba9b4796824'
    });
  }
  //Adding new members to the group
  Future addNewMemberToChat(String groupId,String member)async{
    var list = [member];
    print(groupId);
    print(list);
    return await groupChat.doc(groupId).update({'users': FieldValue.arrayUnion(list)});
  }

  //Exiting from a group
  Future removeMemberFromChat(String groupId, String member) async{
    var list = [member];
    return await groupChat.doc(groupId).update({'users': FieldValue.arrayRemove(list)});
  }


  //Creating a chatroom
  Future createChatRoom(String name) async{
    DocumentSnapshot snap = await getUserDetails();
    String user = snap.get('name');
    String chatId = getChatRoomId(user, name);
    return await chatRoom.doc(chatId).set({
      'chatId': chatId,
      'users':[user, name]
    });
  }


  //Chat screen
  Future addChat(String chatRoomId, String name, String message) async{
    return await chatRoom.doc(chatRoomId).collection('chat')
        .add({
      'sender': name,
      'message': EncryptionService().encrypt(message),
      'time': DateTime.now().microsecondsSinceEpoch
    });
  }
  //add Group Chats
  Future addGroupChat(String groupId, String name, String message) async{
    return await groupChat.doc(groupId).collection('chat')
        .add({
      'sender': name,
      'message': EncryptionService().encrypt(message),
      'time': DateTime.now().microsecondsSinceEpoch
    });
  }

  //get Group Chats
  Future getGroupChats(String groupId) async{
    return groupChat.doc(groupId).collection('chat')
        .orderBy('time').snapshots();
  }
  //get chats
  Future getChats(String chatRoomId) async{
    return chatRoom.doc(chatRoomId).collection('chat')
        .orderBy('time').snapshots();
  }

  //stream chatroom details
  Future streamChatRoom(String myName) async{
    return chatRoom.where('users', arrayContains: myName)
        .snapshots();
  }
  //stream group chat credentials
  Future streamGroupCred(String groupId) async{
    return groupChat.where('groupId', isEqualTo: groupId).snapshots();
  }
  //stream group chat room detail
  Future streamGroupChatRoom(String myName) async{
    return groupChat.where('users', arrayContains: myName)
        .snapshots();
  }
  //Streaming all registered email-ids
  Future<bool> checkRegisteredEmailIds(String email) async{
    final result = await activeMembers.where('emailId', isEqualTo: email)
        .get();
    return result.docs.isNotEmpty;
  }

  //Streaming all registered userNames
  Future isUserNameAvailable(String userName) async{
    final result = await users.where('name', isEqualTo: userName).get();
    return result.docs.isEmpty;
  }

  //Streaming all registered groupNames
  Future streamRegisteredGroupNames() async{
    return allGroups.snapshots();
  }

  //setting ChatRoom Id
  String getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  //Uploading image to Firebase Storage and storing the URL in the firestore Database
  Future<String> uploadFileAndGetDownloadUrl({
    required  imageFile,
  }) async {
    final String name =imageFile.path;
    final value = await storage
        .ref('profilePic/$uId$name')
        .putData(imageFile.readAsBytesSync())
        .catchError((err) {
      throw(err);
    });
    return value.ref.getDownloadURL();
  }

  Future updateProfilePic( imageFile) async{
    return await users.doc(uId).update({'image': imageFile});
  }

  Future updateGroupPic( imageFile, String groupId) async{
    return await groupChat.doc(groupId).update({'image': imageFile});
  }

}