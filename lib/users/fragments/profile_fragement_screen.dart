import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
// import 'package:my_project/users/cart/cart_list_screen.dart';
// import 'package:plantree/users/authentication/login_screen.dart';
// import 'package:plantree/users/userPreferences/current_user.dart';
// import 'package:plantree/users/userPreferences/user_Preferences.dart';

import '../authentication/login_screen.dart';
import '../cart/cart_list_screen.dart';
import '../userPreferences/current_user.dart';
import '../userPreferences/user_preferences.dart';

class ProfileFragementScreen extends StatelessWidget {
   ProfileFragementScreen({super.key});

  final CurrentUser _currentUser=Get.put(CurrentUser());

  signOutUser()async
  {
    var resultResponse = await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.green.shade50,
        title: Text(
          "Log Out",
          style: TextStyle(fontSize: 18,
            fontWeight: FontWeight.bold,),
        ),
        content: Text("Are you sure?\n you want to logout from app"),
        actions: [
          TextButton(
            onPressed: (){
              Get.back();
            },
            child: Text(
              "no",
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: (){
              Get.back(result: "loggedOut");
            },
            child:Text(
              "Yes",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
    if(resultResponse == "loggedOut")
    {
      RememberUserPreferences.removeUserInfo().then((value){
        Get.off(LoginScreen());
      });
    }
  }
  Widget userInfoItemProfile(IconData iconData,String userData){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color:Colors.green.shade50,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),

      child:Row(
        children: [
          Icon(
            iconData,
            size: 30,
            color: Colors.green,
          ),
          SizedBox(width: 16,),
          Text(userData,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: ListView(
        children: [
          Center(
            child:CircleAvatar(
              maxRadius: 50,
              minRadius: 50,
              backgroundColor: Colors.green,
              child: Image.asset(
                "assets/dp1.png",
                width: 80,
               color: Colors.green.shade100,
              ),
            ),
          ),
          const SizedBox(height: 20,),

          userInfoItemProfile(Icons.person,_currentUser.user.userName.toString()), //username
          const SizedBox(height: 10,),
          userInfoItemProfile(Icons.email,_currentUser.user.userEmail.toString()), //userEmail
          const SizedBox(height: 10,),
          userInfoItemProfile(Icons.phone,_currentUser.user.userContact.toString()), //userEmail
          const SizedBox(height: 10,),

          // Divider(color: Colors.green.shade100,thickness: 4,),

          const SizedBox(height: 200,),

          //btn to cart
          Material(
            color: Colors.green.shade100,
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: ()
              {
                  Get.to(CartListScreen());
              },
              borderRadius: BorderRadius.circular(32),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30,vertical: 12,),
                child: Center(
                  child: Text(
                    "Cart",
                    style: TextStyle(
                        color: Colors.green.shade900,
                        fontSize: 16,
                        //fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 10,),

          //Log out button



          Material(
            color: Colors.green,
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: ()
              {
                signOutUser();
              },
              // borderRadius: BorderRadius.circular(32),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 135,vertical: 12,),
                child: Center(
                  child: Text(
                    "Log Out",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}
