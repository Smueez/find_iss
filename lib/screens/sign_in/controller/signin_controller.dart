import 'package:find_iss/main.dart';
import 'package:find_iss/routes/router_name.dart';
import 'package:find_iss/utils/common_dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class SignInController {
  BuildContext context;

  SignInController({required this.context});

  signIn()async{
    CommonDialogs.loading(context);
    UserCredential credential = await FirebaseAuth.instance.signInAnonymously();
    navigatorKey.currentState?.pop();
    if(credential.user != null){
      CommonDialogs.snackBar(context: context, text: "Sign in successfully");
      navigatorKey.currentState?.pushNamedAndRemoveUntil(RouterName.homeScreen, (v)=>false);
      return;

    }
    CommonDialogs.snackBar(context: context, text: "Sign in failed. Please try again!");

  }
}