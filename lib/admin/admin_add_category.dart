// import 'package:flutter/material.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import '../../api_connection/api_connection.dart';
// import 'package:path/path.dart' as path;
//
// class AdminAddCategory extends StatefulWidget {
//   const AdminAddCategory({super.key});
//
//   @override
//   State<AdminAddCategory> createState() => _AdminAddCategoryState();
// }
//
// class _AdminAddCategoryState extends State<AdminAddCategory> {
//   bool selectBtnMainCategory = false;
//   bool selectBtnSubCategory = false;
//
//   TextEditingController mainCategoryNameController = TextEditingController();
//   TextEditingController nameController = TextEditingController();
//
//
//   RxList<int>_imageSelectedByte= <int>[].obs;
//
//   Uint8List get imageSelectedByte => Uint8List.fromList(_imageSelectedByte);
//   RxString _imageSelectedName = "".obs;
//
//   String get imageSelectedName => _imageSelectedName.value;
//   final ImagePicker _picker = ImagePicker();
//
//   setSelectedImage(Uint8List selectedImage){
//     _imageSelectedByte.value = selectedImage;
//   }
//   setSelectedImageName(String selectedImageName){
//     _imageSelectedName.value = selectedImageName;
//   }
//
//   chooseImageFromGallery()async
//   {
//     final pickedImageXFile = await _picker.pickImage(
//         source:ImageSource.gallery);
//
//     if(pickedImageXFile != null){
//       final bytesOfImage =await pickedImageXFile.readAsBytes();
//
//       setSelectedImage(bytesOfImage);
//       setSelectedImageName(path.basename(pickedImageXFile.path));
//     }
//   }
//
//   Future<void> addMainCategoryToDB() async {
//
// print("111");
//     try {
//
//
//       print("222");
//       var res = await http.post(
//         Uri.parse(API.addMainCategory),
//         body: {
//           "main_category_name": mainCategoryNameController.text,
//           "image": base64Encode(imageSelectedByte),
//         },
//       );
// print(nameController.text);
// print(base64Encode(imageSelectedByte));
// print("333");
// print(res.statusCode);
// print(res.body);
//       if (res.statusCode == 200) {
//         var responseBody = jsonDecode(res.body);
//         if (responseBody["success"] == true) {
//           addMainCategory();
//           Fluttertoast.showToast(msg: "Main Category Add successfully");
//
//         } else {
//           // Handle failure (e.g., show error message)
//           print("Error: ${responseBody["message"]}");
//         }
//       } else {
//         // Handle other status codes
//         print("Error: Server returned status code ${res.statusCode}");
//       }
//     } catch (error) {
//       print("Error: $error");
//       // Handle network or other errors
//     }
//   }
//
//
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         selectBtnMainCategory = true;
//                         selectBtnSubCategory = false;
//                       });
//                     },
//                     child: Text(
//                       "Add Main Category",
//                       style: TextStyle(
//                           fontSize: 15,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green.shade300,
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         selectBtnMainCategory = false;
//                         selectBtnSubCategory = true;
//                       });
//                     },
//                     child: Text(
//                       "Add Sub Category",
//                       style: TextStyle(
//                           fontSize: 15,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green.shade300,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 0,
//             ),
//             if (selectBtnMainCategory)
//               Container(
//                 child: addMainCategory(),
//               ),
//             if (selectBtnSubCategory)
//               Container(
//                 child: Text("ssssDDD"),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget addMainCategory() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Main Category Name :",
//             style: TextStyle(
//                 fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
//           ),
//
//           SizedBox(height: 10,),
//
//
//
//
//           TextField(
//
//             style: const TextStyle(color: Colors.green),
//             controller: mainCategoryNameController,
//             decoration: InputDecoration(
//               hintText: 'Main Category Name..',
//               hintStyle: const TextStyle(
//                 color: Colors.green,
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: const BorderSide(color: Colors.green, width: 2),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: const BorderSide(color: Colors.green, width: 2),
//               ),
//             ),
//           ),
//
//           SizedBox(height: 10,),
//
//           Center(
//             child: Material(
//               elevation: 8,
//               color: Colors.purpleAccent,
//               borderRadius: BorderRadius.circular(30),
//               child: InkWell(
//                 onTap:(){
//                   chooseImageFromGallery();
//                 },
//                 borderRadius: BorderRadius.circular(30),
//                 child: const Padding(
//                   padding:EdgeInsets.symmetric(
//                     horizontal: 30,
//                     vertical: 12,
//                   ),
//                   child: Text("Select Image",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 10,),
//
//           //display selected Image by user
//           Obx(() =>
//               Center(
//                 child: ConstrainedBox(
//                   constraints:BoxConstraints(
//                     maxWidth: MediaQuery
//                         .of(context)
//                         .size
//                         .width * 0.7,
//                     maxHeight: MediaQuery
//                         .of(context)
//                         .size
//                         .width * 0.6,
//                   ) ,
//                   child: imageSelectedByte.length > 0
//                       ?Image.memory(imageSelectedByte,fit: BoxFit.contain,)
//                       : const Placeholder(color: Colors.white60,),
//                 ),
//               ),
//           ),
//           const SizedBox(height: 16,),
//
//           //add
//           Obx(() =>
//               Center(
//                 child: Material(
//                   elevation: 8,
//                   color: imageSelectedByte.length > 0
//                       ? Colors.purpleAccent
//                       :Colors.grey,
//                   borderRadius: BorderRadius.circular(30),
//                   child: InkWell(
//                     onTap: (){
//                       if(imageSelectedByte.length > 0){
//                         //save order info
//
//                         addMainCategoryToDB();
//
//
//                       }
//                       else{
//                         Fluttertoast.showToast(msg: "Please select image.");
//                       }
//                     },
//                     borderRadius: BorderRadius.circular(30),
//                     child: const Padding(
//                       padding:EdgeInsets.symmetric(
//                         horizontal: 120,
//                         vertical: 12,
//                       ) ,
//                       child: Text(
//                         "Add",
//                         style: TextStyle(
//                           color: Colors.white70,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//           ),
//
//
//
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:path/path.dart' as path;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../api_connection/api_connection.dart';
import '../users/model/main_category_model.dart';

