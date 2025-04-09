import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import '../../api_connection/api_connection.dart';
import '../categories/sub_category.dart';
import '../model/main_category_model.dart';


class CategoryFragementScreen extends StatelessWidget {
  const CategoryFragementScreen({super.key});

  Future<List<MainCategory>>getMainCategory() async
  {
    List<MainCategory>allMainCategoryList = [];

    try {
      var res = await http.post(
          Uri.parse(API.mainCategory)
      );

      if (res.statusCode == 200) {
        var responseBodyOfMainCategory = jsonDecode(res.body);
        if (responseBodyOfMainCategory["status"] == "success") {
          (responseBodyOfMainCategory["mainCategoryData"] as List).forEach((eachRecord) {
            allMainCategoryList.add(MainCategory.fromJson(eachRecord));
          });
        }
      }
      else {
        Fluttertoast.showToast(msg: "Error,status code is not 200");
      }
    }
    catch(errorMsg)
    {
      print("Error::"+errorMsg.toString());
    }
    return allMainCategoryList;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Category",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            allMainCategoryWidget(context),
          ],
        ),
      ),
    );
  }

  allMainCategoryWidget(context)
  {
    return FutureBuilder(
        future: getMainCategory(),
        builder: (context,AsyncSnapshot<List<MainCategory>>dataSnapShot)
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
                "No main category found",
              ),
            );
          }
          if(dataSnapShot.data!.length > 0)
          {
            return ListView.builder(
                itemCount: dataSnapShot.data!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder:(context,index)
                {
                  MainCategory eachMainCategoryData = dataSnapShot.data![index];
                  // Decode Base64 string to Uint8List
                  Uint8List imageBytes =
                  base64Decode(eachMainCategoryData.image.toString());

                  return GestureDetector(
                    onTap: ()
                    {
                      Get.to(SubCategoryScreen(mainCategoryId: eachMainCategoryData.main_category_id.toString(),mainCategoryName: eachMainCategoryData.main_category_name.toString()));
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(16,
                        index == 0 ? 16 : 8,
                        16,
                        index == dataSnapShot.data!.length -1 ? 16: 8,),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green.shade50,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0,3),
                            blurRadius: 4,
                            color: Colors.green.shade900,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          //name
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //name
                                  Row(
                                    children: [
                                      Expanded(
                                        child:Center(
                                          child: Text(
                                            eachMainCategoryData.main_category_name!,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.green.shade900,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 16,),
                                ],
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(22),
                              topRight: Radius.circular(22),
                              bottomLeft: Radius.circular(22),
                            ),
                            child: Container(
                              width: 200.0,
                              height: 150.0,
                              child: Image.memory(
                                imageBytes,
                                fit: BoxFit.fill,
                              ),
                            ),
                          )
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
