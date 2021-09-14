import 'dart:convert';
import 'package:e_bazeni/controllers/UlaznicaController.dart';
import 'package:e_bazeni/controllers/ZahtjevController.dart';
import 'package:e_bazeni/models/DTOs/userlogindto.dart';
import 'package:e_bazeni/models/User.dart';
import 'package:e_bazeni/resusable_objects/custom_appbar.dart';
import 'package:e_bazeni/resusable_objects/loading_screen.dart';
import 'package:e_bazeni/services/apiservice.dart';
import 'package:e_bazeni/services/storageservice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth/authhome.dart';
import 'controllers/UserController.dart';
import 'home/home.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  final _controller = Get.put(UserController());
  final ulaznicaController = Get.put(UlaznicaController());
  final _zahtjevController = Get.put(ZahtjevController());
  final _storageService = StorageService();
  bool loading = true;

  Future existingLoginAttempt() async{
    String? username = null;
    String? password = null;

    try{
      username = await _storageService.ReadSecureData("username");
      password = await _storageService.ReadSecureData("password");

      if(password != null && username != null){
        var result = await _controller.Login(userLoginDTO: UserLoginDTO(UserName: username, Password: password));
        if(result.statusCode == 200){
          var userObject = User.fromJson(jsonDecode(result.body));
            _controller.user = userObject;
            _controller.loggedIn.value = true;
            _controller.jwtToken.value = jsonDecode(result.body)['token'];
            _controller.refreshToken.value = jsonDecode(result.body)['refreshToken'];
            _storageService.WriteSecureData("username", username);
            _storageService.WriteSecureData("password", password);
        }
      }
      setState(() {
        loading = false;
      });
    }
    catch(exception){

    }
  }
  @override
  void initState() {
    existingLoginAttempt();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !loading ? Obx(() => _controller.loggedIn.value == true ? Home(): AuthHome()) : LoadingScreen(size: 70, color: Colors.redAccent[700]!),
    );
  }
}