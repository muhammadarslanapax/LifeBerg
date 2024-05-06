import 'package:firebase_auth/firebase_auth.dart';

class AppleUserCredential {
  final String fullName;
  final UserCredential userCredential;

  AppleUserCredential(this.fullName, this.userCredential);
}
