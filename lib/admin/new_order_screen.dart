import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../api_connection/api_connection.dart';
import '../users/model/order_model.dart';
import '../users/order/order_details.dart';
import 'admin_order_details.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({super.key});

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {

  Future<List<Order>> getCurrentUserOrdersList() async {
    List<Order> orderListOfCurrentUser = [];

    try {
      var res = await http.post(Uri.parse(API.getNewOrder));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: displayOrdersList(context),
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
                          Get.to(AdminOrderDetailsScreen(
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

}
