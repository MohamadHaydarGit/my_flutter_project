
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi{
  static final LocalAuthentication _auth = LocalAuthentication();


  static Future<bool> hasEnrolledBiometrics() async {
    try{
      return await _auth.canCheckBiometrics;
    }on PlatformException catch(e){
      return false;

    }

  }

  static Future<bool> authenticate() async {
    final isAvailable = await hasEnrolledBiometrics();
    if(!isAvailable){
      return false;
    }
    try {
      final bool didAuthenticate = await _auth.authenticate(
          localizedReason: 'Please authenticate to proceed',
          options: const AuthenticationOptions(biometricOnly: true,stickyAuth: true,useErrorDialogs: true));
      return didAuthenticate;
    } on PlatformException catch (e) {
      return false;
    }
  }
}