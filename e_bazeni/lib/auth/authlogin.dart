import 'dart:convert';
import 'package:e_bazeni/auth/validators/password_validator.dart';
import 'package:e_bazeni/controllers/UserController.dart';
import 'package:e_bazeni/models/DTOs/userlogindto.dart';
import 'package:e_bazeni/models/User.dart';
import 'package:e_bazeni/resusable_objects/alert_dialog.dart';
import 'package:e_bazeni/resusable_objects/loading_screen.dart';
import 'package:e_bazeni/services/storageservice.dart';
import 'package:e_bazeni/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool loading = false;

  final _formkey = GlobalKey<FormState>();
  final UserController _userController = Get.find();
  final StorageService _storageService = StorageService();
  String username = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: loading == true ? LoadingScreen(size: 70.0, color: Colors.redAccent[700]!) : Form(
              key: _formkey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'logo',
                      child: Image.asset("assets/images/templogo.png", width: 150, height: 150,)
                    ),
                    SizedBox(height: 30.0,),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Korisničko ime",
                        errorStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)
                        ),
                        suffixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Molimo unesite korisničko ime!';
                        }
                        return null;
                      },
                      onChanged: (value) => setState(() => username = value) ,
                    ),
                    SizedBox(height: 20.0,),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Lozinka",
                        errorStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)
                        ),
                        suffixIcon: Icon(Icons.password),
                      ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Molimo unesite korisničko ime!';
                          }
                          if (value.length < 8) {
                            return 'Molimo unesite lozinku koja ima minimalno 8 znakova!';
                          }
                          if (!PasswordValidator.validatePassword(value)) {
                            return 'Lozinka se mora sastojati od velikih i malih slova, brojeva i specijalnih znakova';
                          }
                          return null;
                      },
                      onChanged: (value) => setState(() => password = value) ,
                    ),
                    SizedBox(height: 20.0,),
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        if(_formkey.currentState!.validate()){
                          var result = await _userController.Login(userLoginDTO: UserLoginDTO(
                            UserName: username,
                            Password: password
                          ));
                          if(result.statusCode == 200){
                            var userObject = User.fromJson(jsonDecode(result.body));
                            _userController.user = userObject;
                            _userController.loggedIn.value = true;
                            _userController.jwtToken.value = jsonDecode(result.body)['token'];
                            _userController.refreshToken.value = jsonDecode(result.body)['refreshToken'];
                            _storageService.WriteSecureData("username", username);
                            _storageService.WriteSecureData("password", password);
                            setState(() {
                              loading = false;
                            });
                            Navigator.pop(context);
                          }
                          else{
                            setState(() {
                              loading = false;
                              if(result.statusCode != 502){
                                CustomAlertDialog.showDialog(title: "Greška",  message: jsonDecode(result.body)['errors'][0] ?? "Dogodila se greška pri prijavi!", cont: context);
                              }
                              else{
                                CustomAlertDialog.showDialog(title: "Greška",  message: "Dogodila se greška pri prijavi!", cont: context);
                              }
                            });
                          }
                        } 
                      }, 
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("Prijava", style: TextStyle(fontSize: 15.0, color: Colors.white),),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent[700]?? Colors.redAccent),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)
                        )
                      ),
                    ),
                    )
                  ],
                ),
              ),
            ),
          ),
      ),
    );

  }
}