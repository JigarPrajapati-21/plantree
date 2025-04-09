import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../api_connection/api_connection.dart';
import '../model/sub_category_model.dart';
import 'package:http/http.dart' as http;

import 'items_of_category.dart';

class SubCategoryScreen extends StatelessWidget {

  final String? mainCategoryId;
  final String? mainCategoryName;
  const SubCategoryScreen({super.key, this.mainCategoryId, this.mainCategoryName});

  Future<List<SubCategory>> getSubCategory() async
  {
    List<SubCategory> allSubCategoryList=[];
    try
    {

     var res=await http.post(Uri.parse(API.subCategory),
        body: {
       "main_category_id":mainCategoryId.toString(),
        },
     );

      if(res.statusCode==200)
      {
        var responseBodyOfSubCategory=jsonDecode(res.body);
        if(responseBodyOfSubCategory["status"]=="success")
        {
          (responseBodyOfSubCategory["subCategoryData"] as List).forEach((eachRecord)
          {
            allSubCategoryList.add(SubCategory.fromJson(eachRecord));
          });

        }
      }
      else
      {
        Fluttertoast.showToast(msg: "error, status code is not 200");
      }


    }catch(errorMsg)
    {
      print("Error::"+errorMsg.toString());
    }

    return allSubCategoryList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$mainCategoryName",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            allSubCategoryWidget(context),
          ],
        ),
      ),
    );
  }

  Widget allSubCategoryWidget(context) {
    return FutureBuilder(
      future: getSubCategory(),
      builder: (context,AsyncSnapshot<List<SubCategory>>dataSnapShot)
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
            child: Text("no sub Category  found"),
          );
        }
        if(dataSnapShot.data!.length>0)
        {
          return ListView.builder(
              itemCount: dataSnapShot.data!.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context,index)
              {
                SubCategory eachSubCategoryData=dataSnapShot.data![index];
                //decode base64 string to uint8list
                Uint8List imageBytes= base64Decode(eachSubCategoryData.image.toString());

                return GestureDetector(
                  onTap: ()
                  {
                   Get.to(ItemsOfCategoryScreen(subCategoryId: eachSubCategoryData.sub_category_id.toString(),subCategoryName:eachSubCategoryData.sub_category_name.toString() ));

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
                                      child: Center(
                                        child: Text(eachSubCategoryData.sub_category_name!,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.green.shade900,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),),
                                      ),
                                    ),
                                  ],
                                ),


                              ],
                            ),
                          ),
                        ),


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
