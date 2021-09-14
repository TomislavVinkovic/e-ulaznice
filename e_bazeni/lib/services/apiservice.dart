import 'dart:convert';
import 'dart:io';
import 'package:e_bazeni/controllers/UserController.dart';
import 'package:e_bazeni/models/DTOs/kreacija_ulaznice_request.dart';
import 'package:e_bazeni/models/DTOs/userlogindto.dart';
import 'package:e_bazeni/models/DTOs/userpatchDTO.dart';
import 'package:e_bazeni/models/DTOs/userregistrationdto.dart';
import 'package:e_bazeni/models/User.dart';
import 'package:e_bazeni/models/Zahtjev.dart';
import 'package:http/http.dart' as http;

class ApiService{

  static const String _apiUrl = "https://7323-141-138-24-130.ngrok.io";

  final client = http.Client();

  static const errorConnectionResponseMap = <String, dynamic>{
    'errors': ["Veza sa serverom nije mogla biti uspostavljena"]
  };

  var errorConnectionResponse = http.Response(
    jsonEncode(errorConnectionResponseMap),
    500
  );
  
  //AUTH REQUESTS
  Future<http.Response> Login(UserLoginDTO userLoginDto) async{
    try{
      var userJsonMap = userLoginDto.toJsonMap();
      var userJson = jsonEncode(userJsonMap);

      var uriResponse = await http.post(
        Uri.parse(_apiUrl + "/api/authmanagement/login"), 
        body: userJson, 
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

      return uriResponse;
    }
    catch(exception){
      return errorConnectionResponse;
    }
    
  }

  //register action will go here
  Future<http.Response> Register({required UserRegistrationDTO userRegistrationDto}) async{
    try{
      var uriResponse = await http.post(
        Uri.parse(_apiUrl + "/api/authmanagement/register"),
        body: jsonEncode(userRegistrationDto.toJsonMap()),
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      return uriResponse;
    }

    catch(exception){
      return errorConnectionResponse;
    }
    
  }

  //uredivanje informacija o korisniku
  Future<http.Response> EditUserInformation({required String jwtToken, required UserToPatchDTO userToPatchDTO, required String userId}) async{
    try{
      var uriResponse = await http.post(
        Uri.parse(_apiUrl + "/api/usermanagement/$userId"),
        body: jsonEncode(userToPatchDTO.toJsonMap()),
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $jwtToken'
        },
      );

      return uriResponse;
    }
    catch(exception){
      return errorConnectionResponse;
    }
    
  }

  //ULAZNICA I ZAHTJEV REQUESTOVI
  Future<http.Response> GetTipoviUlaznica({required String jwtToken, required String userid}) async{
    try{
      var uriResponse = await http.get(
        Uri.parse(_apiUrl + "/api/tipoviulaznica?userid=$userid"),
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $jwtToken'
        },
      );

      return uriResponse;
    }
    catch(exception){
      return errorConnectionResponse;
    }
    
  }

  Future<http.Response> CreateZahtjev({required Zahtjev zahtjev, required String jwtToken}) async{
    try{
      var uriResponse = await http.post(
      Uri.parse(_apiUrl + "/api/zahtjevi"),
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $jwtToken'
        },
        body: jsonEncode(zahtjev.toJsonMap())
      );

      return uriResponse;
    }
    catch(exception){
      return errorConnectionResponse;
    }

  }

  Future<http.Response> GetZahtjevByUserId({required String userId, required String jwtToken}) async{
    try{
      var uriResponse = await http.get(
        Uri.parse(_apiUrl + "/api/zahtjevi/$userId"),
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $jwtToken'
        },
      );

      return uriResponse;
    }
    catch(exception){
      return errorConnectionResponse;
    }
    
  }

  
  Future<http.Response> DeleteZahtjev({required int id, required String jwtToken}) async{
    try{
      var uriResponse = await http.delete(
        Uri.parse(_apiUrl + "/api/zahtjevi/$id"),
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': "Bearer $jwtToken"
          },
      ); 
      return uriResponse;
    }
    catch(exception){
      return errorConnectionResponse;
    }
    
  }

  Future<http.Response> GetUlaznicaByUserId({required String userId, required String jwtToken}) async{
    try{
      var uriResponse = await http.get(
        Uri.parse(_apiUrl + "/api/ulaznice/$userId"),
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $jwtToken'
        },
      );

      return uriResponse;
    }
    catch(exception){
      return errorConnectionResponse;
    }
    
  }

  Future<http.Response> AddKorisnikToUlaznica({required String jwtToken, required String userId, required String brojUlaznice}) async{
    try{
      var uriResponse = await http.post(
        Uri.parse(_apiUrl + "/api/ulaznice/addkorisniktoulaznica?brojulaznice=$brojUlaznice&userid=$userId"),
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $jwtToken'
        },
      );

      return uriResponse;
    }
    catch(exception){
      return errorConnectionResponse;
    }
    
  }

  Future<http.Response> OvjeraUlaznice({required String jwtToken, required String brojUlaznice}) async{
    try{
      var uriResponse = await http.post(
        Uri.parse(_apiUrl + "/api/ulaznice/ovjeraulaznice?brojulaznice=$brojUlaznice"),
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $jwtToken'
        },
      );

      return uriResponse;
    }
    catch(exception){
      return errorConnectionResponse;
    }
    
  }

  Future<http.Response> KreirajUlaznicu({required String jwtToken, required KreacijaUlazniceRequest kreacijaUlazniceRequest}) async{
    try{
      var uriResponse = await http.post(
        Uri.parse(_apiUrl + "/api/ulaznice/kreirajulaznicu"),
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $jwtToken'
        },
        body: jsonEncode(kreacijaUlazniceRequest.toJsonMap())
      );

      return uriResponse;
    }
    catch(exception){
      return errorConnectionResponse;
    }
    
  }

  Future<http.Response> PonistiPosjet({required String jwtToken, required String brojUlaznice}) async{
    try{
      var uriResponse = await http.post(
      Uri.parse(_apiUrl + "/api/ulaznice/ponistiposjet?brojulaznice=$brojUlaznice"),
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $jwtToken'
        },
      );
    return uriResponse;
    }
    catch(exception){
      return errorConnectionResponse;
    }

    
  }

  //REQUEST ZA REFRESH TOKENA
  //refresh token action will go here
  Future<http.Response> RefreshToken({required String refreshToken, required String token}) async{
    try{
      var body = <String, String>{
      'token': token,
      'refreshToken': refreshToken
      };
      var uriResponse = await http.post(
        Uri.parse(_apiUrl + "/api/authmanagement/refreshtoken"),
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body)
      );
      return uriResponse;
    }
    

    catch(exception){
      return errorConnectionResponse;
    }
  }


}