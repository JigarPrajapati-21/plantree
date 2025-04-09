import 'dart:convert';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
// import 'package:my_project/users/cart/cart_list_screen.dart';
// import 'package:my_project/users/controllers/item_details_controller.dart';
// import 'package:my_project/users/userPreferences/current_user.dart';

import '../../api_connection/api_connection.dart';
import '../cart/cart_list_screen.dart';
import '../controllers/item_details_controller.dart';
import '../model/plant_model.dart';
import '../userPreferences/current_user.dart';

class ItemDetailsScreen extends StatefulWidget {
  //const ItemDetailsScreen({super.key});
  final Plants? itemInfo;
  ItemDetailsScreen({this.itemInfo});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {

  final itemDetailsController =Get.put(ItemDetailsController());
  final currentOnlineUser =Get.put(CurrentUser());


  addItemToCart() async
  {

      var res = await http.post(
        Uri.parse(API.addToCart),
        body: {
          "user_id": currentOnlineUser.user.userId.toString(),
          "item_id": widget.itemInfo!.item_id.toString(),
          "quantity": itemDetailsController.quantity.toString(),
        },
      );
      if (res.statusCode == 200)
      {
        var resBodyOfAddCart = jsonDecode(res.body);
        if (resBodyOfAddCart['success'] == true) {
          Fluttertoast.showToast(msg: "item saved to Cart Successfully.");
        }
        else {
          Fluttertoast.showToast(
              msg: "Error Occur.Item not Saved to Cart and Try Again.");
        }

  }
    }


  validateFavoriteList() async
  {

    var res = await http.post(
      Uri.parse(API.validateFavorite),
      body: {
        "user_id": currentOnlineUser.user.userId.toString(),
        "item_id": widget.itemInfo!.item_id.toString(),
      },
    );    //print(res.statusCode.toString());
    if (res.statusCode == 200)
    {
      var resBodyOfValidateFavorite = jsonDecode(res.body);
      if (resBodyOfValidateFavorite['favoriteFound'] == true) {
       itemDetailsController.setisFavorite(true);
      }
      else {
        itemDetailsController.setisFavorite(false);
      }

    }
  }


  addItemToFavoriteList() async
  {

    var res = await http.post(
      Uri.parse(API.addFavorite),
      body: {
        "user_id": currentOnlineUser.user.userId.toString(),
        "item_id": widget.itemInfo!.item_id.toString(),
      },
    );
    if (res.statusCode == 200)
    {
      var resBodyOfAddFavorite = jsonDecode(res.body);
      if (resBodyOfAddFavorite['success'] == false) {
        Fluttertoast.showToast(msg: "item saved to your favorite list Successfully.");
        validateFavoriteList();
      }
      else {
        Fluttertoast.showToast(
            msg: "Error Occur.Item not Saved to your favorite list Try Again.");
      }

    }
  }

  deleteItemToFavoriteList() async
  {

    var res = await http.post(
      Uri.parse(API.deleteFavorite),
      body: {
        "user_id": currentOnlineUser.user.userId.toString(),
        "item_id": widget.itemInfo!.item_id.toString(),
      },
    );
    print(res.statusCode.toString());
    if (res.statusCode == 200)
    {
      var resBodyOfDeleteFavorite = jsonDecode(res.body);
      if (resBodyOfDeleteFavorite['success'] == false) {
        Fluttertoast.showToast(msg: "item deleted to your favorite list Successfully.");
        validateFavoriteList();
      }
      else {
        Fluttertoast.showToast(
            msg: "Error Occur.Item not deleted to your favorite list Try Again.");
      }

    }
  }

  @override
  void initState()
  {
    super.initState();
    validateFavoriteList();
  }

  @override
  Widget build(BuildContext context) {
    //decode base64 string to uint8list
    Uint8List imageBytes= base64Decode(widget.itemInfo!.image.toString());
    return Scaffold(
      body: Stack(
        children: [
            //item image
          GestureDetector(
            onTap: (){
              viewimg(context,imageBytes);
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.5,
              child: Image.memory(
                imageBytes,
                fit: BoxFit.fill,
              ),
            ),
          ),

          //item information
          Align(
            alignment: Alignment.bottomCenter,
            child: itemInfoWidget(),
          ),

          //3 button //back -favorite-  shopping cart
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  //back
                  IconButton(
                      onPressed: ()
                      {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.purpleAccent,
                        size: 30,
                      ) ,

                  ),







                  Spacer(),

                  //favorite
                  Obx(()=>IconButton(
                      onPressed: ()
                      {
                        if(itemDetailsController.isFavorite==true)
                          {
                            //delete from favorite
                            deleteItemToFavoriteList();
                          }
                        else
                          {
                            //save item to user favorite
                            addItemToFavoriteList();
                          }
                      },
                      icon: Icon(
                          itemDetailsController.isFavorite
                          ?Icons.bookmark :Icons.bookmark_border_outlined,
                        color: Colors.purpleAccent,
                      ),
                  )),

                  //shoping cart icon
                  IconButton(
                    onPressed: ()
                    {
                      Get.to(CartListScreen());
                    },
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.purpleAccent,
                    ) ,
                  ),

                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  itemInfoWidget() {
    return Container(
      height: MediaQuery.of(context).size.height*0.52,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0,-3),
            blurRadius: 6,
            color: Colors.green,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal:16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 18,),

            Center(
              child: Container(
                height: 8,
                width: 140,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),


            SizedBox(height: 30,),

            //name
            Text(widget.itemInfo!.name!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.green.shade900,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10,),

            //rating+rating number//price//description
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //rating+rating number
                // price
                // description
                //item counter
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //rating+rating number
                        Row(
                          children: [
                            RatingBar.builder(
                              initialRating: widget.itemInfo!.rating!,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemBuilder: (context,c)=>const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ), onRatingUpdate: (updateRating){},
                              ignoreGestures: true,
                              unratedColor: Colors.grey,
                              itemSize: 20,
                            ),
                            SizedBox(width: 8,),

                            Text("("+widget.itemInfo!.rating.toString()+")",
                              style: TextStyle(color: Colors.green,
                              ),
                            ),
                          ],
                        ),


                        SizedBox(height: 10,),

                        //price
                        Row(
                          children: [
                            SizedBox(height: 4,),
                            Text("\Rs. "+widget.itemInfo!.price!.toString(),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                ),

                //item counter buttom
                Obx(
                      ()=> Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      children: [
                        //+
                        IconButton(
                          onPressed:()
                          {
                            itemDetailsController.setQuantityItem(itemDetailsController.quantity + 1);
                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.green.shade900,
                            size: 22,
                          ),
                        ),

                        Text(
                          itemDetailsController.quantity.toString(),
                          style: TextStyle(
                              color: Colors.green.shade700
                          ),
                        ),

                        //-
                        IconButton(
                          onPressed:()
                          {
                            if(itemDetailsController.quantity -1 >= 1)
                            {
                              itemDetailsController.setQuantityItem(itemDetailsController.quantity -1 );
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
                ),


              ],
            ),

            SizedBox(height: 10,),

            //add to cart button
            Material(
              elevation: 4,
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: ()
                {
                  addItemToCart();
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Add to Cart",
                        style: TextStyle(fontSize: 20,color: Colors.white),
                      ),

                      SizedBox(width: 10,),

                      Icon(
                        Icons.shopping_cart_sharp,
                        color: Colors.white,
                        size: 22,
                      ),

                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 10,),

            //description
            ExpansionTile(
              initiallyExpanded: true,
                backgroundColor: Colors.white,
              collapsedBackgroundColor: Colors.green.shade50,
              iconColor: Colors.green.shade900,
              subtitle: Text("Description"),
              tilePadding: EdgeInsets.symmetric(horizontal: 6),
              //initiallyExpanded: true,
              title: Text(
                'View Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900,
                ),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    widget.itemInfo?.description ?? 'No description available',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green.shade900,
                    ),
                  ),
                ),
              ],

            ),




          ],
        ),
      ),
    );
  }

  void viewimg(BuildContext context, Uint8List imageBytes) {
    showDialog(context: context, builder: (BuildContext context){
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(0)),
        child: Container(
          height: MediaQuery.of(context).size.height*0.7,
          width: MediaQuery.of(context).size.width,
          child: Image.memory(
            imageBytes,
            height: MediaQuery.of(context).size.height*0.5,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
          ),
        ),
      );
    });
  }
}
