import 'dart:convert';

import 'package:e_bazeni/models/DTOs/edit_userinformation_response.dart';
import 'package:e_bazeni/models/DTOs/userlogindto.dart';
import 'package:e_bazeni/models/DTOs/userpatchDTO.dart';
import 'package:e_bazeni/models/DTOs/userregistrationdto.dart';
import 'package:e_bazeni/models/User.dart';
import 'package:e_bazeni/services/apiservice.dart';
import 'package:e_bazeni/services/storageservice.dart';
import 'package:e_bazeni/wrapper.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;

class UserController extends GetxController{
  final loggedIn = false.obs;
  User user = User(Boraviste: '', 
    DatumRodenja: DateTime.now().toUtc().toString(), 
    Email: '', 
    Id: '', 
    Ime: '', 
    OIB: '', 
    Prebivaliste: '', 
    Prezime: '', 
    UserName: ''
  );

  final StorageService _storageService = StorageService();
  final ApiService _apiService = ApiService();
  final jwtToken = "".obs;
  final refreshToken = "".obs;

  UserController();

  Future Logout() async{
    user = User();
    jwtToken.value = "";
    refreshToken.value = "";
    loggedIn.value = false;
    _storageService.DeleteSecureData("username");
    _storageService.DeleteSecureData("password");
    update();
  }

  Future RefreshToken() async{
    try{
      var response = await _apiService.RefreshToken(refreshToken: refreshToken.value, token: jwtToken.value);
      if(response.statusCode == 200){
        if(jsonDecode(response.body)['refreshToken'] != null && jsonDecode(response.body)['token'] != null){
          refreshToken.value = jsonDecode(response.body)['refreshToken'];
          jwtToken.value = jsonDecode(response.body)['token'];
        }
      }
    }
    catch(exception){
      throw exception;
    }
    
  }
  
  Future<http.Response> Login({required UserLoginDTO userLoginDTO}) async{
    try{
      var response = await _apiService.Login(userLoginDTO);
      return response;
    }
    catch(exception){
      throw exception;
    }
    
  }

  Future<http.Response> Register({required UserRegistrationDTO userRegistrationDTO}) async{
    try{
      var response = await _apiService.Register(userRegistrationDto: userRegistrationDTO);
      return response;
    }
    catch(exception){
      throw exception;
    }
  }

  Future<EditUserInformationResponse> EditUserInformation(UserToPatchDTO userToPatchDTO) async{
    try{
      await RefreshToken();
      var response = await _apiService.EditUserInformation(jwtToken: jwtToken.value, userToPatchDTO: userToPatchDTO, userId: user.Id);
      var jsonResponse = jsonDecode(response.body);
      if(response.statusCode == 200){
        user = User.fromJson(jsonResponse);
        update();
        return EditUserInformationResponse.fromJson(jsonResponse);
      }
      else if(response.statusCode == 502){
        return EditUserInformationResponse(Success: false, Error: "Veza sa serverom nije mogla biti uspostavljena");
      }
      else{
        return EditUserInformationResponse.fromJson(jsonResponse);
      }
    }
    catch(exception){
      throw exception;
    }
    
  }

}