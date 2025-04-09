import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
// import 'package:my_project/users/fragments/dashboard_of_fregments.dart';
// import 'package:my_project/users/userPreferences/current_user.dart';
import 'package:http/http.dart' as http;
import '../../api_connection/api_connection.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';

import '../fragments/dashboard_of_fregments.dart';
import '../userPreferences/current_user.dart';




class OrderConfirmationScreen extends StatelessWidget {


  final List<int>selectedCartIDs;
  final List<Map<String,dynamic>>selectedCartListItemsInfo;
  final double totalAmount;
  final String deliverySystem;
  final String paymentSystem;
  final String phoneNumber;
  final String name;
  final String shipmentAddress;
  final String note;
  final List itemsdata;

  OrderConfirmationScreen({
    required this.selectedCartIDs,
    required this.selectedCartListItemsInfo,
    required this.totalAmount,
    required this.deliverySystem,
    required this.paymentSystem,
    required this.name,
    required this.phoneNumber,
    required this.shipmentAddress,
    required this.note,
    required this.itemsdata,
  });
   RxList<int>_imageSelectedByte= <int>[].obs;

  Uint8List get imageSelectedByte => Uint8List.fromList(_imageSelectedByte);
   RxString _imageSelectedName = "".obs;

  String get imageSelectedName => _imageSelectedName.value;
  final ImagePicker _picker = ImagePicker();
  CurrentUser currentUser =Get.put(CurrentUser());

  setSelectedImage(Uint8List selectedImage){
    _imageSelectedByte.value = selectedImage;
  }
  setSelectedImageName(String selectedImageName){
    _imageSelectedName.value = selectedImageName;
  }

  chooseImageFromGallery()async
  {
    final pickedImageXFile = await _picker.pickImage(
        source:ImageSource.gallery);

    if(pickedImageXFile != null){
      final bytesOfImage =await pickedImageXFile.readAsBytes();

      setSelectedImage(bytesOfImage);
      setSelectedImageName(path.basename(pickedImageXFile.path));
    }
  }

  String status="new";


