import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:my_project/admin/admin_login_screen.dart';

import 'add_items.dart';
import 'admin_add_category.dart';
import 'admin_home.dart';
import 'admin_login_screen.dart';
import 'new_order_screen.dart';
class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 30,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.green,
          title: Text('Dashboard',style: TextStyle(fontSize: 18,color: Colors.white),),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            tabs: [
              Tab(child: Text("Home",style:  TextStyle( fontSize: 18,color: Colors.white),),),
              Tab(child: Text("order",style: TextStyle(fontSize: 18,color: Colors.white),),),
              Tab(child: Text("Add category",style: TextStyle(fontSize: 18,color: Colors.white),),),
              Tab(child: Text("add item ",style: TextStyle(fontSize: 18,color: Colors.white),),),
            ],
          ),
          actions: [
            Padding(
              padding:  EdgeInsets.fromLTRB(0,0,10,0),
              child: IconButton(onPressed: (){
                Get.off(AdminLoginScreen());
              },
              icon: Icon(Icons.logout,color: Colors.white,),),
            )
          ],
        ),
        body: TabBarView(
          children: [

            //tab 1 your new orders
            AdminHome(),

            //tab 2 your order history
            NewOrderScreen(),

            //tab 3 your order history
            AdminAddCategory(),

            //tab 4 your order history
            AddItemPage(),

          ],
        ),
      ),
    );
  }
}
