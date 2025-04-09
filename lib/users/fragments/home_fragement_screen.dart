import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// import 'package:my_project/users/cart/cart_list_screen.dart';
// import 'package:my_project/users/item/search_items.dart';
import '../../api_connection/api_connection.dart';
import '../all_items/all_product_screen.dart';
import '../cart/cart_list_screen.dart';
import '../item/item_details_screen.dart';
import '../item/search_items.dart';
import '../model/plant_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class HomeFragementScreen extends StatelessWidget {
   HomeFragementScreen({super.key});

 final TextEditingController searchController=TextEditingController();

   Future<List<Plants>> getTrendingPlantItems() async
   {

     List<Plants> trendingPlantItemsList=[];
     var res=await http.post(
       Uri.parse(API.trending)
     );

     if(res.statusCode==200)
       {
         var responseBodyOfTrending=jsonDecode(res.body);
         if(responseBodyOfTrending["status"]=="success")
           {
             (responseBodyOfTrending["plantItemData"] as List).forEach((eachRecord)
                 {
                   trendingPlantItemsList.add(Plants.fromJson(eachRecord));
                 });

           }
       }
     else
       {
         Fluttertoast.showToast(msg: "error, status code is not 200");
       }

     return trendingPlantItemsList;
   }

   Future<List<Plants>> getAllPlantItems() async
   {

     List<Plants> allPlantItemsList=[];
     var res=await http.post(
         Uri.parse(API.all)
     );

     if(res.statusCode==200)
     {
       var responseBodyOfAllPlants=jsonDecode(res.body);
       if(responseBodyOfAllPlants["status"]=="success")
       {
         (responseBodyOfAllPlants["plantItemData"] as List).forEach((eachRecord)
         {
           allPlantItemsList.add(Plants.fromJson(eachRecord));
         });

       }
     }
     else
     {
       Fluttertoast.showToast(msg: "error, status code is not 200");
     }

     return allPlantItemsList;
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.green.shade100,
      // appBar: AppBar(
      //   title: Text("PlanTREE"),
      //   centerTitle: true,
      //   foregroundColor:  Colors.white,
      //   backgroundColor: Colors.green,
      // ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),

            //search bar widget
            showSearchBarWidget(),

            SizedBox(height: 10,),

            //trending items
            Padding(padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text("Trending Items",
                style: TextStyle(color: Colors.green.shade900,fontSize: 22,fontWeight: FontWeight.bold),
              ),
            ),


            trendingMostPopularItemWidget(context),



            //New items + all item
            Row(
              children: [
                Padding(padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text("New Items",
                    style: TextStyle(color: Colors.green.shade900,fontSize: 22,fontWeight: FontWeight.bold),
                  ),
                ),

                Spacer(),

                //all item
                TextButton(onPressed: (){
                  Get.to(AllItemScreen());
                }, child: Text("View All Items",style: TextStyle(fontSize: 22,color: Colors.blue.shade900),) ),

              ],
            ),
            allItemWidget(context),
          ],
        ),
      ),
    );
  }

 Widget showSearchBarWidget() {
    return Padding(
        padding: EdgeInsets.fromLTRB(10,10,10,10),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextField(
                style: TextStyle(color: Colors.green),
                controller: searchController,
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    onPressed: ()
                    {
                          Get.to(SearchItems(typedKeyWords: searchController.text));
                    },
                    icon: Icon(Icons.search,color: Colors.green,),
                  ),
                  hintText: "search best plants here...",
                    hintStyle: TextStyle(color: Colors.green.shade900,fontSize: 12),
                  // suffixIcon: IconButton(
                  //   onPressed: ()
                  //   {
                  //         Get.to(CartListScreen());
                  //   },
                  //   icon: Icon(
                  //     Icons.shopping_cart,
                  //     color: Colors.green,
                  //   ),
                  // ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Colors.green,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Colors.green,
                    ),
                  ),
                  focusedBorder:  OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Colors.green.shade900,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                  fillColor: Colors.green.shade50,
                  filled: true,
                ),
                  ),
            ),
            IconButton(
              onPressed: ()
              {
                Get.to(CartListScreen());
              },
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.green,
                size: 30,
              ),
            ),
          ],
        ),
    );
  }

   Widget  trendingMostPopularItemWidget(context) {
    return FutureBuilder(
        future: getTrendingPlantItems(),
        builder: (context,AsyncSnapshot<List<Plants>>dataSnapShot)
        {
          if(dataSnapShot.connectionState==ConnectionState.waiting)
            {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          if(dataSnapShot.data==null)
            {
              return const Center(
                child: Text("no trending item found"),
              );
            }
          if(dataSnapShot.data!.length>0)
            {
              return SizedBox(
                height:  310,
                child: ListView.builder(
                  itemCount: dataSnapShot.data!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index)
                        {
                          Plants eachPlantItemData=dataSnapShot.data![index];
                          //decode base64 string to uint8list
                          Uint8List imageBytes= base64Decode(eachPlantItemData.image.toString());

                          return GestureDetector(
                            onTap: ()
                            {
                              Get.to(ItemDetailsScreen(itemInfo: eachPlantItemData ));
                            },
                            child: Container(
                              width: 200,
                              margin: EdgeInsets.fromLTRB(
                                  index==0?10:8,
                                  10,
                                  index==dataSnapShot.data!.length-1?16:8,
                                  10,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.green.shade50,
                                boxShadow: [
                                  BoxShadow(offset: Offset(0,3),
                                blurRadius: 4,
                                color: Colors.green.shade900,
                                ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  //item image
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(22),
                                      topRight: Radius.circular(22),
                                      bottomRight: Radius.circular(22),
                                      bottomLeft: Radius.circular(22),
                                    ),
                                    child: Container(
                                      width: 200,
                                      height: 150,
                                      child: Image.memory(
                                        imageBytes,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),

                                  //item name and price
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Text(eachPlantItemData.name!,
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                  color: Colors.green.shade900,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text("\Rs. "+eachPlantItemData.price!.toString(),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.deepPurple,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),),
                                            ),
                                          ],
                                        ),
                                        //rating start & rating number
                                        Row(
                                          children: [
                                            RatingBar.builder(
                                              initialRating: eachPlantItemData.rating!,
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

                                            Text("("+eachPlantItemData.rating.toString()+")",
                                            style: TextStyle(color: Colors.grey),),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );

                        }
                ),
              );
            }
          else{
            return const Center(child: Text("Empty, no data"),);
          }
        },
    );
   }

   Widget allItemWidget( context) {
   return FutureBuilder(
      future: getAllPlantItems(),
      builder: (context,AsyncSnapshot<List<Plants>>dataSnapShot)
      {
        if(dataSnapShot.connectionState==ConnectionState.waiting)
        {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if(dataSnapShot.data==null)
        {
          return const Center(
            child: Text("no trending item found"),
          );
        }
        if(dataSnapShot.data!.length>0)
        {
          return ListView.builder(
              itemCount: 10,//dataSnapShot.data!.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context,index)
              {
                Plants eachPlantItemData=dataSnapShot.data![index];
                //decode base64 string to uint8list
                Uint8List imageBytes= base64Decode(eachPlantItemData.image.toString());

                return GestureDetector(
                  onTap: ()
                  {
                    Get.to(ItemDetailsScreen(itemInfo: eachPlantItemData ));

                  },
                  child: Container(

                    margin: EdgeInsets.fromLTRB(
                      10,
                      index==0?16:8,
                      16,
                      index==dataSnapShot.data!.length-1?16:8,

                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.green.shade50,
                      boxShadow: [
                        BoxShadow(offset: Offset(0,3),
                          blurRadius: 2,
                          color: Colors.green.shade900,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [

                        //item image
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(22),
                            topRight: Radius.circular(22),
                            bottomRight: Radius.circular(22),
                            bottomLeft: Radius.circular(22),
                          ),
                          child: Container(
                            width: 150,
                            height: 150,
                            child: Image.memory(
                              imageBytes,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),

                        Expanded(
                          child: Padding(
                          padding: EdgeInsets.only(left: 20,right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                //name
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(eachPlantItemData.name!,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.green.shade900,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                    ),
                                  ],
                                ),
                                //price
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text("\Rs. "+eachPlantItemData.price!.toString(),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        ),
                        ),
                          ],
                        ),
                    ),
                  );
              }
          );
        }
        else{
          return const Center(child: Text("Empty, no data"),);
        }
      },
    );
  }
}