class AdminAddCategory extends StatefulWidget {
  const AdminAddCategory({super.key});

  @override
  State<AdminAddCategory> createState() => _AdminAddCategoryState();
}

class _AdminAddCategoryState extends State<AdminAddCategory> {
  bool selectBtnMainCategory = false;
  bool selectBtnSubCategory = false;

  TextEditingController mainCategoryNameController = TextEditingController();
  TextEditingController subCategoryNameController = TextEditingController();

  //__________image_______
  RxList<int> _imageSelectedByte = <int>[].obs;
  Uint8List get imageSelectedByte => Uint8List.fromList(_imageSelectedByte);
  RxString _imageSelectedName = "".obs;

  String get imageSelectedName => _imageSelectedName.value;
  final ImagePicker _picker = ImagePicker();

  void setSelectedImage(Uint8List selectedImage) {
    _imageSelectedByte.value = selectedImage;
  }

  void setSelectedImageName(String selectImageName) {
    _imageSelectedName.value = selectImageName;
  }

  Future<void> chooseImageFormGallery() async {
    final pickedImageXFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImageXFile != null) {
      final byteOfImage = await pickedImageXFile.readAsBytes();
      setSelectedImage(byteOfImage);
      setSelectedImageName(path.basename(pickedImageXFile.path));
    } else {
      Fluttertoast.showToast(msg: "No image selected.");
    }
  }

  Future<void> addMainCategoryToDB() async {
    if (mainCategoryNameController.text.isEmpty || _imageSelectedByte.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please enter category name and select an image.");
      return;
    }
    try {
      var res = await http.post(Uri.parse(API.addMainCategory), body: {
        "main_category_name": mainCategoryNameController.text,
        "image": base64Encode(_imageSelectedByte),
      });
      if (res.statusCode == 200) {
        var responseBody = jsonDecode(res.body);
        if (responseBody["success"] == true) {
          Fluttertoast.showToast(msg: "Main Category added successfully");
          resetFields(); // Clear fields and remove image from the screen
        } else {
          print("Error: ${responseBody["message"]}");
          Fluttertoast.showToast(
              msg: "Failed to add category:${responseBody["message"]}");
        }
      } else {
        print("Error: Server retuned status code ${res.statusCode}");
        Fluttertoast.showToast(msg: "Server error: ${res.statusCode}");
      }
    } catch (error) {
      print("Error : $error");
      Fluttertoast.showToast(msg: "Network error: $error");
    }
  }

  //--------

  String? selectedcategoryId;
  List<MainCategory> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getMainCategory();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      categories = await getMainCategory();
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      Fluttertoast.showToast(msg: "Error loading categories: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<MainCategory>> getMainCategory() async {
    List<MainCategory> allMainCategoryList = [];

    try {
      var res = await http.post(Uri.parse(API.mainCategory));

      if (res.statusCode == 200) {
        var responseBodyOfMainCategory = jsonDecode(res.body);
        if (responseBodyOfMainCategory["status"] == "success") {
          (responseBodyOfMainCategory["mainCategoryData"] as List)
              .forEach((eachRecord) {
            allMainCategoryList.add(MainCategory.fromJson(eachRecord));
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Error,status code is not 200");
      }
    } catch (errorMsg) {
      print("Error::" + errorMsg.toString());
    }
    return allMainCategoryList;
  }

  //-----------
  Future<void> addSubCategoryToDB() async {
    if (subCategoryNameController.text.isEmpty ||
        _imageSelectedByte.isEmpty ||
        selectedcategoryId == null) {
      Fluttertoast.showToast(
        msg:
            "Please enter sub-category name, select an image,and choose a main category.",
        timeInSecForIosWeb: 3,
      );
      return;
    }
    try {
      var res = await http.post(Uri.parse(API.addSubCategory), body: {
        "sub_category_name": subCategoryNameController.text,
        "main_category_id":
            selectedcategoryId.toString(), //pass the selected main category ID
        "image": base64Encode(_imageSelectedByte),
      });

      if (res.statusCode == 200) {
        var responseBody = jsonDecode(res.body);
        if (responseBody["success"] == true) {
          Fluttertoast.showToast(msg: "Sub-category added successfully");
          resetFields(); //clear fields and reset after success
        } else {
          print("Error: ${responseBody["message"]}");
          Fluttertoast.showToast(
              msg: "Failed to add sub-category: ${responseBody["message"]}");
        }
      } else {
        print("Error: Server returned status code ${res.statusCode}");
        Fluttertoast.showToast(msg: "server error: ${res.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
      Fluttertoast.showToast(msg: "Network error: $error");
    }
  }

  // Ensure resetFields() clears all fields and the  selected category
  void resetFields() {
    subCategoryNameController.clear();
    mainCategoryNameController.clear();
    _imageSelectedByte.value = []; //clear seleced image data
    _imageSelectedName.value = "";
    selectedcategoryId = null; //Reset selected category ID
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectBtnMainCategory = true;
                        selectBtnSubCategory = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade300),
                    child: const Text(
                      "Add Main Category",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectBtnMainCategory = false;
                        selectBtnSubCategory = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade300),
                    child: const Text(
                      "Add Sub Category",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 0,
            ),
            if (selectBtnMainCategory) addMainCategory(),
            if (selectBtnSubCategory) addSubCategory(),
          ],
        ),
      ),
    );
  }

  Widget addMainCategory() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            style: const TextStyle(color: Colors.green),
            controller: mainCategoryNameController,
            decoration: InputDecoration(
              labelText: 'Main Category Name',
              filled: true,
              fillColor: Colors.green[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: chooseImageFormGallery,
            child: Container(
              color: Colors.green[100],
              height: 300, //Increased heigth
              width: double.infinity, // Set width to be full available width
              child: Obx(() {
                //Make the widget reactive with Obx
                return _imageSelectedByte.isEmpty
                    ? const Icon(Icons.image, size: 100) // Incresed icpn size
                    : Image.memory(
                        Uint8List.fromList(_imageSelectedByte.toList()),
                        fit: BoxFit
                            .fill, // Ensure the image covers the area well
                      );
              }),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        addMainCategoryToDB();
                        resetFields();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      elevation: 2,
                    ),
                    child: const Text("Add"),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget addSubCategory() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 15),
        TextField(
          style: const TextStyle(color: Colors.green),
          controller: subCategoryNameController,
          decoration: InputDecoration(
            labelText: 'Sub Category Name',
            filled: true,
            fillColor: Colors.green[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        isLoading
            ? const CircularProgressIndicator()
            : DropdownButtonFormField(
                isExpanded: true,
                value: selectedcategoryId,
                hint: const Text("Choose Main Category"),
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category.main_category_id.toString(),
                    child: Text(category.main_category_name ?? ""),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedcategoryId = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'mainCategory',
                  filled: true,
                  fillColor: Colors.green[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
        const SizedBox(
          height: 15,
        ),
        GestureDetector(
          onTap: chooseImageFormGallery,
          child: Container(
            color: Colors.green[100],
            height: 300,
            width: double.infinity,
            child: Obx(() {
              return _imageSelectedByte.isEmpty
                  ? const Icon(Icons.image, size: 100)
                  : Image.memory(
                      Uint8List.fromList(_imageSelectedByte.toList()),
                      fit: BoxFit.fill,
                    );
            }),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      addSubCategoryToDB();
                      resetFields();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    elevation: 2,
                  ),
                  child: const Text("Add"),
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
