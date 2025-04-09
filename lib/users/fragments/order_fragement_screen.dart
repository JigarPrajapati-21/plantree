// // import 'package:flutter/material.dart';
// //
// // class OrderFragementScreen extends StatelessWidget {
// //   const OrderFragementScreen({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Center(
// //         child: Text("ORDER SCREEN",style: TextStyle(color: Colors.green.shade900,fontSize: 30),),
// //       ),
// //     );
// //   }
// // }
// import 'dart:convert';
// import 'dart:ui';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/widgets.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:my_project/users/userPreferences/current_user.dart';
// import 'package:http/http.dart' as http;
// import '../../api_connection/api_connection.dart';
// import '../model/order_model.dart';
// import 'package:intl/intl.dart';
//
// class OrderFragmentatoinScreen extends StatelessWidget {
//    OrderFragmentatoinScreen({super.key});
//
//   final currentOnlineUser = Get.put(CurrentUser());
//
//   Future<List<Order>> getCurrentUserOrdersList()async
//   {
//     List<Order>OrderListOfCurrentUser =[];
//
//     try
//     {
//       var res =await http.post(
//           Uri.parse(API.readOrders),
//           body:
//           {
//             "currentOnlineUserId":currentOnlineUser.user.userId.toString(),
//           }
//       );
//       print(res.statusCode);
//       print(res.body);
//       if(res.statusCode == 200)
//       {
//         var responseBodyOfCurrentUserOrderList =jsonDecode(res.body);
//         print(responseBodyOfCurrentUserOrderList["currentUserOrdersData"]);
//         if (responseBodyOfCurrentUserOrderList['status']== "success")
//         {
//           (responseBodyOfCurrentUserOrderList['currentUserOrdersData'] as
//           List).forEach((eachCurrentUserOrdersData)
//           {
//             OrderListOfCurrentUser.add(Order.fromJson(eachCurrentUserOrdersData));
//           });
//         }
//       }
//       else
//       {
//         Fluttertoast.showToast(msg: "Status Code is not 200");
//       }
//     }
//     catch(errorMsg)
//     {
//       Fluttertoast.showToast(msg: "Error::" + errorMsg.toString());
//     }
//     return OrderListOfCurrentUser;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Oder image  //history image
//           //myorder titel  //history title
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16,20,8,0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 //order icon image
//                 //my order
//                 Column(
//                   children: [
//                     // Image.asset(
//                     //   "assets/iconimg1.jpg",
//                     //   width: 140,
//                     // ),
//                     const Text(
//                       "My Orders",
//                       style: TextStyle(
//                         color: Colors.purpleAccent,
//                         fontSize: 24,
//                         fontWeight:FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 //history icon image
//                 //history
//                 GestureDetector(
//                   onTap: ()
//                   {
//                     //send user to order hitory screen
//                   },
//                   child: Padding(
//                     padding:const EdgeInsets.all(8.0),
//                     child: Column(
//                       children: [
//                         // Image.asset(
//                         //   "assets/iconimg1.jpg",
//                         //   width: 45,
//                         // ),
//                         const Text(
//                           "History",
//                           style: TextStyle(
//                             color: Colors.purpleAccent,
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//
//           const Padding(
//             padding:EdgeInsets.symmetric(horizontal: 30.0),
//             child: Text(
//               "Here are your Successfully Placed orders.",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ) ,
//
//           //displaying the user orderList
//           Expanded(child: displayOrdersList(context),
//           ),
//         ],
//       ),
//     );
//   }
//   Widget displayOrdersList(context)
//   {
//     return FutureBuilder(
//         future:getCurrentUserOrdersList(),
//         builder:(context,AsyncSnapshot<List<Order>>dataSnapshot)
//         {
//           if(dataSnapshot.connectionState == ConnectionState.waiting)
//           {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: const[
//                 Center(
//                   child: Text(
//                     "Connection Waiting...",
//                     style: TextStyle(color: Colors.grey,),
//                   ),
//                 ),
//                 Center(
//                   child: CircularProgressIndicator(),
//                 )
//               ],
//             );
//           }
//           if(dataSnapshot.data == null)
//           {
//           return Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children:const [
//           Center(
//           child: Text(
//           "No orders found yet..",
//           style: TextStyle(color: Colors.grey,),
//           ),
//           ),
//
//           Center(
//           child:CircularProgressIndicator(),
//           ),
//           ],
//           );
//           }
//           if(dataSnapshot.data!.length > 0)
//           {
//           List<Order>orderList = dataSnapshot.data!;
//
//           return ListView.separated(
//           padding: const EdgeInsets.all(16),
//           separatorBuilder:(context,index)
//           {
//           return const Divider(
//           height: 1,
//           thickness: 1,
//           );
//           },
//           itemCount:orderList.length,
//           itemBuilder: (context,index)
//           {
//           Order eachOrderData = orderList[index];
//
//           return Card(
//           color: Colors.white24,
//           child:Padding(
//           padding: const EdgeInsets.all(18),
//           child: ListTile(
//           onTap: ()
//           {
//           // Get.to(OrderDetailsScreen(
//           // clickedOrderInfo:eachOrderData,
//           // ));
//           },
//           title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//           Text(
//           "Order ID #" + eachOrderData.order_id.toString(),
//           style: const TextStyle(
//           color: Colors.grey,
//           fontWeight: FontWeight.bold,
//           ),
//           ),
//           Text(
//           "Amount:Rs."+eachOrderData.totalAmount.toString(),
//           style: TextStyle(
//           color: Colors.purpleAccent,
//           fontWeight: FontWeight.bold,
//           ),
//           ),
//           ],
//           ),
//           trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//           //data
//           //time
//           Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//           //data
//           Text(
//           DateFormat(
//           "dd MMMM,yyyy"
//           ).format(eachOrderData.dateTime!),
//           style: const TextStyle(
//           color: Colors.grey,
//           ),
//           ),
//           const SizedBox(height: 4,),
//
//           //time
//           Text(
//           DateFormat(
//           "hh:mm a"
//           ).format(eachOrderData.dateTime!),
//           style: TextStyle(
//           color: Colors.grey,
//           ),
//           )
//           ],
//           ),
//            SizedBox(width: 6,),
//           const Icon(
//           Icons.navigate_next,
//           color: Colors.purpleAccent,
//           ),
//           ],
//           ),
//           ),
//           ),
//           );
//           }
//           );
//           }
//           else
//           {
//           return Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: const [
//           Center(
//           child: Text(
//           "Nothing to show..",
//           style: TextStyle(color: Colors.grey),
//           ),
//           ),
//           Center(
//           child:CircularProgressIndicator(),
//           )
//           ],
//           );
//           }
//         }
//     );
//   }
// }