  Future<void> saveNewOrderInfo() async {
    String selectedItemsString = selectedCartListItemsInfo!
        .map((eachSelectedItem) => jsonEncode(eachSelectedItem))
        .toList()
        .join("||");

    try {
      var res = await http.post(
        Uri.parse(API.addOrder),
        body: {
          "user_id": currentUser.user.userId.toString(),
          "deliverySystem": deliverySystem,
          "paymentSystem": paymentSystem,
          "note": note,
          "totalAmount": totalAmount.toString(),
          "image": base64Encode(imageSelectedByte),
          "shipmentAddress": shipmentAddress,
          "name":name,
          "phoneNumber": phoneNumber,
          "itemsData": itemsdata.toString(), // Ensure this is the correct data type
        },
      );
      print("user_id" + currentUser.user.userId.toString());

      // print("selectedItems"+selectedItemsString.toString());
      print("deliverySystem" + deliverySystem.toString());
      print("paymentSystem"+paymentSystem.toString());
      print("note"+note.toString());
      print("totalAmount"+totalAmount.toString());
      print("image" +base64Encode(imageSelectedByte));
      print("shipmentAddress"+shipmentAddress.toString());
      print("phoneNumber"+ phoneNumber.toString());
      print("itemsdata"+itemsdata.toString());
      print("Response: ${res.body}");

      if (res.statusCode == 200) {
        var responseBody = jsonDecode(res.body);
        if (responseBody["success"] == true) {
          // Handle success (e.g., update UI or show confirmation)
          selectedCartIDs!.forEach((eachSelectedItemCartId) {
            deleteSelectedItemsFromCartList(eachSelectedItemCartId);
          });
        } else {
          // Handle failure (e.g., show error message)
          print("Error: ${responseBody["message"]}");
        }
      } else {
        // Handle other status codes
        print("Error: Server returned status code ${res.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
      // Handle network or other errors
    }
  }







  saveNewOrderInfo_o() async
  {
    var url=Uri.parse(API.addOrder);
    var response=await http.post(url,body:{

      "user_id":currentUser.user.userId.toString().trim(),
      "deliverySystem":deliverySystem.trim(),
      "paymentSystem":paymentSystem.trim(),
      "note":note.trim(),
      "totalAmount":totalAmount.toString().trim(),
      "image":base64Encode(imageSelectedByte).trim(),
      "shipmentAddress":shipmentAddress.trim(),
      "phoneNumber":phoneNumber.trim(),
      "itemsdata":itemsdata.toString().trim(),
    });

    if(response.statusCode==200)
    {
      var responseBody= jsonDecode(response.body);

      if(responseBody['success']==true){
        Fluttertoast.showToast(msg: " successfull",
          fontSize: 16,
          backgroundColor: Colors.white,
          gravity: ToastGravity.TOP,
          textColor: Colors.black,
          toastLength: Toast.LENGTH_SHORT,
        );

      }else if(responseBody['status']=='error')
      {
        Fluttertoast.showToast(msg: " not successfull",
          fontSize: 16,
          backgroundColor: Colors.white,
          gravity: ToastGravity.TOP,
          textColor: Colors.black,
          toastLength: Toast.LENGTH_SHORT,
        );
      }else
      {
        Fluttertoast.showToast(msg: "Unexpected response",
          fontSize: 16,
          backgroundColor: Colors.white,
          gravity: ToastGravity.TOP,
          textColor: Colors.black,
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } else{
      print(response.statusCode.toString());
      Fluttertoast.showToast(msg: "Server error",
        fontSize: 16,
        backgroundColor: Colors.white,
        gravity: ToastGravity.TOP,
        textColor: Colors.black,
        toastLength: Toast.LENGTH_SHORT,
      );
    }

  }


  saveNewOrderInfo_old()async
  {
    String selectedItemsString = selectedCartListItemsInfo!.map((
        eachSelectedItem) => jsonEncode(eachSelectedItem)).toList().join("||");

    try
    {
      var res = await http.post(
          Uri.parse(API.addOrder),
          body:{
            "user_id" : currentUser.user.userId.toString(),
            "deliverySystem" : deliverySystem,
            "paymentSystem":paymentSystem,
            "note":note,
             "totalAmount":totalAmount.toString(),
            "image":base64Encode(imageSelectedByte),
            "shipmentAddress":shipmentAddress,
            "phoneNumber": phoneNumber,
            "itemsdata":itemsdata.toString(),
          });


      print("user_id" + currentUser.user.userId.toString());

  // print("selectedItems"+selectedItemsString.toString());
  print("deliverySystem" + deliverySystem.toString());
  print("paymentSystem"+paymentSystem.toString());
  print("note"+note.toString());
  print("totalAmount"+totalAmount.toString());
  print("image" +base64Encode(imageSelectedByte));
  print("shipmentAddress"+shipmentAddress.toString());
  print("phoneNumber"+ phoneNumber.toString());
  print("itemsdata"+itemsdata.toString());



      print("total: ::$totalAmount");
      print(res.statusCode);

      if(res.statusCode == 200){
        //print("Response:${res.body}");
         try {
           var responseBodyOfAddNewOrder = jsonDecode(res.body);
           print(responseBodyOfAddNewOrder["success"]);


           print(res.body);

           if (responseBodyOfAddNewOrder["success"] == true) {
             selectedCartIDs!.forEach((eachSelectedItemCartId) {
               deleteSelectedItemsFromCartList(eachSelectedItemCartId);
             });
           } else {
             Fluttertoast.showToast(
                 msg: "Error: your new order was not placed.");
           }
         }catch(e){
           Fluttertoast.showToast(msg: "invalid response from server:${res.body}");
         }
      }else{
        Fluttertoast.showToast(msg: "Error,Status Code is not 200:${res.statusCode}");
      }
    }catch(errorMsg){
      print("error1111 :: $errorMsg");
      Fluttertoast.showToast(msg: "Error:$errorMsg");
    }
  }

  deleteSelectedItemsFromCartList(int cartID)async
  {
    try{
      var res =await http.post(
          Uri.parse(API.deleteSelectedItemsFromCartList),
          body:
          {
            "cart_id":cartID.toString(),
          }
      );
      if(res.statusCode == 200){
        var responseBodyFromDeleteCart = jsonDecode(res.body);
        if(responseBodyFromDeleteCart["success"]==true){
          Fluttertoast.showToast(msg: "your new order has been placed Successfully.");

          Get.to(DashboardOfFragments());
        }
      }else
      {
        Fluttertoast.showToast(msg: "Error, Status Code is not 200");
      }
    }
    catch(errorMessage)
    {
      print("Error:"+errorMessage.toString());

      Fluttertoast.showToast(msg: "Error:"+errorMessage.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //image
            // Image.asset(
            //   "assets/iconimag1.jpg",
            //   width: 130,
            // ),
            const SizedBox(height: 4,),

            //titte
            Padding(
              padding:EdgeInsets.all(8.0),
              child: Text(
                "Please Attach Transaction \nProof ScreenShot/Image",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green.shade900,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 30,),

            //select Image btn
            Material(
              elevation: 8,
              color: Colors.purpleAccent,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                onTap:(){
                  chooseImageFromGallery();
                },
                borderRadius: BorderRadius.circular(30),
                child: const Padding(
                  padding:EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  child: Text("Select Image",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16,),

            //display selected Image by user
            Obx(() =>
                ConstrainedBox(
                  constraints:BoxConstraints(
                    maxWidth: MediaQuery
                        .of(context)
                        .size
                        .width * 0.7,
                    maxHeight: MediaQuery
                        .of(context)
                        .size
                        .width * 0.6,
                  ) ,
                  child: imageSelectedByte.length > 0
                      ?Image.memory(imageSelectedByte,fit: BoxFit.contain,)
                      : const Placeholder(color: Colors.white60,),
                ),
            ),
            const SizedBox(height: 16,),

            //confirm and proceed
            Obx(() =>
                Material(
                  elevation: 8,
                  color: imageSelectedByte.length > 0
                      ? Colors.purpleAccent
                      :Colors.grey,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: (){
                      if(imageSelectedByte.length > 0){
                        //save order info
                        saveNewOrderInfo();
                      }
                      else{
                        Fluttertoast.showToast(msg: "Please attach the transaction proof / screenshot.");
                      }
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: const Padding(
                      padding:EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ) ,
                      child: Text(
                        "Confirmed & Proceed",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
