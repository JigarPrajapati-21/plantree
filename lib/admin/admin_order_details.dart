import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../api_connection/api_connection.dart';
import '../users/model/order_model.dart';
import '../users/model/plant_model.dart';

class AdminOrderDetailsScreen extends StatefulWidget {
  final Order clickedOrderInfo;
  final String order_id;
  final String itemsdata;

  AdminOrderDetailsScreen(
      {required this.clickedOrderInfo,
      required this.order_id,
      required this.itemsdata});

  @override
  State<AdminOrderDetailsScreen> createState() => _AdminOrderDetailsScreenState();
}

class _AdminOrderDetailsScreenState extends State<AdminOrderDetailsScreen> {
  final RxString _status = "new".obs;
  String get status => _status.value;

  late List tempListOfitemsdata;
  List orderitemsids = [];

  Future<List<Plants>> getOrderItems() async {
    for (int i = 0; i < tempListOfitemsdata.length; i++) {
      orderitemsids.add(tempListOfitemsdata[i][0]);
    }
    List<Plants> allOrderItemsList = [];

    try {
      var res = await http.post(Uri.parse(API.getOrderItems), body: {
        "orderitemsids": orderitemsids.toString(),
      });
      if (res.statusCode == 200) {
        var responseBodyOfAllPlants = jsonDecode(res.body);
        if (responseBodyOfAllPlants["status"] == "success") {
          (responseBodyOfAllPlants["orderItemData"] as List)
              .forEach((eachRecord) {
            allOrderItemsList.add(Plants.fromJson(eachRecord));
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Error,status code is not 200");
      }
    } catch (errorMsg) {
      print("Error::" + errorMsg.toString());
    }
    return allOrderItemsList;
  }

  updateParcelStatusForUI(String parcelReceived) {
    _status.value = parcelReceived;
  }
  //
  // showDialogForParcelConfirmation() async {
  //   if (widget.clickedOrderInfo!.status == "new") {
  //     var response = await Get.dialog(
  //       AlertDialog(
  //         backgroundColor: Colors.black,
  //         title: const Text(
  //           "Confirmation",
  //           style: TextStyle(
  //             color: Colors.grey,
  //           ),
  //         ),
  //         content: const Text(
  //           "Have you received your parcel?",
  //           style: TextStyle(
  //             color: Colors.grey,
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Get.back();
  //             },
  //             child: const Text(
  //               "No",
  //               style: TextStyle(color: Colors.redAccent),
  //             ),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Get.back(result: "yesConfirmed");
  //             },
  //             child: const Text(
  //               "Yes",
  //               style: TextStyle(color: Colors.green),
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //     if (response == "yesConfirmed") {
  //       updateStatusValueInDatabase();
  //     }
  //   }
  // }

  updateStatusValueInDatabase() async {
    try {
      print(widget.clickedOrderInfo.order_id.toString());

      var response = await http.post(Uri.parse(API.updateStatus), body: {
        "order_id": widget.clickedOrderInfo.order_id.toString(),
      });

      print(response.statusCode);

      if (response.statusCode == 200) {
        var responseBodyOfUpdateStatus = jsonDecode(response.body);
    // print(response.body);
        if (responseBodyOfUpdateStatus["success"] == true) {
          updateParcelStatusForUI("arrived");
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    //TODO:implement initState
    super.initState();
    tempListOfitemsdata = List<List<int>>.from(
        jsonDecode(widget.itemsdata!).map((e) => List<int>.from(e)));
    updateParcelStatusForUI(widget.clickedOrderInfo!.status.toString());
  }

  @override
  Widget build(BuildContext context) {
    //Decode Base64 string to Uint8List
    Uint8List imageBytes = base64Decode(widget.clickedOrderInfo!.image!);

    return Scaffold(
      //backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          DateFormat("dd MMMM,yyyy -hh:mm a")
              .format(widget.clickedOrderInfo!.dateTime!),
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
        titleSpacing: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back(result: 3);
          },
        ),

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //display items belongs to clicked order
              orderItemWidget(context),
              //display clickedOrderItems();

              //total amount
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: showTitleText("Total Amount: Rs." +
                      widget.clickedOrderInfo!.totalAmount.toString())),
              SizedBox(
                height: 8,
              ),
              Divider(
                height: 2,
                color: Colors.green.shade900,
                thickness: 1,
              ),
              SizedBox(
                height: 8,
              ),

              showTitleText("Full Name:"),
              const SizedBox(
                height: 4,
              ),
              showContentText(widget.clickedOrderInfo!.name!),

              const SizedBox(
                height: 16,
              ),

              showTitleText("Phone Number:"),
              const SizedBox(
                height: 4,
              ),
              showContentText(widget.clickedOrderInfo!.phoneNumber!),

              const SizedBox(
                height: 16,
              ),

              //shipment Address
              showTitleText("Shipment Address:"),
              const SizedBox(
                height: 4,
              ),
              showContentText(widget.clickedOrderInfo!.shipmentAddress!),

              const SizedBox(
                height: 16,
              ),

              //delivery
              showTitleText("Delivery System:"),
              const SizedBox(
                height: 4,
              ),
              showContentText(widget.clickedOrderInfo!.deliverySystem!),

              const SizedBox(
                height: 16,
              ),
              //payment
              showTitleText("Payment System:"),
              const SizedBox(
                height: 4,
              ),
              showContentText(widget.clickedOrderInfo!.paymentSystem!),

              const SizedBox(
                height: 16,
              ),

              //note
              showTitleText("Note to Seller:"),
              const SizedBox(
                height: 4,
              ),
              showContentText(widget.clickedOrderInfo!.note!),

              const SizedBox(
                height: 16,
              ),

              //total amount
              //showtitleText("Total Amount:"),
              //const SizedBox(height: 8,),
              //showContentText(widget.clickedOrderInfo!.totalAmount.toString()),


              //payment proof
              showTitleText("Proof of payment/Transaction:"),
              const SizedBox(
                height: 8,
              ),

              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Image.memory(
                    imageBytes,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget showTitleText(String titleText) {
    return Text(
      titleText,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.green,
      ),
    );
  }

  Widget showContentText(String contentText) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        contentText,
        style: TextStyle(
          fontSize: 20,
          color: Colors.green.shade900,
        ),
      ),
    );
  }

  orderItemWidget(context) {
    return FutureBuilder(
        future: getOrderItems(),
        builder: (context, AsyncSnapshot<List<Plants>> dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (dataSnapShot.data == null) {
            return const Center(
              child: Text(
                "No item found",
              ),
            );
          }
          if (dataSnapShot.data!.length > 0) {
            return ListView.builder(
                itemCount: dataSnapShot.data!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  Plants eachPlantItemData = dataSnapShot.data![index];

                  //Decode Base64 string to uint8List
                  Uint8List imageBytes =
                      base64Decode(eachPlantItemData.image.toString());

                  return Container(
                    margin: EdgeInsets.fromLTRB(
                      0,
                      index == 0 ? 16 : 8,
                      0,
                      index == dataSnapShot.data!.length - 1 ? 16 : 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.green.shade50,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 3),
                          blurRadius: 4,
                          color: Colors.green.shade900,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        //name + price
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //name  and price
                                Row(
                                  children: [
                                    //name
                                    Expanded(
                                      child: Text(
                                        eachPlantItemData.name!,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.green.shade900,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 0, right: 12),
                                  child: Text(
                                    "\Rs." +
                                        eachPlantItemData.price!
                                            .toStringAsFixed(2),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.purpleAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 0, right: 12),
                                  child: Text(
                                    "Quantity : " +
                                        tempListOfitemsdata[index][1]
                                            .toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.purpleAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 0, right: 12),
                                  child: Text(
                                    ("${tempListOfitemsdata[index][2]} X ${tempListOfitemsdata[index][1]} = ${tempListOfitemsdata[index][1] * tempListOfitemsdata[index][2]} ")
                                        .toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.purpleAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        //image
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(22),
                            topLeft: Radius.circular(22),
                            bottomLeft: Radius.circular(22),
                          ),
                          child: Container(
                            width: 170.0,
                            height: 130.0,
                            child: Image.memory(
                              imageBytes,
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                });
          } else {
            return const Center(
              child: Text("Empty, no data."),
            );
          }
        });
  }

  orderItemWidget_o(context) {
    return FutureBuilder(
      future: getOrderItems(),
      builder: (context, AsyncSnapshot<List<Plants>> dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (dataSnapShot.data == null || dataSnapShot.data!.isEmpty) {
          return const Center(child: Text("No item found"));
        }

        // Handle the data when it's valid
        return ListView.builder(
          itemCount: dataSnapShot.data!.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            // Safely access each plant item
            Plants eachPlantItemData = dataSnapShot.data![index];

            // Ensure that the image is not null before decoding
            String? plantImage = eachPlantItemData.image;
            if (plantImage != null) {
              Uint8List imageBytes = base64Decode(plantImage);
              return Container(
                margin: EdgeInsets.fromLTRB(
                  0,
                  index == 0 ? 16 : 8,
                  0,
                  index == dataSnapShot.data!.length - 1 ? 16 : 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.green.shade50,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 3),
                      blurRadius: 4,
                      color: Colors.green.shade900,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Content display as usual
                    // Safely access and display the plant's name and price
                  ],
                ),
              );
            } else {
              // Handle the case when the image is missing or invalid
              return Text("Image not available");
            }
          },
        );
      },
    );
  }
}
