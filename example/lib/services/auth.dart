import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_torrent_streamer_example/models/user.dart';
import 'package:flutter_torrent_streamer_example/screens/authenticate/mobile.dart';
import 'package:google_sign_in/google_sign_in.dart';

Users custom_user;
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
        custom_user =  _userFromFirebaseUser(user);
        return custom_user;
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
        custom_user =  _userFromFirebaseUser(user);
        print("custom_user: "+custom_user.uid);
        return custom_user;
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
        custom_user =  _userFromFirebaseUser(user);
        custom_user.firstTimeLogin = true;
        return custom_user;
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


        assert(!user.isAnonymous);
        assert(await user.getIdToken()!=null);

        User currentUser= _auth.currentUser;
        assert(currentUser.uid==user.uid);

        custom_user =  _userFromFirebaseUser(user);
        if(result.additionalUserInfo.isNewUser)
        {
          custom_user.firstTimeLogin = true;
        }
        print(result);
        print(custom_user.firstTimeLogin);
        return custom_user;
      }
      catch(e){
        print(e.toString());
        return null;

      }
    }
    Future mobileAuth(String phoneNumber, String verificationId,String otp) async{

       PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp);
      try{
        UserCredential result=await _auth.signInWithCredential(phoneAuthCredential);
        User user=result.user;
        custom_user =  _userFromFirebaseUser(user);
        return custom_user;
      }
      catch(e){
        print(e.toString());
        return null;
      }
    }
    //sign out
    Future signOut() async{
      try{
        if(custom_user.firstTimeLogin==true)
          {
            custom_user.firstTimeLogin = false;
          }
        print("signed out");
        print(_auth.signOut().toString());
        return await _auth.signOut();
      }
      catch(e){
        print(e.toString());
        return null;
      }
    }





  }