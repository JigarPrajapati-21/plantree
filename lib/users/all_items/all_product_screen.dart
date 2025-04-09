import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../api_connection/api_connection.dart';
import '../item/item_details_screen.dart';
import '../model/plant_model.dart';
// import 'package:my_project/api_connection/api_connection.dart';
// import 'package:my_project/users/fragments/home_fragement_screen.dart';
// import 'package:my_project/users/item/item_details_screen.dart';
// import 'package:my_project/users/model/plant_model.dart';

class AllItemScreen extends StatelessWidget {
  List<Plants> temp =[];

  Future<List<Plants>> getAllItems() async
  {
    List<Plants> allItemsList =[];
    var res = await http.post(
        Uri.parse(API.getAllItems)
    );
    if(res.statusCode == 200)
    {


      var responseBodyOfAllItems=jsonDecode(res.body);
      if(responseBodyOfAllItems["status"]=="success")
      {
        (responseBodyOfAllItems["allItemData"] as List).forEach((eachRecord)
        {
          allItemsList.add(Plants.fromJson(eachRecord));
        });

      }

  }
  else
    {
    Fluttertoast.showToast(msg: "Error, status code is not 200");
    }
    temp=allItemsList;
  print(temp);
//  print(allItemsList);
    return allItemsList;
  }


  Future<List<Plants>> getAllPlantItems() async
  {

    List<Plants> allPlantItemsList=[];
    var res=await http.get(
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
    temp=allPlantItemsList;
    return allPlantItemsList;
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Items"),
        backgroundColor: Colors.green,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: allPlantItemWidget(context),
      ),
    );
  }
  Widget allPlantItemWidget(BuildContext context){
    return FutureBuilder(
        future: getAllPlantItems(),//getAllItems(),
        builder: (context,AsyncSnapshot<List<Plants>> dataSnapShot){
          if(dataSnapShot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(dataSnapShot.data == null){
            return const Center(
              child: Text(
                "No  item found",
              ),
            );
          }
          if(dataSnapShot.data!.isNotEmpty)
          {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 0.6, // adjust as needed
                        ),
                        itemCount: dataSnapShot.data!.length,
                        itemBuilder: (context,index){
                          Plants eachPlantItemData = dataSnapShot.data![index];

                          //decode base64 string to uint8list
                          Uint8List imageBytes= base64Decode(eachPlantItemData.image.toString());
                          return GestureDetector(
                            onTap: (){
                              Get.to(ItemDetailsScreen(itemInfo:eachPlantItemData));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.green.shade50,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0,3),
                                    blurRadius: 2,
                                    color: Colors.green.shade900,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // item image
                                  ClipRRect(
                                    borderRadius:  const BorderRadius.only(
                                      topLeft: Radius.circular(22),
                                      topRight: Radius.circular(22),
                                      bottomRight: Radius.circular(18),
                                      bottomLeft: Radius.circular(18),
                                    ),
                                    child: Container(
                                      width: 200.0,
                                      height: 150.0,
                                      child: Image.memory(
                                        imageBytes,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  // item name & price
                                  Padding(
                                    padding:const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // item name
                                        Text(
                                          eachPlantItemData.name!,
                                          maxLines: 3,
                                          overflow:  TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.green.shade900,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        //item price
                                        Text(
                                          "\ Rs." + eachPlantItemData.price.toString(),
                                          style: const TextStyle(
                                            color: Colors.purpleAccent,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8,),
                                        // rating stars & rating numbers
                                        Row(
                                          children: [
                                            RatingBar.builder(
                                              initialRating: eachPlantItemData.rating!,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemBuilder: (context,_) => const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (updateRating){},
                                              ignoreGestures:true,
                                              unratedColor:Colors.grey,
                                              itemSize:20,
                                            ),
                                            const SizedBox(width: 8,),
                                            Text(
                                              "(${eachPlantItemData.rating.toString()})",
                                              style: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                    ),
                  )
                ],
              ),
            );
          }
          else{
            return const Center(
              child: Text("Empty, No Data."),
            );
          }
        }
    );
  }
}

