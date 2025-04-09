import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:my_project/users/fragments/profile_fragement_screen.dart';
import 'package:plantree/users/fragments/profile_fragement_screen.dart';
import '../userPreferences/current_user.dart';
// import 'package:my_project/users/fragments/favourites_fragement_screen.dart';
// import 'package:my_project/users/fragments/home_fragement_screen.dart';
// import 'package:my_project/users/fragments/order_fragement_screen.dart';

import 'category_fragement_screen.dart';
import 'favourites_fragement_screen.dart';
import 'home_fragement_screen.dart';
import 'order_fragement_screen.dart';

class DashboardOfFragments extends StatelessWidget{
  DashboardOfFragments({super.key});

  CurrentUser _rememberCurrentUser= Get.put(CurrentUser());

  List<Widget>_fragementScreen =[
    HomeFragementScreen(),
    CategoryFragementScreen(),
    FavoritesFragmentScreen(),
    OrderFragementScreen(),
    ProfileFragementScreen(),
  ];
  List _navigationButtonPropeties=[
       {
          "active_icon": Icons.home,
          "non_active_icon":Icons.home_outlined,
          "label" :"Home",
       },
       {
         "active_icon": Icons.category,
         "non_active_icon":Icons.category_outlined,
         "label" :"Category",
       },
       {
          "active_icon": Icons.favorite,
          "non_active_icon":Icons.favorite_border,
          "label" :"Favorite",
       },
       {
          "active_icon": FontAwesomeIcons.boxOpen,
          "non_active_icon":FontAwesomeIcons.box,
          "label" :"Orders",
       },
       {
          "active_icon": Icons.person,
          "non_active_icon":Icons.person_outlined,
          "label" :"Profile",
       }, ];
  RxInt _indexNumber = 0.obs;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: CurrentUser(),
        initState: (currentState){
          _rememberCurrentUser.getUserInfo();
        },
        builder: (controller)
        {
          return Scaffold(
            //   appBar: AppBar(
            //    title: Text("DashBoard",style: TextStyle(color: Colors.white)),
            //    backgroundColor: Colors.deepPurple,
            //  ),
            body: SafeArea(
              child: Obx(
                      ()=>_fragementScreen[_indexNumber.value]
              ),
            ),
            bottomNavigationBar: Obx(
                  ()=>BottomNavigationBar(
                  currentIndex: _indexNumber.value,
                  onTap: (value)
                  {
                    _indexNumber.value=value;
                  },
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white70,


                  items: List.generate(5, (index)
                  {
                    var navBtnProPerty=_navigationButtonPropeties[index];
                    return BottomNavigationBarItem(
                      backgroundColor: Colors.green.shade700,
                      icon: Icon(navBtnProPerty["non_active_icon"]),
                      activeIcon: Icon(navBtnProPerty["active_icon"]),
                      label: navBtnProPerty["label"],
                    );
                  }
                  )
              ),
            ),
          );
        }
    );
  }
}