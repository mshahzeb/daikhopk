import 'package:daikhopk/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daikhopk/utils/webservice.dart';
import '../constants.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String uid;
String name;
String userEmail;
String imageUrl;
String accountType;

/// For checking if the user is already signed into the
/// app using Google Sign In
Future getUser() async {
  await Firebase.initializeApp();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool authSignedIn = prefs.getBool('auth') ?? false;

  final User user = _auth.currentUser;

  if (authSignedIn == true) {
    if (user != null) {
      uid = user.uid;
      name = user.displayName;
      userEmail = user.email;
      imageUrl = user.photoURL;
    }
  }
}

Future<String> signInWithGoogle() async {
  await Firebase.initializeApp();

  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential userCredential =
      await _auth.signInWithCredential(credential);
  final User user = userCredential.user;

  if (user != null) {
    // Checking if email and name is null
    assert(user.uid != null);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoURL != null);

    uid = user.uid;
    name = user.displayName;
    userEmail = user.email;
    imageUrl = user.photoURL;
    accountType = 'Google';

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);

    updateUserDataCache(uid, name, userEmail, imageUrl, accountType);

    return 'Google sign in successful, User UID: ${user.uid}';
  }

  return null;
}

Future<String> signInWithFacebook() async {

  await Firebase.initializeApp();

  final AccessToken result = await FacebookAuth.instance.login();

  // Create a credential from the access token
  final FacebookAuthCredential facebookAuthCredential =
  FacebookAuthProvider.credential(result.token);

  // Once signed in, return the UserCredential
  final UserCredential userCredential = await _auth.signInWithCredential(facebookAuthCredential);
  final User user = userCredential.user;

  if (user != null) {
    // Checking if email and name is null
    assert(user.uid != null);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoURL != null);

    uid = user.uid;
    name = user.displayName;
    userEmail = user.email;
    imageUrl = user.photoURL;
    accountType = 'Facebook';

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);

    updateUserDataCache(uid, name, userEmail, imageUrl, accountType);

    return 'Facebook sign in successful, User UID: ${user.uid}';
  }

  return null;
}

void signOut() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String accountType = prefs.getString('accountType');

  if(accountType == "Google") {
    signOutGoogle();
  } else if (accountType == "Facebook") {
    signOutFacebook();
  } else {
    signOutGoogle();
    signOutFacebook();
  }

  uid = null;
  name = null;
  userEmail = null;
  imageUrl = null;
  accountType = null;

  prefs.clear();
  userlocal.clear();
}

/// For signing out of their Google account
void signOutGoogle() async {

  await Firebase.initializeApp();
  await googleSignIn.signOut();
  await _auth.signOut();

  print("User signed out of Google account");
}

Future<String> signOutFacebook() async {

  await Firebase.initializeApp();
  await FacebookAuth.instance.logOut();
  await _auth.signOut();

  print("User signed out of Facebook account");
}

void updateUserDataCache(String uid, String name, String userEmail, String userImageUrl, String accountType) async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('auth', true);
  prefs.setString('uid', uid);
  prefs.setString('name', name);
  prefs.setString('userEmail', userEmail);
  prefs.setString('userImageUrl', userImageUrl);
  prefs.setString('accountType', accountType);

  userlocal.putIfAbsent('uid', () => prefs.getString('uid'));
  userlocal.putIfAbsent('name', () => prefs.getString('name'));
  userlocal.putIfAbsent('userEmail', () => prefs.getString('userEmail'));
  userlocal.putIfAbsent('userImageUrl', () => prefs.getString('userImageUrl'));
  userlocal.putIfAbsent('accountType', () => prefs.getString('accountType'));
  authSignedIn = true;

  dataRequiredForHome = fetchDataHome();

  Map <String, dynamic> Json = {
    "uid": uid,
    "name": name,
    "userEmail": userEmail,
    "userImageUrl": userImageUrl,
    "accounType": accountType
  };

  postUrl($serviceURLupdateuserinfo, Json);
}