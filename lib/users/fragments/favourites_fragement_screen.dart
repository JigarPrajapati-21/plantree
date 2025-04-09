import'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../api_connection/api_connection.dart';
import '../item/item_details_screen.dart';
import '../model/favorite_model.dart';
import '../model/plant_model.dart';
import '../userPreferences/current_user.dart';

class FavoritesFragmentScreen extends StatefulWidget
{
  @override
  State<FavoritesFragmentScreen> createState() => _FavoritesFragmentScreenState();
}

class _FavoritesFragmentScreenState extends State<FavoritesFragmentScreen> {
  final currentOnlineUser = Get.put(CurrentUser());

  Future<List<Favorite>> getCurrentUserFavoriteList() async
  {
    List<Favorite> favoriteListOfCurrentUser = [];

    // try
    // {
      var res =await http.post(
          Uri.parse(API.readFavorite),
          body:
          {
            "user_id": currentOnlineUser.user.userId.toString(),
          }
      );
      print(res.statusCode.toString());
      if(res.statusCode ==200 )
      {
        var responseBodyOfCurrentUserFavoriteListItems = jsonDecode(res.body);

        if(responseBodyOfCurrentUserFavoriteListItems['success']==true)
        {
          (responseBodyOfCurrentUserFavoriteListItems['currentUserFavoriteData'] as List).forEach((eachCurrentUserFavoriteItemData)
          {
            favoriteListOfCurrentUser.add(Favorite.fromJson(eachCurrentUserFavoriteItemData));
          });
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Status Code is not 200");
      }
    // }
    // catch(errorMsg)
    // {
    //   Fluttertoast.showToast(msg: "Error::" + errorMsg.toString());
    // }
    return favoriteListOfCurrentUser;
  }

  // @override
  // void initState()
  // {
  //   super.initState();
  //  getCurrentUserFavoriteList();
  //   favoriteListDesignWidget(context);
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 8, 0),
            child: Text(
              "My Favorite List:",
              style: TextStyle(
                color: Colors.green.shade500,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
           Padding(
            padding: EdgeInsets.fromLTRB(16, 18, 8, 8),
            child: Text(
              "Ortder these best plants for yourself now.",
              style: TextStyle(
                color: Colors.green.shade900,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(height: 24,),
          //displaying favoriteList
          favoriteListDesignWidget(context),
        ],
      ),
    );
  }

  favoriteListDesignWidget(context)
  {
    return FutureBuilder(
        future:getCurrentUserFavoriteList() ,
    builder: (context,AsyncSnapshot<List<Favorite>>dataSnapShot)
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
    "No favorite item found",
    style: TextStyle(color: Colors.grey,),
    ),
    );
    }
    if (dataSnapShot.data!.length > 0)
    {
    return ListView.builder(
    itemCount:dataSnapShot.data!.length,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    scrollDirection: Axis.vertical,
    itemBuilder: (context,index) {
      Favorite eachFavoriteItemRecord = dataSnapShot.data![index];

      Plants clickedPlantItem = Plants(
        item_id: eachFavoriteItemRecord.item_id,
        image: eachFavoriteItemRecord.image,
        name: eachFavoriteItemRecord.name,
        price: eachFavoriteItemRecord.price,
        rating: eachFavoriteItemRecord.rating,
        description: eachFavoriteItemRecord.description,
        tags: eachFavoriteItemRecord.tags,
      );
      // Decode Base64 string to Uint8List
      Uint8List imageBytes = base64Decode(clickedPlantItem.image.toString());

      return GestureDetector(
        onTap: () {
          Get.to(ItemDetailsScreen(itemInfo: clickedPlantItem));
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(16,
            index == 0 ? 16 : 8,
            16,
            index == dataSnapShot.data!.length - 1 ? 16 : 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.green.shade50,
            boxShadow:
            [
              BoxShadow(
                offset: Offset(0, 3),
                blurRadius: 2,
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
                        // name and price
                        Text(
                          eachFavoriteItemRecord.name!,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.green.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10,),
                        //price
                        Padding(
                          padding: const EdgeInsets.only(left: 0, right: 12),
                          child: Text(
                            "Rs." + eachFavoriteItemRecord.price.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.purpleAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16,),

                      ],
                    ),
                  )
              ),

              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),

                child: Container(
                  width: 150.0,
                  height: 150.0,
                  child: Image.memory(
                    imageBytes,
                    fit: BoxFit.cover,
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
    else
    {
            return const Center(
                child: Text("Empty,No Data."),
             );
    }
    }
    );
    }
}