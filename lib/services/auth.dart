import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based in FireBaseUser or User
  CustomUser _userFromFirebaseUser(User user) {
    return user != null ? CustomUser(uid:user.uid) : null ;
  }

  // auth change user stream
  Stream<CustomUser> get user {
    return _auth.authStateChanges()
        //.map((User user)=> _userFromFirebaseUser(user));
      .map(_userFromFirebaseUser); // same as line above , easier way
                                  // the user is implied here to pass
  }


  // sign in anonymously
  Future signInAnon() async {
    try {
      // AuthResult
      UserCredential result = await _auth.signInAnonymously();
      // FirebaseUser
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
        print(e.toString());
        return null;
    }
  } 

  // sign in with email and password
  Future signInWithEmailAndPassword(String email,String password) async {
    try {
      // AuthResult
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      // FirebaseUser
      User user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email,String password) async {
    try {
      // AuthResult
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      // FirebaseUser
      User user = result.user;

      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData('0', 'new crew member', 100);

      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
      try{
        return await _auth.signOut();
      } catch (e) {
        print(e.toString());
        return null;
      }
}
}