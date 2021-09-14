import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:e_bazeni/models/Zahtjev.dart';
import 'package:e_bazeni/services/apiservice.dart';
import 'package:get/get.dart';

import 'UserController.dart';

class ZahtjevController extends GetxController{

  
  final zahtjev = Zahtjev().obs;
  final ApiService _apiService = ApiService();
  final UserController _userController = Get.find();

  Map<int, String> tipoviUlaznica = Map<int, String>().obs;

  Future GetTipoviUlaznica() async{
    await _userController.RefreshToken();
    var uriResponse = await _apiService.GetTipoviUlaznica(jwtToken: _userController.jwtToken.value, userid: _userController.user.Id);
    List<dynamic> tipoviUlaznicaList = jsonDecode(uriResponse.body);
    tipoviUlaznicaList.forEach((element) {
      var item = element;
      var key = item['id'];
      var value = item['ime'];
      tipoviUlaznica[key] = value;
    });
  }

  Future GetZahtjevByUserId() async{
    await _userController.RefreshToken();
    var response = await _apiService.GetZahtjevByUserId(userId: _userController.user.Id, jwtToken: _userController.jwtToken.value);
    if(response.statusCode == 200){
      zahtjev.value = Zahtjev(
      id: jsonDecode(response.body)['id'],
      userId: _userController.user.Id,
      tipUlazniceId: jsonDecode(response.body)['tipUlazniceZahtjevId'],
      nazivTipaUlaznice: jsonDecode(response.body)['tipUlazniceForZahtjev']['ime'],
      cijena: jsonDecode(response.body)['tipUlazniceForZahtjev']['cijena'],
    );
    }  
    update();
  }

  Future<bool> DeleteZahtjev() async{
    await _userController.RefreshToken();
    var response = await _apiService.DeleteZahtjev(id: zahtjev.value.id, jwtToken: _userController.jwtToken.value);
    if(response.statusCode == 200){
      zahtjev.value = Zahtjev();
      return true;
    }
    return false;
  }

  Future<http.Response> CreateZahtjev({required Zahtjev zahtjev}) async{
    await _userController.RefreshToken();
    var uriResponse = await _apiService.CreateZahtjev(zahtjev: zahtjev, jwtToken: _userController.jwtToken.value);
    return uriResponse;
  }

  

}