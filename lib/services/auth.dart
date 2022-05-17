import 'package:chat/models/auth_user.dart';
import 'package:chat/services/database.dart';
import 'package:chat/services/encryption_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;


  //function to get UserId
  FirebaseUser _getUserId(User? user) {

    return user != null ? FirebaseUser(userId:user.uid) : null as FirebaseUser;
  }

  Stream <FirebaseUser> get user{

    return _auth.authStateChanges().map((User?user) => _getUserId(user!));
  }

  //method to sign in email
  Future signInWithEmailAndPassword (email, password) async{

    try{

      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password:EncryptionService().encrypt(password));
      User user = result.user as User;
      return _getUserId(user);
    }catch(e){
      return null;
    }
  }

  //method to register with email
  Future registerWithEmailAndPassword(userName,email, password) async{

    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: EncryptionService().encrypt(password));
      User user = result.user as User;
      DatabaseService(uId:user.uid).uploadUserInfo(userName, email);
      DatabaseService(uId: user.uid).addNewMemberToChat('One for All', userName);
      return _getUserId(user);

    }catch(e){
      return null;
    }
  }

  //sign out
  Future signOut() async{

    try{
      return await _auth.signOut();

    }
    catch(e){
      rethrow;
    }
  }
}