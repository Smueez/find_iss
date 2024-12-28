import 'package:find_iss/utils/asset_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../main.dart';

class CommonDialogs {
  static snackBar({required BuildContext context, required text}) {
    ScaffoldMessenger.of(navigatorKey.currentState!.context)
        .showSnackBar(SnackBar(
      content: Text(text),
      duration: const Duration(milliseconds: 3000),
    ));
  }

  static loading(BuildContext context, [String message = "Please wait..."]) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              content: Padding(
                padding: EdgeInsets.all(20.sp),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      message,
                      textAlign: TextAlign.center,
                    ),
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void showISSUpAboveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          // title: Text('Confirm Action'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "The Space Station is above your Country Now!!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              Image.asset(
                AssetPath.satelliteLogo,
                width: 50.sp,
              )
            ],
          ),

          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              // Aligns buttons to the bottom left
              children: [
                TextButton(
                    onPressed: () {
                      navigatorKey.currentState?.pop();
                    },
                    child: const Text("OK"))
              ],
            ),
          ],
        );
      },
    );
  }
}
