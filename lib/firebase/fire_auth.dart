import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../model/user/apple_user_credential.dart';

class FireAuth {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;


  static Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
    return null;
  }

  static String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  static String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<AppleUserCredential?> signInWithApple() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    var userCred =
    await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    if (userCred != null) {
      var credential = AppleUserCredential(
          "${appleCredential.givenName} ${appleCredential.familyName}",
          userCred);
      return credential;
    }
    return null;
  }

  static Future<UserCredential?> signInWithFacebook() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    final result = await FacebookAuth.instance.login(
      loginTracking: LoginTracking.limited,
      nonce: nonce,
    );
    if (result.status == LoginStatus.success) {
      print('${await FacebookAuth.instance.getUserData()}');
      final token = result.accessToken as LimitedToken;
// Create a credential from the access token
      OAuthCredential credential = OAuthCredential(
        providerId: 'facebook.com',
        signInMethod: 'oauth',
        idToken: token.tokenString,
        rawNonce: rawNonce,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
    return null;
    /*final LoginResult loginResult = await FacebookAuth.instance.login();
    if(loginResult.accessToken != null) {
      final AccessToken accessToken = loginResult.accessToken!;

      final AuthCredential credential;
      switch (accessToken.type) {
        case AccessTokenType.classic:
          final token = accessToken as ClassicToken;
          credential = FacebookAuthProvider.credential(token.authenticationToken!,);
          break;
        case AccessTokenType.limited:
          final token = accessToken as LimitedToken;
          credential = OAuthCredential(
            providerId: 'facebook.com',
            signInMethod: 'oauth',
            idToken: token.tokenString,
            rawNonce: token.nonce,
          );
          break;
      }
      // final OAuthCredential facebookAuthCredential = FacebookAuthProvider
      //     .credential(loginResult.accessToken!.token);

      return FirebaseAuth.instance.signInWithCredential(credential);
    }
    return null;*/
  }

}