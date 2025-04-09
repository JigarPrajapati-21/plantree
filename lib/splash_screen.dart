import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:plantree/users/authentication/login_screen.dart';
import 'package:plantree/users/fragments/dashboard_of_fregments.dart';
import 'package:plantree/users/userPreferences/user_preferences.dart';
// import 'package:my_project/users/authentication/login_screen.dart';
// import 'package:my_project/users/fragments/dashboard_of_fregments.dart';
// import 'package:my_project/users/userPreferences/user_preferences.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startSplashScreen();
  }

  void startSplashScreen() async{

    await Future.delayed(Duration(seconds: 3));

    var userInfo=await RememberUserPreferences.readUserInfo();
    if(userInfo==null){
      Get.off(()=>LoginScreen());
    }else{
      Get.offAll(()=>DashboardOfFragments());
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade900,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.eco,
            color: Colors.white,
            size: 80,
            ),

            SizedBox(height: 20,),

            Text("PlanTREE",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
