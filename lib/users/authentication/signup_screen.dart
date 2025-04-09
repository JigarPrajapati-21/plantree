import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../api_connection/api_connection.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  RegExp regex = RegExp(r'^[a-zA-Z0-9,a-zA-Z0-9.!#$%&\*+/=?^_`{|}~-]+@[a-zA-Z0-0]+\.[a-zA-Z]+');

  RegExp regexOfEmail = RegExp(r'^[a-zA-Z0-9,a-zA-Z0-9.!#$%&\*+/=?^_`{|}~-]+@[a-zA-Z0-0]+\.[a-zA-Z]+');
  RegExp regexOfPhoneNumber = RegExp(r'^[0-9]{10}$'); //for only 10 digit
  // RegExp(r'^\+?[0-9]{10,12}$'); --> for 10,11,12 digit


  var formKey = GlobalKey<FormState>();
  var nameController=TextEditingController();
  var numberController=TextEditingController();
  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  var RepasswordController=TextEditingController();
  var isobsecure=true.obs;
  var isobsecure1=true.obs;

  Future validateUserEmail() async{

    var url=Uri.parse(API.validateEmail);
    var response=await http.post(url,body:{
      "user_email":emailController.text.trim(),
    });

    if(response.statusCode==200)
    {
      var responseBody= jsonDecode(response.body);

      if(responseBody['status']=='success'){
        Fluttertoast.showToast(msg: "Email Exist",
          fontSize: 16,
          backgroundColor: Colors.white,
          gravity: ToastGravity.TOP,
          textColor: Colors.black,
          toastLength: Toast.LENGTH_SHORT,
        );
      }else if(responseBody['status']=='error')
      {
        registrationAndSaveUserRecord();
      }else
      {
        Fluttertoast.showToast(msg: "Unexpected response",
          fontSize: 16,
          backgroundColor: Colors.white,
          gravity: ToastGravity.TOP,
          textColor: Colors.black,
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } else{
      print(response.statusCode.toString());
      Fluttertoast.showToast(msg: "Server error",
        fontSize: 16,
        backgroundColor: Colors.white,
        gravity: ToastGravity.TOP,
        textColor: Colors.black,
        toastLength: Toast.LENGTH_SHORT,
      );
    }

  }

  registrationAndSaveUserRecord() async
  {
    var url=Uri.parse(API.signUp);
    var response=await http.post(url,body:{
      "user_name":nameController.text.trim(),
      "user_contact":numberController.text.trim(),
      "user_email":emailController.text.trim(),
      "user_password":passwordController.text.trim(),
    });
print(numberController.text);
    if(response.statusCode==200)
    {
      var responseBody= jsonDecode(response.body);

      if(responseBody['status']=='success'){
        Fluttertoast.showToast(msg: "Registration successfull",
          fontSize: 16,
          backgroundColor: Colors.white,
          gravity: ToastGravity.TOP,
          textColor: Colors.black,
          toastLength: Toast.LENGTH_SHORT,
        );

        setState(() {
          nameController.clear();
          numberController.clear();
          emailController.clear();
          passwordController.clear();
          RepasswordController.clear();
        });
      }else if(responseBody['status']=='error')
      {
        Fluttertoast.showToast(msg: "Registration not successfull",
          fontSize: 16,
          backgroundColor: Colors.white,
          gravity: ToastGravity.TOP,
          textColor: Colors.black,
          toastLength: Toast.LENGTH_SHORT,
        );
        registrationAndSaveUserRecord();
      }else
      {
        Fluttertoast.showToast(msg: "Unexpected response",
          fontSize: 16,
          backgroundColor: Colors.white,
          gravity: ToastGravity.TOP,
          textColor: Colors.black,
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } else{
      print(response.statusCode.toString());
      Fluttertoast.showToast(msg: "Server error",
        fontSize: 16,
        backgroundColor: Colors.white,
        gravity: ToastGravity.TOP,
        textColor: Colors.black,
        toastLength: Toast.LENGTH_SHORT,
      );
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: LayoutBuilder(
          builder: (context,cons)
          {
            return Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image :DecorationImage(
                  image: AssetImage('assets/b3.jpg'), //your image path  'assets/Rectangle 1.png'
                  fit : BoxFit.cover,
                ),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: cons.maxHeight,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8,50,8,8),
                    child: Column( mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //login scrren header
                        Container(
                          width: MediaQuery.of(context).size.width,
                          // height: 50,
                          // child: Image.asset(
                          //     "assets/ss.png"
                          // ),
                        ),


                        // Icon(Icons.eco,
                        //   color: Colors.white,
                        //   size: 80,
                        // ),

                        // Text("PlanTREE",style: TextStyle(fontSize: 40,color: Colors.white,fontWeight: FontWeight.bold,),),

                        //SignUp
                        Text("Register",style: TextStyle(fontSize: 40,color: Colors.white,fontWeight: FontWeight.bold,),),

                        // signup form
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.all(Radius.circular(20),),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 8,
                                    color: Colors.black26,
                                    offset: Offset(0,-3),
                                  )
                                ]
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(30,30,30,10),
                              child: Column(
                                children: [
                                  // form is for email password and button
                                  Form(
                                    key: formKey,
                                    child: Column(
                                      children: [
                                        //name
                                        TextFormField(
                                          controller: nameController,
                                         validator: (val) => val == "" ? "plz write email" :  null,

                                          decoration:  InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.person,
                                              color: Colors.green.shade900,
                                            ),
                                            errorStyle: TextStyle(
                                                fontSize: 16,fontWeight: FontWeight.bold
                                            ),
                                            hintText: "name..",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(30),
                                              borderSide:BorderSide(color: Colors.green.shade900),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(30),
                                              borderSide: BorderSide(color: Colors.green.shade900),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(30),
                                              borderSide: BorderSide(color: Colors.green.shade900),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(30),
                                              borderSide: BorderSide(color: Colors.green.shade900),
                                            ),
                                            contentPadding: EdgeInsets.symmetric(
                                              horizontal: 14,vertical: 6,
                                            ),
                                            fillColor: Colors.green.shade50,
                                            filled: true,
                                          ),
                                        ),
                                        SizedBox(height: 18,),
                                        //number
                                        TextFormField(
                                          keyboardType:TextInputType.phone ,
                                          controller: numberController,
                                          validator: (val) => val == "" ? "plz write Phone number" : (!regexOfPhoneNumber.hasMatch(val!)) ? "Please Enter valid Phone number..." : null,

                                          decoration:  InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.phone,
                                              color: Colors.green.shade900,
                                            ),
                                            errorStyle: TextStyle(
                                                fontSize: 16,fontWeight: FontWeight.bold
                                            ),
                                            hintText: "phone number..",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(30),
                                              borderSide:BorderSide(color: Colors.green.shade900),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(30),
                                              borderSide: BorderSide(color: Colors.green.shade900),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(30),
                                              borderSide: BorderSide(color: Colors.green.shade900),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(30),
                                              borderSide: BorderSide(color: Colors.green.shade900),
                                            ),
                                            contentPadding: EdgeInsets.symmetric(
                                              horizontal: 14,vertical: 6,
                                            ),
                                            fillColor: Colors.green.shade50,
                                            filled: true,
                                          ),
                                        ),
                                        SizedBox(height: 18,),
                                        //email
                                        TextFormField(
                                          controller: emailController,
                                          validator: (val) => val == "" ? "plz write email" : (!regexOfEmail.hasMatch(val!)) ? "Please Enter valid email id..." : null,
                                          decoration:  InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.email,
                                              color: Colors.green.shade900,
                                            ),
                                            errorStyle: TextStyle(
                                                fontSize: 16,fontWeight: FontWeight.bold
                                            ),
                                            hintText: "email..",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(30),
                                              borderSide:BorderSide(color: Colors.green.shade900),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(30),
                                              borderSide: BorderSide(color: Colors.green.shade900),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(30),
                                              borderSide: BorderSide(color: Colors.green.shade900),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(30),
                                              borderSide: BorderSide(color: Colors.green.shade900),
                                            ),
                                            contentPadding: EdgeInsets.symmetric(
                                              horizontal: 14,vertical: 6,
                                            ),
                                            fillColor: Colors.green.shade50,
                                            filled: true,
                                          ),
                                        ),
                                        SizedBox(height: 18,),
                                        //password
                                        Obx(
                                              ()=> TextFormField(
                                            controller: passwordController,
                                            obscureText: isobsecure.value,
                                            validator: (val) => val== "" ? "plz write password" :null,
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.vpn_key_sharp,
                                                color: Colors.green.shade900,
                                              ),
                                              errorStyle: TextStyle(
                                                  fontSize: 16,fontWeight: FontWeight.bold
                                              ),
                                              suffixIcon: Obx(
                                                      () => GestureDetector(
                                                    onTap:()
                                                    {
                                                      isobsecure.value=!isobsecure.value;
                                                    },
                                                    child: Icon(
                                                      isobsecure.value ? Icons.visibility_off : Icons.visibility,
                                                      color: Colors.green.shade900,
                                                    ),
                                                  )
                                              ),
                                              hintText: "password..",
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: BorderSide(color: Colors.green.shade900),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: BorderSide(color: Colors.green.shade900),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: BorderSide(color: Colors.green.shade900),
                                              ),
                                              disabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: BorderSide(color: Colors.green.shade900),
                                              ),
                                              contentPadding: EdgeInsets.symmetric(
                                                horizontal: 14,vertical: 6,
                                              ),
                                              fillColor: Colors.green.shade50,
                                              filled: true,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 18,),
                                        //ReEnterPassword
                                        Obx(
                                              ()=> TextFormField(
                                            controller: RepasswordController,
                                            obscureText: isobsecure1.value,
                                            validator: (val1) => val1== "" ? "plz write ReEnter password" :(val1 != passwordController.text)?"plz enter same password":null,
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.vpn_key_sharp,
                                                color: Colors.green.shade900,
                                              ),
                                              errorStyle: TextStyle(
                                                  fontSize: 16,fontWeight: FontWeight.bold
                                              ),
                                              suffixIcon: Obx(
                                                      () => GestureDetector(
                                                    onTap:()
                                                    {
                                                      isobsecure1.value=!isobsecure1.value;
                                                    },
                                                    child: Icon(
                                                      isobsecure1.value ? Icons.visibility_off : Icons.visibility,
                                                      color: Colors.green.shade900,
                                                    ),
                                                  )
                                              ),
                                              hintText: "ReEnter password..",
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: BorderSide(color: Colors.green.shade900),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: BorderSide(color: Colors.green.shade900),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: BorderSide(color: Colors.green.shade900),
                                              ),
                                              disabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: BorderSide(color: Colors.green.shade900),
                                              ),
                                              contentPadding: EdgeInsets.symmetric(
                                                horizontal: 14,vertical: 6,
                                              ),
                                              fillColor: Colors.green.shade50,
                                              filled: true,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 18,),
                                        //button SignUp
                                        Material(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(30),
                                          child: InkWell(
                                            onTap: ()
                                            {
                                              if(formKey.currentState!.validate())
                                              {
                                                  //validate user email //email is exist or not
                                                validateUserEmail();
                                              }
                                            },
                                            borderRadius: BorderRadius.circular(30),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(vertical: 6,horizontal: 115),
                                              child: Text("SignUp",style: TextStyle(color: Colors.white,fontSize: 20),),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 16,),
                                  //row is for already have an account button
                                  Row(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("already have an account ?",style: TextStyle(color: Colors.white),),
                                      TextButton(onPressed: ()
                                      {
                                        Get.to(LoginScreen());
                                      },child: Text("SignIn",style: TextStyle(color: Colors.green.shade100,fontSize: 18,fontWeight: FontWeight.bold),),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
      ),
    );//const Placeholder();
  }
}
