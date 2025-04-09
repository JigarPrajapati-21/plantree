import 'package:get/get.dart';
// import 'package:my_project/users/userPreferences/user_preferences.dart';
import 'package:plantree/users/userPreferences/user_preferences.dart';
import '../model/user_model.dart';



class CurrentUser extends GetxController{
  final Rx<User> _currentUser = User(userId: 0,userName:'', userContact: '', userEmail: '',userPassword:'').obs;
  User get user => _currentUser.value;

  getUserInfo() async{
    User? getUserInfoFromLocalStorage =( await RememberUserPreferences.readUserInfo()) as User?;
    if (getUserInfoFromLocalStorage != null){
      _currentUser.value = getUserInfoFromLocalStorage;
      print("hhh\n\n\n");
      print(_currentUser.value);
    }
  }
}