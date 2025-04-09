//user model


import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  final int userId;
  final String userName;
  final String userContact;
  final String userEmail;
  final String userPassword;

  User ({
    required this.userId,
    required this.userName,
    required this.userContact,
    required this.userEmail,
    required this.userPassword,
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      userId: int.parse(json['user_id']),
      userName: json['user_name'],
      userContact:  json['user_number'].toString(),
      userEmail: json['user_email'],
      userPassword: json['user_password'],
    );
  }

  Map<String, dynamic> toJson() => {
    "user_id": userId.toString(),
    "user_name": userName,
    "user_number": userContact.toString(),
    "user_email": userEmail,
    "user_password": userPassword,
  };

  @override
  String toString(){
  //print('userId: $userId, userName: $userName, userContact: $userContact,userEmail: $userEmail,userPassword: $userPassword');

    return 'User{userId: $userId, userName: $userName, userContact: $userContact,userEmail: $userEmail,userPassword: $userPassword}';
  }


}