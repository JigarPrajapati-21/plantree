import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:plantree/users/authentication/signup_screen.dart';
// import 'package:my_project/users/authentication/signup_screen.dart';

import '../../admin/admin_login_screen.dart';
import '../../api_connection/api_connection.dart';

import '../fragments/dashboard_of_fregments.dart';
import '../model/user_model.dart';
import '../userPreferences/user_preferences.dart';

// import 'package:plantree/temp_home.dart';
// import 'package:plantree/users/authentication/signup_screen.dart';
// import 'package:plantree/users/fragments/dashbord_of_fregments.dart';
// import 'package:plantree/users/model/user.dart';
// import 'package:plantree/users/userPreferences/user_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  //String pattern=r'^[a-zA-Z0-9,a-zA-Z0-9.!#$%&\*+/=?^_`{|}~-]+@[a-zA-Z0-0]+\.[a-zA-Z]+';
  RegExp regex = RegExp(r'^[a-zA-Z0-9,a-zA-Z0-9.!#$%&\*+/=?^_`{|}~-]+@[a-zA-Z0-0]+\.[a-zA-Z]+');

  var formkey=GlobalKey<FormState>();
  var emailController =TextEditingController();
  var passwordController = TextEditingController();
  var isobsecure=true.obs;

  loginUserNow() async{
    var res = await http.post(Uri.parse(API.login),
      body:{
        "user_email": emailController.text.trim(),
        "user_password": passwordController.text.trim(),
      },
    );
    print("res.statusCode");
    if(res.statusCode==200)
    {
      var resBodyOfLogin=jsonDecode(res.body);
      if(resBodyOfLogin['status']== 'success')
      {

        print("data ======> " + resBodyOfLogin['userData'].toString());

        Fluttertoast.showToast(
          msg: "Login successful",
          fontSize: 16,
          backgroundColor: Colors.white,
          gravity: ToastGravity.TOP,
          textColor: Colors.black87,
          toastLength: Toast.LENGTH_SHORT,
        );

        User userInfo=User.fromJson(resBodyOfLogin['userData']);
        //save uswer info in local storage
        await RememberUserPreferences.storeUserInfo(userInfo);

        Future.delayed(Duration(milliseconds: 2000),()
        {
            Get.to(DashboardOfFragments());
          setState(() {
            emailController.clear();
            passwordController.clear();
          });
        });
      }
      else{
        Fluttertoast.showToast(
          msg:"Incorrect id and password",
          fontSize: 16,
          backgroundColor: Colors.white,
          gravity: ToastGravity.TOP,
          textColor: Colors.black87,
          toastLength: Toast.LENGTH_SHORT,);
      }
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
                  image: AssetImage('assets/b3.jpg'), //your image path   Rectangle 1.png    'assets/img_tree.png'
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
                        Row(mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(onPressed: (){
                              Get.to(AdminLoginScreen());
                            },
                                icon:Icon(Icons.admin_panel_settings,
                                  color: Colors.white,
                                  size: 30,
                                ),
                            ),
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          // child: Image.asset(
                          //     "assets/Tree1.png"
                          // ),
                        ),

                        Icon(Icons.eco,
                          color: Colors.white,
                          size: 80,
                        ),

                        Text("PlanTREE",style: TextStyle(fontSize: 40,color: Colors.white,fontWeight: FontWeight.bold),),

                        //login screen signin form
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
                                    key: formkey,
                                    child: Column(
                                      children: [
                                        //email
                                        TextFormField(
                                          controller: emailController,
                                          validator: (val) => val == "" ? "plz write email" : (!regex.hasMatch(val!)) ? "Please Enter valid email id..." : null,
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
                                        //button login
                                        Material(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(30),
                                          child: InkWell(
                                            onTap: ()
                                            {
                                              if(formkey.currentState!.validate())
                                              {
                                                loginUserNow();
                                              }
                                            },
                                            borderRadius: BorderRadius.circular(30),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(vertical: 6,horizontal: 125),
                                              child: Text("login",style: TextStyle(color: Colors.white,fontSize: 20),),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 16,),
                                  //row is for dont have an account button
                                  Row(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Dont have an account ?",style: TextStyle(color: Colors.white),),
                                      TextButton(onPressed: ()
                                      {
                                           Get.to(SignUpScreen());
                                      },child: Text("SignUp",style: TextStyle(color: Colors.green.shade100,fontSize: 18,fontWeight: FontWeight.bold),),
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
    );
  }
}

