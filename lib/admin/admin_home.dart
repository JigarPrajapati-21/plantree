import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:my_project/api_connection/api_connection.dart';
import 'package:http/http.dart' as http;

import '../api_connection/api_connection.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {

  late Map<String,dynamic> tableRowCounts;

  getData()async
  {
    try
    {
      var res = await http.post(
          Uri.parse(API.adminData)
      );
      if(res.statusCode == 200)
      {
        var responseBodyOfMainCategory = jsonDecode(res.body);
        if(responseBodyOfMainCategory["status"] == "success")
        {
          print(responseBodyOfMainCategory["data"]);
          tableRowCounts = responseBodyOfMainCategory["data"];
          print("--------------");
          print(tableRowCounts);
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Error, status code is not 200");
      }
    }
    catch(errorMsg)
    {
      print("Error::" + errorMsg.toString());
    }
    return tableRowCounts;
  }

  @override
  void initState(){
    //TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getData(),
          builder: (context, dataSnapShot)
          {
            if(dataSnapShot.connectionState == ConnectionState.waiting)
            {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if(dataSnapShot.data == null)
            {
              return const Center(
                child: Text(
                  "No data found",
                ),
              );
            }
            if(tableRowCounts!.length > 0)
            {
              return GridView.count(
                crossAxisCount: 2,
                children: [
                  Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          tableRowCounts["admin_table"].toString(),
                          style: TextStyle(
                            color: Colors.green.shade900,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          'Admin',
                          style: TextStyle(
                            color: Colors.green.shade900,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          tableRowCounts["user_table"].toString(),
                          style: TextStyle(
                            color: Colors.green.shade900,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          'Users',
                          style: TextStyle(
                            color: Colors.green.shade900,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),


                  Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          tableRowCounts["orders_table"].toString(),
                          style: TextStyle(
                            color: Colors.green.shade900,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          'New Orders',
                          style: TextStyle(
                            color: Colors.green.shade900,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          tableRowCounts["main_category"].toString(),
                          style: TextStyle(
                            color: Colors.green.shade900,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          'Main Category',
                          style: TextStyle(
                            color: Colors.green.shade900,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),


                  Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          tableRowCounts["sub_category"].toString(),
                          style: TextStyle(
                            color: Colors.green.shade900,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          'Sub Category',
                          style: TextStyle(
                            color: Colors.green.shade900,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          tableRowCounts["items_table"].toString(),
                          style: TextStyle(
                            color: Colors.green.shade900,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          'item',
                          style: TextStyle(
                            color: Colors.green.shade900,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),


                ],
              );
            }
            else{
              return const Center(
                child: Text("Empty, No Data."),
              );
            }
          }

      ),
    );
  }
}
