import 'package:turtle_ninja/models/myuser.dart';
import 'package:turtle_ninja/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

class AuthService {
   final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on User
  MyUser? _userFromUser(User? user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<MyUser?> get user {
    return _auth.authStateChanges().map((User? user) => _userFromUser(user));
  }

  // sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password

  Future signInWithEmailAndPassword(String email,String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user=result.user;
      DataBaseService databaseService=GetIt.I.get<DataBaseService>();
      databaseService.uid=user!.uid;

      return _userFromUser(user);


    }catch(e){
      print(e);
      return null;

    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(String email,String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user=result.user;

      //create a new settings document for the user with the uid
      DataBaseService databaseService=GetIt.I.get<DataBaseService>();
      databaseService.uid=user!.uid;

      return _userFromUser(user);


    }catch(e){
      print(e);
      return null;

    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
