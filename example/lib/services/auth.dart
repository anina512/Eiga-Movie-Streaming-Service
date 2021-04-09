import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_torrent_streamer_example/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

  class AuthService{

    final FirebaseAuth _auth= FirebaseAuth.instance;
    final GoogleSignIn googleSignIn=GoogleSignIn();

    //create user object based on firebase user
    Users _userFromFirebaseUser(User user){
      return user!=null? Users(uid:user.uid):null;
    }
    // auth change user stream
    Stream <Users> get user{
      return _auth.authStateChanges().map(_userFromFirebaseUser) ;
    }
    //sign in anonymous
    Future signInAnon() async{
      try{
        UserCredential result=await _auth.signInAnonymously();
        User user=result.user;
        return _userFromFirebaseUser(user);
      }catch(e){
        print(e.toString());
        return null;
      }
    }
    //sign email
    Future signInEmail(String email, String password) async{
      try{
        UserCredential result=await _auth.signInWithEmailAndPassword(email: email, password: password);
        User user=result.user;
        return _userFromFirebaseUser(user);
      }
      catch(e){
        print(e.toString());
        return null;
      }
    }
    //register email
    Future registerEmail(String email, String password) async{
      try{
        UserCredential result=await _auth.createUserWithEmailAndPassword(email: email, password: password);
        User user=result.user;
        return _userFromFirebaseUser(user);
      }
      catch(e){
        print(e.toString());
        return null;
      }
    }

    //google sign in
    Future signInGoogle() async{
      await googleSignIn.signOut();
      final GoogleSignInAccount googleSignInAccount=await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication=await googleSignInAccount.authentication;
      final AuthCredential credential=GoogleAuthProvider.credential(
          idToken:googleSignInAuthentication.idToken,
          accessToken:googleSignInAuthentication.accessToken
      );
      try{
        UserCredential result = await _auth.signInWithCredential(credential);
        User user=result.user;
        print(result);

        assert(!user.isAnonymous);
        assert(await user.getIdToken()!=null);

        User currentUser= _auth.currentUser;
        assert(currentUser.uid==user.uid);

        return _userFromFirebaseUser(user);
      }
      catch(e){
        print(e.toString());
        return null;

      }


    }

    //sign out
    Future signOut() async{
      try{
        return await _auth.signOut();
      }
      catch(e){
        print(e.toString());
        return null;
      }
    }





  }