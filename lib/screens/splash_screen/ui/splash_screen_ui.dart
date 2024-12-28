import 'package:find_iss/screens/splash_screen/controller/splash_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/asset_name.dart';

class SplashScreenUi extends StatefulWidget {
  const SplashScreenUi({this.canTransit = true, Key? key}) : super(key: key);
  final bool canTransit;
  @override
  State<SplashScreenUi> createState() => _SplashScreenUiState();
}

class _SplashScreenUiState extends State<SplashScreenUi> {

  SplashScreenController controller = SplashScreenController();
  @override
  void initState() {
    controller.gotoNextPage(widget.canTransit);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AssetPath.satelliteLogo,
              width: 60.w,
            ),
            SizedBox(height: 5.h,),
            Text(
                "ISS Tracker",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20.sp
              ),
            )
          ],
        ),
      ),
    );
  }
}
