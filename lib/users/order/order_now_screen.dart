import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
// import 'package:my_project/users/controllers/order_now_controller.dart';

import '../controllers/order_now_controller.dart';
import 'order_confirmation.dart';

class OrderNowScreen extends StatelessWidget {
// const OrderNowScreen({super.key, required this.selectedCartListItemsInfo, required this.totalAmount, required this.selectedCartIDs});

  RegExp regexOfPhoneNumber = RegExp(r'^[0-9]{10}$'); //for only 10 digit

  final List<Map<String, dynamic>> selectedCartListItemsInfo;
  final double totalAmount;
  final List<int> selectedCartIDs;
  final List itemsdata;

  OrderNowController orderNowController = Get.put(OrderNowController());
  List<String> deliverySystemNamesList = [
    "FedEx",
    "DHL",
    "United parcel Service"
  ];
  List<String> paymentSystemNamesList = [
    "Apple Pay",
    "Wire Transfer",
    "Google Pay"
  ];

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController shipmentAddressController = TextEditingController();
  TextEditingController noteToSellerController = TextEditingController();



  OrderNowScreen({
    required this.selectedCartListItemsInfo,
    required this.totalAmount,
    required this.selectedCartIDs,
    required this.itemsdata,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          titleTextStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),
          title: const Text("Order Now"),
          titleSpacing: 0,
          foregroundColor: Colors.white,
        ),
        body: ListView(
          children: [
            //display item from cart list
            displayItemsFromUserCart(),

            const SizedBox(
              height: 30,
            ),

            //delivery system
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Delivery System:',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: deliverySystemNamesList.map((deliverySystemName) {
                  return Obx(
                    () => RadioListTile<String>(
                      tileColor: Colors.green.shade100,
                      dense: true,
                      activeColor: Colors.green.shade900,
                      title: Text(
                        deliverySystemName,
                        style: TextStyle(
                            fontSize: 16, color: Colors.green.shade900),
                      ),
                      value: deliverySystemName,
                      groupValue: orderNowController.deliverySys,
                      onChanged: (newDeliverySystemValue) {
                        orderNowController
                            .setDeliverySystem(newDeliverySystemValue!);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            // payment system
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Payment System:',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Company Account Number /D: \nY87Y-HJF9-CVBN-4321 ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: paymentSystemNamesList.map((paymentSystemName) {
                  return Obx(
                    () => RadioListTile<String>(
                      tileColor: Colors.green.shade100,
                      dense: true,
                      activeColor: Colors.green.shade900,
                      title: Text(
                        paymentSystemName,
                        style: TextStyle(
                            fontSize: 16, color: Colors.green.shade900),
                      ),
                      value: paymentSystemName,
                      groupValue: orderNowController.paymentSys,
                      onChanged: (newPaymentSystemValue) {
                        orderNowController
                            .setPaymentSystem(newPaymentSystemValue!);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),




            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Full Name:',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                controller: nameController,
                validator: (val) => val == ""
                    ? "plz write name"
                    : (!regexOfPhoneNumber.hasMatch(val!))
                        ? "Please Enter valid Phone number..."
                        : null,
                decoration: InputDecoration(
                  hintText: 'Full Name..',
                  hintStyle: const TextStyle(
                    color: Colors.green,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.green,
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.green,
                      width: 2,
                    ),
                  ),

                ),

              ),
            ),


            const SizedBox(height: 16),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Phone Number:',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                controller: phoneNumberController,
                validator: (val) => val == ""
                    ? "plz write Phone number"
                    : (!regexOfPhoneNumber.hasMatch(val!))
                    ? "Please Enter valid Phone number..."
                    : null,
                decoration: InputDecoration(
                  hintText: 'Contact Number..',
                  hintStyle: const TextStyle(
                    color: Colors.green,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.green,
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.green,
                      width: 2,
                    ),
                  ),

                ),

              ),
            ),

            const SizedBox(height: 16),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Shipment Address:',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: TextField(
                maxLines: 4,
                // style: TextStyle(color: Colors.green),
                controller: shipmentAddressController,
                decoration: InputDecoration(
                    hintText: 'You Shipment Address..',
                    hintStyle: const TextStyle(
                      color: Colors.green,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.green,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Colors.green, width: 2))),
              ),
            ),

            const SizedBox(height: 16),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Note to Seller: (Optional)',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: TextField(
                maxLines: 3,
                // style: const TextStyle(color: Colors.green),
                controller: noteToSellerController,
                decoration: InputDecoration(
                  hintText: 'Any note you want to write to seller..',
                  hintStyle: const TextStyle(
                    color: Colors.green,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.green, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.green, width: 2),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // pay amount now btn
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Material(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  onTap: () {
                    if (nameController.text.isNotEmpty &&phoneNumberController.text.isNotEmpty &&
                        shipmentAddressController.text.isNotEmpty) {

                      if(!RegExp(r'^[0-9]{10}$').hasMatch(phoneNumberController.text)){
                       Fluttertoast.showToast(msg: "enter valid phone number");
                      }else{
                        print("selectCartIDs:" + selectedCartIDs.toString());
                        print("selectCartListItemsInfo:" +
                            selectedCartListItemsInfo.toString());
                        print("totalAmount:" + totalAmount.toString());

                        print("deliverySystem:" + orderNowController.deliverySys);
                        print("paymentSystem:" +
                            orderNowController.paymentSys.toString());
                        print("phoneNmuber:" + phoneNumberController.text);

                        print(
                            "shipmentAddress:" + shipmentAddressController.text);
                        print("note:" + noteToSellerController.text);

                        Get.to(OrderConfirmationScreen(
                          selectedCartIDs: selectedCartIDs,
                          selectedCartListItemsInfo: selectedCartListItemsInfo,
                          totalAmount: totalAmount,
                          deliverySystem: orderNowController.deliverySys,
                          paymentSystem: orderNowController.paymentSys,
                          name:nameController.text,
                          phoneNumber: phoneNumberController.text,
                          shipmentAddress: shipmentAddressController.text,
                          note: noteToSellerController.text,
                          itemsdata: itemsdata,
                        ));
                      }


                    } else {
                      Fluttertoast.showToast(msg: "Please complete the form.");
                    }
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Rs." + totalAmount!.toStringAsFixed(2),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "Pay Amount Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ));
  }

  displayItemsFromUserCart() {
    return Column(
      children: List.generate(selectedCartListItemsInfo!.length, (index) {
        Map<String, dynamic> eachSelectItem = selectedCartListItemsInfo![index];

        //  Decode Base64 String to uint8List
        Uint8List imageBytes =
            base64Decode(selectedCartListItemsInfo[index]['image']);
        // print("selectedCartListItemsInfo"+selectedCartListItemsInfo.toString());
        var totalAmount = eachSelectItem["price"] * eachSelectItem["quantity"];

        return Container(
          margin: EdgeInsets.fromLTRB(
            16,
            index == 0 ? 16 : 8,
            16,
            index == selectedCartListItemsInfo!.length - 1 ? 16 : 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.green.shade50,
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 0),
                blurRadius: 6,
                color: Colors.black26,
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(22),
                  //bottomRight: Radius.circular(22),
                  topLeft: Radius.circular(22),
                  bottomLeft: Radius.circular(22),
                ),
                child: Container(
                  width: 130.0,
                  height: 130.0,
                  child: Image.memory(
                    imageBytes,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //name
                    Text(
                      eachSelectItem["name"],
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.green.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    //const SizedBox(height: 16),
                    Row(
                      children: [
                        //price
                        Text(
                          "Rs." +
                              totalAmount
                                  .toString(), //eachSelectedItem["price"].toString(),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.purpleAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),

                        //quantity
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Quantity : " + eachSelectItem["quantity"].toString(),
                            style: const TextStyle(
                                fontSize: 18, color: Colors.purpleAccent),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      eachSelectItem["price"].toString() +
                          " x " +
                          eachSelectItem["quantity"].toString() +
                          " = " +
                          totalAmount.toString(),
                      //  eachSelectItem["toatalAmount"].toString(),
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ))
            ],
          ),
        );
      }),
    );
  }
}
