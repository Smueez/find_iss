import 'package:find_iss/screens/sign_in/controller/signin_controller.dart';
import 'package:find_iss/screens/splash_screen/ui/splash_screen_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SignInUi extends StatefulWidget {
  const SignInUi({Key? key}) : super(key: key);

  @override
  State<SignInUi> createState() => _SignInUiState();
}

class _SignInUiState extends State<SignInUi> {

  SignInController? controller;

  @override
  void initState() {
    controller = SignInController(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(
                child: SplashScreenUi(canTransit: false,)),
            // SizedBox(
            //   height: 2.h,
            // ),
            ElevatedButton(
                child: const Text(
                    "Anonymously Sign In",
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                onPressed: (){
                  controller?.signIn();
                },

            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }
}
