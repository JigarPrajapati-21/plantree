
import'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';

class RememberUserPreferences
{
  //save user information
  static Future<void> storeUserInfo(User userInfo) async
  {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    String userJsonData  = jsonEncode(userInfo.toJson());
    await preferences.setString("currentUser", userJsonData);
  }

  //get - read user info
  static Future<User?> readUserInfo() async
  {
    User? currentUserInfo;
    SharedPreferences preferences= await SharedPreferences.getInstance();
    String? userInfo=preferences.getString("currentUser");

    if(userInfo !=null)
    {
      Map<String,dynamic> userDataMap = jsonDecode(userInfo);
      currentUserInfo=User.fromJson(userDataMap);
    }
    print("\n\n data stored display........\n\n\n");
    print(currentUserInfo);

    return currentUserInfo;
  }

//delete-remove user data from phone local storage
  static Future<void> removeUserInfo() async
  {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    await preferences.remove("currentUser");
  }
}