import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../api_connection/api_connection.dart';
import '../model/plant_model.dart';
import 'package:http/http.dart' as http;

import 'item_details_screen.dart';

class SearchItems extends StatefulWidget {

  final String? typedKeyWords;
  const SearchItems({super.key, this.typedKeyWords});

  @override
  State<SearchItems> createState() => _SearchItemsState();
}

class _SearchItemsState extends State<SearchItems> {

  TextEditingController searchController = TextEditingController();

  Future<List<Plants>> readSearchRecordsFound() async
  {
    List<Plants> PlantsSearchList =[];
    if(searchController.text!="")
      {
        try{
          var res=await http.post(
            Uri.parse(API.searchItems),
            body:
              {
                  "typedKeywords":searchController.text,
              }
          );

          if(res.statusCode==200)
            {
              var responseBodyOfSearchItems=jsonDecode(res.body);
              if(responseBodyOfSearchItems['success']==true)
                {
                  (responseBodyOfSearchItems['itemsFoundData'] as List).forEach((eachItemData)
                  {
                    PlantsSearchList.add(Plants.fromJson(eachItemData));
                  });
                }
            }
          else
            {
              Fluttertoast.showToast(msg: "Status code is not 200");
            }

        }
        catch(errorMsg)
        {
          Fluttertoast.showToast(msg: "Error::"+ errorMsg.toString());
        }
      }
    return PlantsSearchList;
  }



  @override
  void initState()
  {
    super.initState();
    searchController.text=widget.typedKeyWords!;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade100,
        title: showSearchBarWidget(),
        titleSpacing: 0,
        leading: IconButton(
          onPressed: ()
          {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.green.shade900,
          ),
        ),
      ),
      body: searchItemDesignWidget(context),
    );
  }

  Widget showSearchBarWidget() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        style: TextStyle(color: Colors.green.shade900),
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: (){
              setState(() {

              });
            },
            icon: Icon(
              Icons.search,
              color: Colors.green.shade900,
            ),
          ),
          hintText: "Search best Plants here...",
          hintStyle: TextStyle(
            color: Colors.green.shade500,
            fontSize: 16,
          ),
          suffixIcon: IconButton(
            onPressed: (){
              searchController.clear();
              setState(() {

              });
            },
            icon: Icon(
              Icons.close,
              color: Colors.green.shade900,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.green.shade900,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.green.shade900,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
        ),
      ),
    );
  }

  searchItemDesignWidget(context)
  {
    return FutureBuilder(
      future: readSearchRecordsFound(),
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
            child: Text("no  item found"),
          );
        }
        if(dataSnapShot.data!.length>0)
        {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ListView.builder(
                itemCount: dataSnapShot.data!.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context,index)
                {
                  Plants eachPlantItemRecord=dataSnapShot.data![index];
                  //decode base64 string to uint8list
                  Uint8List imageBytes= base64Decode(eachPlantItemRecord.image.toString());
                  return GestureDetector(
                    onTap: ()
                    {
                      Get.to(ItemDetailsScreen(itemInfo: eachPlantItemRecord ));

                    },
                    child: Container(

                      margin: EdgeInsets.fromLTRB(
                        16,
                        index==0?16:8,
                        16,
                        index==dataSnapShot.data!.length-1?16:8,

                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green.shade50,
                        boxShadow: [
                          BoxShadow(offset: const Offset(0,3),
                            blurRadius: 2,
                            color: Colors.green.shade900,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [

                          //name+price
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20,right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  //name
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(eachPlantItemRecord.name!,
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
                                        child: Text("Rs. "+eachPlantItemRecord.price!.toString(),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
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


                          //item image
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
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





}