import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:my_project/users/userPreferences/current_user.dart';

import '../../api_connection/api_connection.dart';
import '../model/order_model.dart';
import '../order/order_details.dart';
import '../userPreferences/current_user.dart';

class OrderFragementScreen extends StatelessWidget {
  OrderFragementScreen({super.key});

  final currentOnlineUser = Get.put(CurrentUser());

  Future<List<Order>> getCurrentUserOrdersList() async {
    List<Order> orderListOfCurrentUser = [];

    try {
      var res = await http.post(Uri.parse(API.readOrders), body: {
        "currentOnlineUserId": currentOnlineUser.user.userId.toString(),
      });
      print(res.statusCode);
      print(res.body);
      if (res.statusCode == 200) {
        var responseBodyOfCurrentUserOrderList = jsonDecode(res.body);
        print(responseBodyOfCurrentUserOrderList["currentUserOrdersData"]);
        if (responseBodyOfCurrentUserOrderList['status'] == "success") {
          (responseBodyOfCurrentUserOrderList['currentUserOrdersData'] as List)
              .forEach((eachCurrentUserOrdersData) {
            orderListOfCurrentUser
                .add(Order.fromJson(eachCurrentUserOrdersData));
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Status Code is not 200");
      }
    } catch (errorMsg) {
      print("Error::" + errorMsg.toString());
      Fluttertoast.showToast(msg: "Error::" + errorMsg.toString());
    }
    return orderListOfCurrentUser;
  }

  Future<List<Order>> getCurrentUserOrdersHistoryList() async {
    List<Order> orderListOfCurrentUser = [];

    try {
      var res = await http.post(Uri.parse(API.readHistory), body: {
        "currentOnlineUserId": currentOnlineUser.user.userId.toString(),
      });
      print(res.statusCode);
      print(res.body);
      if (res.statusCode == 200) {
        var responseBodyOfCurrentUserOrderList = jsonDecode(res.body);
        print(responseBodyOfCurrentUserOrderList["currentUserOrderHistoryData"]);
        if (responseBodyOfCurrentUserOrderList['status'] == "success") {
          (responseBodyOfCurrentUserOrderList['currentUserOrderHistoryData'] as List)
              .forEach((eachCurrentUserOrdersData) {
            orderListOfCurrentUser
                .add(Order.fromJson(eachCurrentUserOrdersData));
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Status Code is not 200");
      }
    } catch (errorMsg) {
      print("Error::" + errorMsg.toString());
      Fluttertoast.showToast(msg: "Error::" + errorMsg.toString());
    }
    return orderListOfCurrentUser;
  }

  Future<List<Order>> getCurrentUserOrdersHistoryList_o() async {
    List<Order> ordersHistoryListOfCurrentUser = [];

    try {
      var res = await http.post(Uri.parse(API.readHistory), body: {
        "currentOnlineUserId": currentOnlineUser.user.userId.toString(),
      });
      print(res.statusCode);
      print(res.body);
      if (res.statusCode == 200) {
        var responseBodyOfCurrentUserOrderList = jsonDecode(res.body);
        print(responseBodyOfCurrentUserOrderList["currentUserOrdersData"]);
        if (responseBodyOfCurrentUserOrderList['status'] == "success") {
          (responseBodyOfCurrentUserOrderList['currentUserOrdersHistoryData']
                  as List)
              .forEach((eachCurrentUserOrdersData) {
            ordersHistoryListOfCurrentUser
                .add(Order.fromJson(eachCurrentUserOrdersData));
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Status Code is not 200");
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: "Error::" + errorMsg.toString());
    }
    return ordersHistoryListOfCurrentUser;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 30,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.green,
          title: Text(
            "Yours Orders",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Row(
                  children: [
                    Icon(
                      Icons.shopping_bag_rounded,
                      color: Colors.white,
                    ),
                    Text(
                      "Your New Orders",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    Icon(
                      Icons.history,
                      color: Colors.white,
                    ),
                    Text(
                      "Your Order History",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            //tab 1 your new orders
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Oder image  //history image
                  //myorder titel  //history title
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 8, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //order icon image
                        //my order
                        Column(
                          children: [
                            // Image.asset(
                            //   "assets/iconimg1.jpg",
                            //   width: 140,
                            // ),
                            const Text(
                              "My Orders",
                              style: TextStyle(
                                color: Colors.purpleAccent,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      "Here are your Successfully Placed orders.",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  //displaying the user orderList
                  Expanded(
                    child: displayOrdersList(context),
                  ),
                ],
              ),
            ),

            //tab 2 your order history
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Oder image  //history image
                  //myorder titel  //history title
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 8, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //order icon image
                        //my order
                        Column(
                          children: [
                            // Image.asset(
                            //   "assets/iconimg1.jpg",
                            //   width: 140,
                            // ),
                            const Text(
                              "My Order History",
                              style: TextStyle(
                                  color: Colors.purpleAccent,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  // fontFamily: "Courier New",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      "Here are your past order's history.",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  //displaying the user orderList
                  Expanded(
                    child: displayOrdersHistoryList(context),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     // Oder image  //history image
        //     //myorder titel  //history title
        //     Padding(
        //       padding: const EdgeInsets.fromLTRB(16,20,8,0),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           //order icon image
        //           //my order
        //           Column(
        //             children: [
        //               // Image.asset(
        //               //   "assets/iconimg1.jpg",
        //               //   width: 140,
        //               // ),
        //               const Text(
        //                 "My Orders",
        //                 style: TextStyle(
        //                   color: Colors.purpleAccent,
        //                   fontSize: 24,
        //                   fontWeight:FontWeight.bold,
        //                 ),
        //               ),
        //             ],
        //           ),
        //
        //           //history icon image
        //           //history
        //           GestureDetector(
        //             onTap: ()
        //             {
        //               //send user to order hitory screen
        //             },
        //             child: Padding(
        //               padding:const EdgeInsets.all(8.0),
        //               child: Column(
        //                 children: [
        //                   // Image.asset(
        //                   //   "assets/iconimg1.jpg",
        //                   //   width: 45,
        //                   // ),
        //                   const Text(
        //                     "History",
        //                     style: TextStyle(
        //                       color: Colors.purpleAccent,
        //                       fontSize: 12,
        //                       fontWeight: FontWeight.bold,
        //                     ),
        //                   )
        //                 ],
        //               ),
        //             ),
        //           )
        //         ],
        //       ),
        //     ),
        //
        //     const Padding(
        //       padding:EdgeInsets.symmetric(horizontal: 30.0),
        //       child: Text(
        //         "Here are your Successfully Placed orders.",
        //         style: TextStyle(
        //           color: Colors.white,
        //           fontSize: 16,
        //           fontWeight: FontWeight.w400,
        //         ),
        //       ),
        //     ) ,
        //
        //     //displaying the user orderList
        //     Expanded(child: displayOrdersList(context),
        //     ),
        //   ],
        // ),
      ),
    );
  }

  Widget displayOrdersList(context) {
    return FutureBuilder(
        future: getCurrentUserOrdersList(),
        builder: (context, AsyncSnapshot<List<Order>> dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Center(
                  child: Text(
                    "Connection Waiting...",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
                Center(
                  child: CircularProgressIndicator(),
                )
              ],
            );
          }
          if (dataSnapshot.data == null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Center(
                  child: Text(
                    "No orders found yet..",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            );
          }
          if (dataSnapshot.data!.length > 0) {
            List<Order> orderList = dataSnapshot.data!;

            return ListView.separated(
                padding: const EdgeInsets.all(16),
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 1,
                    thickness: 1,
                  );
                },
                itemCount: orderList.length,
                itemBuilder: (context, index) {
                  Order eachOrderData = orderList[index];

                  return Card(
                    color: Colors.green.shade50,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 18, 10, 10),
                      child: ListTile(
                        onTap: () {
                          Get.to(OrderDetailsScreen(
                            clickedOrderInfo: eachOrderData,
                            order_id: eachOrderData.order_id.toString(),
                            itemsdata: eachOrderData.itemsdata.toString(),
                          ));
                        },
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order ID #" + eachOrderData.order_id.toString(),
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Amount:Rs." +
                                  eachOrderData.totalAmount.toString(),
                              style: TextStyle(
                                  color: Colors.purpleAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //data
                            //time
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //data
                                Text(
                                  DateFormat("dd MMMM,yyyy")
                                      .format(eachOrderData.dateTime!),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green.shade900,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),

                                //time
                                Text(
                                  DateFormat("hh:mm a")
                                      .format(eachOrderData.dateTime!),
                                  style: TextStyle(
                                    color: Colors.green.shade900,
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            const Icon(
                              Icons.navigate_next,
                              color: Colors.purpleAccent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Center(
                  child: Text(
                    "Nothing to show..",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Center(
                  child: CircularProgressIndicator(),
                )
              ],
            );
          }
        });
  }

  Widget displayOrdersHistoryList(context) {
    return FutureBuilder(
        future: getCurrentUserOrdersHistoryList(),
        builder: (context, AsyncSnapshot<List<Order>> dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Center(
                  child: Text(
                    "Connection Waiting...",
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  ),
                ),
                Center(
                  child: CircularProgressIndicator(),
                )
              ],
            );
          }
          if (dataSnapshot.data == null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Center(
                  child: Text(
                    "No orders found yet..",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            );
          }
          if (dataSnapshot.data!.length > 0) {
            List<Order> orderList = dataSnapshot.data!;

            return ListView.separated(
                padding: const EdgeInsets.all(16),
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 1,
                    thickness: 1,
                  );
                },
                itemCount: orderList.length,
                itemBuilder: (context, index) {
                  Order eachOrderData = orderList[index];

                  return Card(
                    color: Colors.green.shade50,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 18, 10, 10),
                      child: ListTile(
                        onTap: () {
                          Get.to(OrderDetailsScreen(
                            clickedOrderInfo: eachOrderData,
                            order_id: eachOrderData.order_id.toString(),
                            itemsdata: eachOrderData.itemsdata.toString(),
                          ));
                        },
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order ID #" + eachOrderData.order_id.toString(),
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Amount:Rs." +
                                  eachOrderData.totalAmount.toString(),
                              style: TextStyle(
                                  color: Colors.purpleAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //data
                            //time
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //data
                                Text(
                                  DateFormat("dd MMMM,yyyy")
                                      .format(eachOrderData.dateTime!),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green.shade900,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),

                                //time
                                Text(
                                  DateFormat("hh:mm a")
                                      .format(eachOrderData.dateTime!),
                                  style: TextStyle(
                                    color: Colors.green.shade900,
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            const Icon(
                              Icons.navigate_next,
                              color: Colors.purpleAccent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Center(
                  child: Text(
                    "Nothing to show..",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Center(
                    // child: CircularProgressIndicator(),
                    )
              ],
            );
          }
        });
  }
}
