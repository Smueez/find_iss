import 'package:find_iss/routes/routers.dart';
import 'package:find_iss/services/shared_preference.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyB9yBKNSUxjh_btoMqH6JtJmtRtPr7cs90",
        appId: "1:580982783720:android:045cc46a9d4a46a9e7d35d",
        messagingSenderId: "580982783720",
        projectId: "find-iss-4d74a"
    )
  );
  await SharedPreferenceManager.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const ProviderScope(child:  MyApp(title: "ISS Tracker",)));
}


class MyApp extends StatelessWidget {
  const MyApp({required this.title, super.key});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        behavior: HitTestBehavior.opaque,
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: title,
            theme: ThemeData(
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style:  ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                  )
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                shape:  CircleBorder(),
                backgroundColor: Colors.blueAccent,
              ),
              hintColor: Colors.black,
              appBarTheme: const AppBarTheme(
                  backgroundColor:Colors.blueAccent,
                  surfaceTintColor: Colors.white,
                  iconTheme: IconThemeData(
                      color: Colors.white
                  )
              ),
              primaryColor: Colors.blueAccent,
              scaffoldBackgroundColor: Colors.white,
              dialogBackgroundColor: Colors.white,
              bottomSheetTheme: const BottomSheetThemeData(
                  surfaceTintColor: Colors.white,
                  backgroundColor: Colors.white
              ),
              buttonTheme: const ButtonThemeData(
                buttonColor: Colors.black,
              ),
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            navigatorObservers: [routeObserver],
            navigatorKey: navigatorKey,
            onGenerateRoute: RouterISSTracker.generate
        ),
      ),
    );
  }
}
