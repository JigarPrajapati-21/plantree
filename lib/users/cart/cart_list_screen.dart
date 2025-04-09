import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
// import 'package:my_project/users/item/item_details_screen.dart';
// import 'package:my_project/users/userPreferences/current_user.dart';
import 'package:http/http.dart' as http;
import '../../api_connection/api_connection.dart';
import '../item/item_details_screen.dart';
import '../model/cart_model.dart';
import '../model/plant_model.dart';
import '../order/order_now_screen.dart';
import '../userPreferences/current_user.dart';

class CartListScreen extends StatefulWidget {
  const CartListScreen({super.key});

  @override
  State<CartListScreen> createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen> {

  final currentOnlineUser = Get.put(CurrentUser());
  // fine CartListController = Get.put(cartListController());

  RxDouble subtotal =0.0.obs;

  //List<Cart>cart_List=[];
  RxList<Cart>cart_List=<Cart>[].obs;
  List itemsdata=[];

  getCurrentUserCartList()async
  {
    List<Cart>cartListOfCurrentUser = [];
    double total=0;

    try
     {
    var res =await http.post(
        Uri.parse(API.getCartList),
        body:
        {
          "currentOnlineUserID":currentOnlineUser.user.userId.toString(),
        }
    );
    //print(res.body.toString());
    if(res.statusCode == 200)
    {
      //print(res.body.toString());
      var responseBodyOfGetCurrentUserCartItems =jsonDecode(res.body);
      if(responseBodyOfGetCurrentUserCartItems['success'] == true)
      {
        (responseBodyOfGetCurrentUserCartItems['currentUserCartData'] as List).forEach((eachCurrentUserCartData)
        {


          itemsdata.add([eachCurrentUserCartData['item_id'],
          eachCurrentUserCartData['quantity'],
          eachCurrentUserCartData['price']],);

          //print(eachCurrentUserCartData);
          print(eachCurrentUserCartData['name']);
          print(eachCurrentUserCartData['quantity']+
              eachCurrentUserCartData['quantity'].runtimeType.toString());
          print(eachCurrentUserCartData['price']+
              eachCurrentUserCartData['price'].runtimeType.toString());

          total+=(double.parse(eachCurrentUserCartData['price'])*
              double.parse(eachCurrentUserCartData['quantity']));

          cartListOfCurrentUser.add(Cart.fromJson(eachCurrentUserCartData));

        });
      }
      else
      {

        Fluttertoast.showToast(msg:"your Cart List is Empty.");
      }

      cart_List.value=cartListOfCurrentUser;
      //print("Cart List:${cart_List.value}");
      //cartListController.setList(cartListOfCurrentUser);
    }
    else
    {
      Fluttertoast.showToast(msg:"Status Code is not 200");
    }

    }
    catch(errorMsg)
    {
     Fluttertoast.showToast(msg:"Error::"+errorMsg.toString());
      print(errorMsg.toString());
    }

    subtotal.value= total;
    print("Subtotal is ::"+subtotal.toString());
    //  print("Total of cart::"+subtotal.toString());
    //  calculateToatalAmount();
  }

  deleteItemsFromUserCartList(int cartID) async
  {
    try
    {
      var res = await http.post(
          Uri.parse(API.deleteSelectedItemsFromCartList),
          body:
          {
            "cart_id":cartID.toString(),
          }
      );
      if(res.statusCode==200)
      {
        var responseBodyFromDeleteCart = jsonDecode(res.body);
        if(responseBodyFromDeleteCart['success']==true)
        {
          Fluttertoast.showToast(msg:"Item Deleted from Cart List");
          getCurrentUserCartList();
        }
      }
      else
      {
        Fluttertoast.showToast(msg:"Error,Status Code is not 200");
      }
    }
    catch(errorMassage)
    {
     // print("Error:" + errorMassage.toString());
      Fluttertoast.showToast(msg:"Error:$errorMassage");
    }
  }

  //comment


  updateQuantityInUserCart(int cartId, int newQuntity) async
  {
    try
    {
      var res = await http.post(
          Uri.parse(API.updateItemInCartList),
          body:
          {
            "cart_id":cartId.toString(),
            "quantity":newQuntity.toString(),
          }
      );
      if(res.statusCode == 200)
      {
        var responseBodyOfUpdateQuantity = jsonDecode(res.body);

        if(responseBodyOfUpdateQuantity["success"]==true)
        {
          getCurrentUserCartList();
        }
      }
      else
      {
        Fluttertoast.showToast(msg:"Error. Status Code is not 200");
      }
    }
    catch(errorMessage)
    {
      print("Error:"+ errorMessage.toString());
      Fluttertoast.showToast(msg:"Error:"+ errorMessage.toString());
    }
  }


  @override
  void initState()
  {
    super.initState();
    getCurrentUserCartList();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: Text(
          "My Cart",
          style: TextStyle(color: Colors.white),
        ),
        // actions: [
        //   //to select all items
        //   Obx(()=>
        //   IconButton(
        //
        //       onPressed: ()
        //       {
        //           cartListController.setIsSelectedAllItems();
        //           cartListController.clearAllSelectedItems();
        //
        //           if(cartListController.isSelectedAll)
        //             {
        //               cartListController.cartList.forEach((eachItem)
        //               {
        //                 cartListController.addSelectedItem(eachItem.cart_id!);
        //               });
        //             }
        //           calculateTotalAmount();
        //       },
        //       icon: Icon(
        //         cartListController.isSelectedAll ? Icons.check_box : Icons.check_box_outline_blank,
        //         color: cartListController.isSelectedAll ? Colors.white: Colors.white ,
        //       ),
        //   ),
        //   ),
          //to delete selected item/items
          // GetBuilder(
          //   init: CartListController(),
          //     builder: (c)
          //     {
          //       if(cartListController.selectedItemList.length > 0)
          //         {
          //           return IconButton(
          //               onPressed: () async
          //               {
          //                 var responseFromDialogBox=await Get.dialog(
          //                   AlertDialog(
          //                     backgroundColor: Colors.grey,
          //                     title: Text("Delete"),
          //                     content: Text("Are you sure to Delete selected items from your cart list?"),
          //                     actions: [
          //                       TextButton(
          //                           onPressed: ()
          //                           {
          //                             Get.back();
          //                           },
          //                           child: Text("No",
          //                           style: TextStyle(
          //                             color: Colors.black
          //                           ),
          //                           ),
          //                       ),
          //
          //                       TextButton(
          //                         onPressed: ()
          //                         {
          //                           Get.back(result: "yesDelete");
          //                         },
          //                         child: Text("Yes",
          //                           style: TextStyle(
          //                               color: Colors.black,
          //                           ),
          //                         ),
          //                       ),
          //
          //                     ],
          //                   )
          //                 );
          //                 if(responseFromDialogBox=="yesDelete")
          //                   {
          //                     cartListController.selectedItemList.forEach((selectedItemUserCartID)
          //                     {
          //                       //delete selected item now
          //                       deleteSelectedItemsFromUserCartList(selectedItemUserCartID);
          //                     });
          //                   }
          //                 calculateTotalAmount();
          //               },
          //               icon: Icon(
          //                 Icons.delete_sweep,
          //                 size: 40,
          //                 color: Colors.red,
          //               ),
          //           );
          //         }
          //       else
          //         {
          //           return Container();
          //         }
          //     }
          // ),


       // ],
      ),
      body: Obx(()=>
      cart_List.length > 0
          ? ListView.builder(
          itemCount: cart_List.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context,index)
            {
              Cart cartModel=cart_List[index];

              Plants plantsModel=Plants(
                item_id: cartModel.item_id,
                image: cartModel.image,
                name: cartModel.name,
                price: cartModel.price,
                rating: cartModel.rating,
                description: cartModel.description,
                tags: cartModel.tags,
              );

              //decode base64 string to uint8list
              Uint8List imageBytes= base64Decode(plantsModel.image.toString()) as Uint8List;


              return SizedBox(
                width: MediaQuery.of(context).size.width,

                child: Row(
                  children: [
                    //check box
                    // GetBuilder(
                    //     init: CartListController(),
                    //     builder: (c)
                    //     {
                    //       return IconButton(
                    //           onPressed: ()
                    //           {
                    //             if(cartListController.selectedItemList.contains(cartModel.cart_id))
                    //               {
                    //                 cartListController.deleteSelectedItem(cartModel.cart_id!);
                    //               }
                    //             else
                    //               {
                    //                 cartListController.addSelectedItem(cartModel.cart_id!);
                    //               }
                    //             calculateTotalAmount();
                    //           },
                    //           icon: Icon(
                    //             cartListController.selectedItemList.contains(cartModel.cart_id)
                    //                 ? Icons.check_box
                    //                 : Icons.check_box_outline_blank,
                    //             color: cartListController.isSelectedAll
                    //             ? Colors.green
                    //             :Colors.green,
                    //           ) ,
                    //       );
                    //     },
                    // ),


                    //name
                    //price
                    //+2-
                    //image

                    Expanded(
                        child: GestureDetector(
                          onTap: ()
                          {
                            Get.to(ItemDetailsScreen(itemInfo: plantsModel));
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(16,
                                index==0?16:8,
                                16,
                                index==cart_List.length -1 ?16 :8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.green.shade50,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0,0),
                                  blurRadius: 4,
                                  color: Colors.green.shade900,
                                ),
                              ]
                            ),
                            child: Row(
                              children: [
                                //name
                                //price
                                //+2-
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        //name
                                        Text(
                                          plantsModel.name.toString(),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.green.shade900,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        SizedBox(height: 4,),

                                        //price
                                        Padding(
                                          padding: const EdgeInsets.only(left: 0,right: 12),
                                          child: Text(
                                            "Rs. "+plantsModel.price.toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.purpleAccent,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),

                                        //+2-
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade50,
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          child: Row(
                                            children: [

                                              //delete item to cart
                                              IconButton(
                                                onPressed:()
                                                {
                                                 // Fluttertoast.showToast(msg: "item deleted to cart");
                                                  deleteItemsFromUserCartList(cart_List[index].cart_id!);
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                  size: 26,
                                                ),
                                              ),


                                              //+
                                              IconButton(
                                                onPressed:()
                                                {
                                                  updateQuantityInUserCart(
                                                    cartModel.cart_id!,
                                                    cartModel.quantity! + 1,
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.add,
                                                  color: Colors.green.shade900,
                                                  size: 22,
                                                ),
                                              ),

                                              Text(
                                                cartModel.quantity.toString(),
                                                style: TextStyle(
                                                    color: Colors.green.shade700
                                                ),
                                              ),

                                              //-
                                              IconButton(
                                                onPressed:()
                                                {
                                                  if(cartModel.quantity! -1 >=1)
                                                  {
                                                    updateQuantityInUserCart(
                                                      cartModel.cart_id!,
                                                      cartModel.quantity! - 1,
                                                    );
                                                  }
                                                },
                                                icon: Icon(
                                                  Icons.remove,
                                                  color: Colors.green.shade900,
                                                  size: 22,
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),


                                      ],
                                    ),



                                  ),
                                ),



                                //item image
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(22),
                                    topLeft: Radius.circular(22),
                                    bottomLeft: Radius.circular(22),
                                   bottomRight: Radius.circular(22),
                                  ),
                                  child: Container(
                                    width: 180,
                                    height: 180,
                                    child: Image.memory(
                                      imageBytes,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              ],
                            ),

                          ),
                        )
                    ),

                  ],
                ),

              );


            }
        )
            :Center(
          child: Text("Cart is Empty"),
        ),
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          boxShadow: [
            BoxShadow(
              offset: Offset(0,-3),
              color: Colors.white24,
              blurRadius: 6,
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
        child: Row(
          children: [
            //total amount
            Text(
              "Total Amount : ",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(width: 4,),

            Obx(()=>
              Text(
                "Rs. ${subtotal.value.toStringAsFixed(2)}",
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Spacer(),

            //order now btn ---> if product is availale in cart list then button will display cart empty

            Material(
              color: Colors.deepOrange, //cart_List.isNotEmpty ? :Colors.white24,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                onTap: ()
                {

                  //convert cart_List into listof maps and ensure not-null
                  List<Map<String,dynamic>> cartMapList=cart_List.map((cart) => cart.toMap()).toList();

                  //get cart ids and filter out any potential null values.
                  List<int> cartIds=cart_List.map((cart) => cart.cart_id).whereType<int>().toList();


                  // print(cartMapList);
                  // print(subtotal.value.toDouble());
                  // print(cartIds);

                  //proceed only if cart_List has item
                  if(cart_List.isNotEmpty){
                    Get.to(
                      OrderNowScreen(

                        selectedCartListItemsInfo: cartMapList,
                        totalAmount: subtotal.value.toDouble(),
                        selectedCartIDs: cartIds,
                        itemsdata: itemsdata,
                      )
                    );
                  }else{
                    Fluttertoast.showToast(msg: "Your cart is empty");
                  }




                  // print(cart_List);
                  // print("Total of cart ::: "+subtotal.toString());
                  //
                  // //  cart_List.map((Cart)=>Cart.cart_id).toList()  ------->its fetch all cartid from cart list
                  // print("cart id from cartlist ::: "+ cart_List.map((Cart)=>Cart.cart_id).toList().toString());

                  // cartListController.selectedItemList.length>0
                  //     ? Get.to(OrderNowScreen(
                  //   selectedCartListItemsInfo:getSelectedCartListItemsInformation(),
                  //   totalAmount: cartListController.total,
                  //   selectedCartIDs:cartListController.selectedItemList,
                  // ))
                  //     :null;
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                  child: Text("Order Now",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),),
                ),
              ),
            ),





          ],
        ),
      ),

    );
  }
}


