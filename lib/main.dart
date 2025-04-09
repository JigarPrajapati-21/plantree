import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantree/splash_screen.dart';
// import 'package:my_project/splash_screen.dart';
// import 'package:my_project/users/authentication/login_screen.dart';
// import 'package:my_project/users/fragments/dashboard_of_fregments.dart';
// import 'package:my_project/users/userPreferences/user_preferences.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PlanTree',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),

      //   FutureBuilder(
      //   future: RememberUserPreferences.readUserInfo(),
      //   builder: (context,dataSnapShot)
      //   {
      //     if(dataSnapShot.data==null)
      //       {
      //         return LoginScreen();
      //       }
      //     else
      //       {
      //         return DashboardOfFragments();
      //       }
      //   },
      // ),
    );
  }
}
