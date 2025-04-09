import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../api_connection/api_connection.dart';
import '../users/model/main_category_model.dart';
import '../users/model/sub_category_model.dart';


class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {

  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();

  TextEditingController nameController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();
  TextEditingController priceController=TextEditingController();
  TextEditingController tagsController=TextEditingController();
  TextEditingController ratingController=TextEditingController();

  String? selectedMainCategoryId;
  String? selectedSubCategoryId;
  RxList<int> _imageSelectedByte=<int>[].obs;
  final ImagePicker _picker=ImagePicker();

  List<MainCategory> mainCategories=[];
  List<SubCategory> subCategories=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchMainCategories();
  }

  //fetch main category from api
  Future<void> fetchMainCategories() async{
    try{
      var res=await http.get(Uri.parse(API.mainCategory));
      if(res.statusCode ==200){
        var responseBody=jsonDecode(res.body);
        if(responseBody["status"]=="success"){
          setState(() {
            mainCategories=(responseBody["mainCategoryData"] as List).map((category)=>MainCategory.fromJson(category)).toList();
          });
        }else{
          Fluttertoast.showToast(msg: "Failed to load main category");
        }
      }else{
        Fluttertoast.showToast(msg: "server error : ${res.statusCode}");
      }
    }catch(error){
      Fluttertoast.showToast(msg: "network error: $error");
    }
  }

  //fetch sub category from api based on selected main category
  Future<void> fetchSubCategories(String mainCategoryId) async{
    try{
      var res=await http.post(Uri.parse(API.subCategory),body: {
        "main_category_id":mainCategoryId,
      });
      if(res.statusCode ==200){
        var responseBody=jsonDecode(res.body);
        if(responseBody["status"]=="success"){
          setState(() {
            subCategories=(responseBody["subCategoryData"] as List).map((subCat)=>SubCategory.fromJson(subCat)).toList();
          });
        }else{
          Fluttertoast.showToast(msg: "Failed to load sub category");
        }
      }else{
        Fluttertoast.showToast(msg: "server error : ${res.statusCode}");
      }
    }catch(error){
      Fluttertoast.showToast(msg: "network error: $error");
    }
  }

  //select image from gallary
  Future<void> chooseImageFromGallery() async{
    final pickedImageXFile= await _picker.pickImage(source: ImageSource.gallery);
    if(pickedImageXFile !=null){
      final bytesOfImage = await pickedImageXFile.readAsBytes();
      setState(() {
        _imageSelectedByte.clear();
        _imageSelectedByte.addAll(bytesOfImage);
        _imageSelectedByte.refresh();
      });
    }else{
      Fluttertoast.showToast(msg: "no image selected");
    }
  }

  //add item
  Future<void> addItemToDB() async{
    if(_formKey.currentState!.validate() && _imageSelectedByte.isNotEmpty){
      _formKey.currentState!.save(); // save form data
      try{
        var res=await http.post(Uri.parse(API.addItem),body: {
          "name":nameController.text,
          "description":descriptionController.text,
          "price":priceController.text,
          "tags":tagsController.text,
          "rating":ratingController.text,
          "sub_category_id":selectedSubCategoryId!,
          "image":base64Encode(_imageSelectedByte),
        });
        if(res.statusCode ==200){
          var responseBody=jsonDecode(res.body);
          if(responseBody["success"]==true){
            setState(() {
              Fluttertoast.showToast(msg: "item inserted");
              resetFields(); //reset fields and image after success
            });
          }else{
            Fluttertoast.showToast(msg: "Failed to load sub category");
          }
        }else{
          Fluttertoast.showToast(msg: "server error : ${res.statusCode}");
        }
      }catch(error){
        Fluttertoast.showToast(msg: "network error: $error");
      }
    }else{
      Fluttertoast.showToast(msg: "please fill all fielsd,select an image, and choose a category");
      return;
    }
  }

  //reset input fields and image
  void resetFields(){
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    tagsController.clear();
    ratingController.clear();
    _imageSelectedByte.clear();
    _imageSelectedByte.refresh();
    selectedMainCategoryId=null;
    selectedSubCategoryId=null;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //item name input
                TextFormField(
                  validator: (value){
                    if(value==null||value.isEmpty){
                      return"item name is compulsory";
                    }
                    return null;
                  },
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Item name',
                    filled: true,
                    fillColor: Colors.green.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 12,),

                //description input
                TextFormField(
                  validator: (value){
                    if(value==null||value.isEmpty){
                      return"descrription is compulsory";
                    }
                    return null;
                  },
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    filled: true,
                    fillColor: Colors.green.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 12,),


                //price input
                TextFormField(
                  validator: (value){
                    if(value==null||value.isEmpty){
                      return"price is compulsory";
                    }
                    if(double.tryParse(value)==null){
                      return"price should be a number";
                    }
                    return null;
                  },
                  controller: priceController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Price (in INR)',
                    filled: true,
                    fillColor: Colors.green.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 12,),

                //tags input
                TextFormField(
                  validator: (value){
                    if(value==null||value.isEmpty){
                      return"price is compulsory";
                    }
                    return null;
                  },
                  controller: tagsController,
                  decoration: InputDecoration(
                    labelText: 'Tags (coma separated)',
                    filled: true,
                    fillColor: Colors.green.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 12,),

                //rating input
                TextFormField(
                  validator: (value){
                    if(value==null||value.isEmpty){
                      return"Rating is compulsory";
                    }
                    final rating=double.tryParse(value);
                    if(rating==null||rating<0.0||rating>5.0){
                      return"price should be between 0.0 and 5.0";
                    }
                    return null;
                  },
                  controller: ratingController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Rating (0.0 to 5.0)',
                    filled: true,
                    fillColor: Colors.green.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 12,),

                //main category dropdown
                DropdownButtonFormField<String>(
                    validator: (value){
                      if(value==null){
                        return"main category is compulsory";
                      }
                      return null;
                    },
                    value: selectedMainCategoryId,
                    hint: Text("Select Main Category"),
                    items: mainCategories.map((category){
                      return DropdownMenuItem<String>(
                        value: category.main_category_id.toString(),
                        child: Text(category.main_category_name.toString()),
                      );
                    }).toList(),
                    onChanged: (value){
                      setState(() {
                        selectedMainCategoryId=value;
                        selectedSubCategoryId=null;// reset subcategory
                        fetchSubCategories(value!);//fetch subcategory
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Main Category",
                      filled: true,
                      fillColor: Colors.green.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                ),
                SizedBox(height: 12,),


                //sub category dropdown
                if(subCategories.isNotEmpty)
                  DropdownButtonFormField<String>(
                    validator: (value){
                      if(value==null){
                        return"sub category is compulsory";
                      }
                      return null;
                    },
                    value: selectedSubCategoryId,
                    hint: Text("Select Sub Category"),
                    items: subCategories.map((subcat){
                      return DropdownMenuItem<String>(
                        value: subcat.sub_category_id.toString(),
                        child: Text(subcat.sub_category_name.toString()),
                      );
                    }).toList(),
                    onChanged: (value){
                      setState(() {
                        selectedSubCategoryId=value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Sub Category",
                      filled: true,
                      fillColor: Colors.green.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                SizedBox(height: 12,),


                GestureDetector(
                  onTap: chooseImageFromGallery,
                  child: Container(
                    color: Colors.green.shade100,
                    height: 450,
                    width: double.infinity,
                    child: Obx((){
                      //make widget reactive with obx
                      return _imageSelectedByte.isEmpty
                          ? Icon(Icons.image,size: 100,)
                          :Image.memory(
                        Uint8List.fromList(_imageSelectedByte.toList()),
                        fit: BoxFit.cover,
                      );
                    }),
                  ),
                ),


                SizedBox(height: 12,),

                Row(
                  children: [
                    //add item button
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(onPressed: addItemToDB,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              elevation: 2,
                            ),
                            child: Text("Add Item"),
                        ),
                      ),
                    ),

                    //clear form
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: (){
                            setState(() {
                              resetFields();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            elevation: 2,
                          ),
                          child: Text("Clear"),
                        ),
                      ),
                    ),


                  ],
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }
}
