import 'package:e_bazeni/models/User.dart';

class UserLoginDTO{
  final String UserName;
  final String Password;

  UserLoginDTO({required this.UserName, required this.Password});

  Map<String, dynamic> toJsonMap() =>{
    'username': UserName,
    'password': Password
  };
}