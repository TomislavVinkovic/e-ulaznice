import 'dart:convert';
import 'package:e_bazeni/controllers/UserController.dart';
import 'package:e_bazeni/models/DTOs/kreacija_ulaznice_request.dart';
import 'package:e_bazeni/models/DTOs/kreacija_ulaznice_response.dart';
import 'package:e_bazeni/models/DTOs/ovjera_ulaznice_dto.dart';
import 'package:e_bazeni/models/DTOs/ponsiti_posjet_dto.dart';
import 'package:e_bazeni/models/DTOs/userlogindto.dart';
import 'package:e_bazeni/models/Ulaznica.dart';
import 'package:e_bazeni/models/User.dart';
import 'package:e_bazeni/services/apiservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';


class UlaznicaController extends GetxController{

  final ulaznica = Ulaznica().obs;
  UserController _userController = Get.find();
  ApiService _apiService = ApiService();

  final loading = true.obs;
  Future GetUlaznicaByUserId() async{
    loading.value = true;
    try{
      await _userController.RefreshToken();
      var response = await _apiService.GetUlaznicaByUserId(userId: _userController.user.Id, jwtToken: _userController.jwtToken.value);
      if(response.statusCode == 200){
        var jsonResponse = jsonDecode(response.body);
        var maksimalanBrojKorisnika = jsonResponse['ulaznicaWithProperties']['tipUlaznice']['maksimalanBrojKorisnika'] ?? 0;
        var brojKorisnika = jsonResponse['korisniciUlaznice'] ?? 0;
        ulaznica.value = Ulaznica(
          brojUlaznice: jsonResponse['korisnikUsesUlaznica']['key'],
          brojKorisnika: brojKorisnika.toString(),
          tipUlaznice: jsonResponse['ulaznicaWithProperties']['tipUlaznice']['id'],
          endDate: DateFormat('dd.MM.yyyy.').format(DateTime.parse(jsonResponse['korisnikUsesUlaznica']['ulaznica']['endDate']).toLocal()),
          preostaloKorisnika: (maksimalanBrojKorisnika - brojKorisnika).toString()
        ); 
      }
      loading.value = false;
      update();
    }
    catch(exception){
      throw exception;
    }
    
    
  }

  Future<bool> AddKorisnikToUlaznica(String brojUlaznice) async{
    loading.value = true;
    try{
      await _userController.RefreshToken();
      var response = await _apiService.AddKorisnikToUlaznica(jwtToken: _userController.jwtToken.value, brojUlaznice: brojUlaznice, userId: _userController.user.Id);
      if(response.statusCode == 200){
        var jsonResponse = jsonDecode(response.body);
        var maksimalanBrojKorisnika = jsonResponse['ulaznicaWithProperties']['tipUlaznice']['maksimalanBrojKorisnika'] ?? 0;
        var brojKorisnika = jsonResponse['korisniciUlaznice'] ?? 0;
        ulaznica.value = Ulaznica(
          brojUlaznice: jsonResponse['korisnikUsesUlaznica']['key'],
          brojKorisnika: brojKorisnika.toString(),
          tipUlaznice: jsonResponse['ulaznicaWithProperties']['tipUlaznice']['id'],
          endDate: DateFormat('dd.MM.yyyy.').format(DateTime.parse(jsonResponse['korisnikUsesUlaznica']['ulaznica']['endDate']).toLocal()),
          preostaloKorisnika: (maksimalanBrojKorisnika - brojKorisnika).toString()
        ); 
        loading.value = false;
        update();
        return true;
      }
      else return false;
    }
    catch(exception){
      throw exception;
    }
  }

  Future<OvjeraUlazniceDTO> OvjeraUlaznice({required String brojUlaznice}) async{
    try{
      await _userController.RefreshToken();
    var response = await _apiService.OvjeraUlaznice(jwtToken: _userController.jwtToken.value, brojUlaznice: brojUlaznice);

    if(response.statusCode == 200){
      var ovjeraUlazniceDTO = OvjeraUlazniceDTO.fromJson(jsonDecode(response.body));
      return ovjeraUlazniceDTO;
    }
    else{
      return OvjeraUlazniceDTO(
        IsValid: false
      );
    }
    }
    catch(exception){
      throw exception;
    }
    

  }

  Future<KreacijaUlazniceResponse> KreirajUlaznicu({required KreacijaUlazniceRequest kreacijaUlazniceRequest}) async{
    try{
      await _userController.RefreshToken();
      var response = await _apiService.KreirajUlaznicu(jwtToken: _userController.jwtToken.value, kreacijaUlazniceRequest: kreacijaUlazniceRequest);

      if(response.body != ""){
        var kreacijaUlazniceResponse = KreacijaUlazniceResponse.fromJson(jsonDecode(response.body));
        return kreacijaUlazniceResponse;
      }
      else{
        return KreacijaUlazniceResponse(isSuccessful: false, errors: ["Greška prilikom obrade zahtjeva, pokušajte ponovno kasnije"]);
      }
    }
    
    catch(exception){
      throw exception;
    }

  }

  Future<PonistiPosjetDTO> PonistiPosjet({required String brojUlaznice}) async{
    try{
      await _userController.RefreshToken();
      var response = await _apiService.PonistiPosjet(jwtToken: _userController.jwtToken.value, brojUlaznice: brojUlaznice);

      if(response.statusCode == 200){
        var ponistiPosjetDTO = PonistiPosjetDTO.fromJson(jsonDecode(response.body));
        return ponistiPosjetDTO;
      }
      else{
        return PonistiPosjetDTO(
          IsRevoked: false
        );
      }
    }
    catch(exception){
      throw exception;
    }
  }

  //API FUNCTIONS END HERE
  
}