import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:e_bazeni/auth/validators/password_validator.dart';
import 'package:e_bazeni/controllers/UserController.dart';
import 'package:e_bazeni/models/DTOs/userregistrationdto.dart';
import 'package:e_bazeni/models/User.dart';
import 'package:e_bazeni/resusable_objects/alert_dialog.dart';
import 'package:e_bazeni/resusable_objects/loading_screen.dart';
import 'package:e_bazeni/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Register extends StatefulWidget {

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  bool loading = false;

  var _formKey = GlobalKey<FormState>();

  UserController _userController = Get.find();

  String userName = "";
  String email = "";
  String oib = "";
  String ime = "";
  String prezime = "";
  String prebivaliste = "";
  String boraviste = "";
  String password = "";
  String rPassword = "";
  dynamic datumRodenja;

  TextEditingController txt = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: loading == true? LoadingScreen(size: 70.0, color: Colors.redAccent[700]!): Form(
              key: _formKey,
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
                      onChanged: (value) => setState(() => userName = value) ,
                    ),
                    
                    SizedBox(height: 20.0,),
              
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "E-mail adresa",
                        errorStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)
                        ),
                        suffixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (!value!.contains("@") || !value.contains(".")) {
                          return 'Molimo unesite ispravno formatiranu E-mail adresu!';
                        }
                        return null;
                      },
                      onChanged: (value) => setState(() => email = value) ,
                    ),
                    
                    SizedBox(height: 20.0,),
              
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Ime",
                        errorStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)
                        ),
                        suffixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value!.length < 2) {
                          return 'Molimo usesite ime koje je ima minimalno 2 slova!';
                        }
                        return null;
                      },
                      onChanged: (value) => setState(() => ime = value) ,
                    ),
                    
                    SizedBox(height: 20.0,),
                    
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Prezime",
                        errorStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)
                        ),
                        suffixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value!.length < 2) {
                          return 'Molimo usesite prezime koje je ima minimalno 2 slova!';
                        }
                        return null;
                      },
                      onChanged: (value) => setState(() => prezime = value) ,
                    ),
                    
                    SizedBox(height: 20.0,),
                                      
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "OIB",
                        errorStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)
                        ),
                        suffixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value!.length != 11) {
                          return 'OIB mora imati točno 11 znamenaka!';
                        }
                        if(int.tryParse(value) == null){
                          return'OIB se sastoji isključivo od brojeva!';
                        }
                        return null;
                      },
                      onChanged: (value) => setState(() => oib = value) ,
                    ),

                    SizedBox(height: 20.0,),

                    TextFormField(
                      controller: txt,
                      decoration: InputDecoration(
                        hintText: "Datum rođenja",
                        errorStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)
                        ),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),

                      onTap: () async{
                        var date = await showDatePicker(
                          context: context, 
                          initialDate: DateTime.now().toUtc().subtract(Duration(days: 365 * 18)), 
                          firstDate: DateTime(1930, 1, 1), 
                          lastDate: DateTime.now().toUtc()
                        );
                        if(date != null && date != datumRodenja){
                          setState(() {
                            datumRodenja = date;
                            txt.text = DateFormat('dd.MM.yyyy.').format(datumRodenja);
                          });
                        }

                      },

                    ),
                    
                    SizedBox(height: 20.0,),
                                                        
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Prebivalište",
                        errorStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)
                        ),
                        suffixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value!.length < 2) {
                          return 'Molimo unestite ispravan naziv mjesta!';
                        }
                        return null;
                      },
                      onChanged: (value) => setState(() => prebivaliste = value) ,
                    ),
                    
                    SizedBox(height: 20.0,),
                                                                          
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Boravište",
                        errorStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)
                        ),
                        suffixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value!.length < 2) {
                          return 'Molimo unestite ispravan naziv mjesta!';
                        }
                        return null;
                      },
                      onChanged: (value) => setState(() => boraviste = value) ,
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
                            return 'Molimo unesite lozinku!';
                          }
                          if (value.length < 8) {
                            return 'Molimo unesite lozinku koja ima minimalno 8 znakova!';
                          }
                          if (!PasswordValidator.validatePassword(value)) {
                            return 'Lozinka se mora sastojati od velikih i malih slova, brojeva i specijalnih znakova';
                          }
                          if(value != rPassword){
                            return 'Oba polja za lozinku moraju se podudarati!';
                          }
                          return null;
                      },
                      onChanged: (value) => setState(() => password = value) ,
                    ),
                    
                    SizedBox(height: 20.0,),
              
                      TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Ponovi lozinku",
                        errorStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)
                        ),
                        suffixIcon: Icon(Icons.password),
                      ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Molimo ispunite ovo polje!';
                          }
                          if (value.length < 8) {
                            return 'Molimo unesite lozinku koja ima minimalno 8 znakova!';
                          }
                          if (!PasswordValidator.validatePassword(value)) {
                            return 'Lozinka se mora sastojati od velikih i malih slova, brojeva i specijalnih znakova';
                          }
                          if(value != rPassword){
                            return 'Oba polja za lozinku moraju se podudarati!';
                          }
                          return null;
                      },
                      onChanged: (value) => setState(() => rPassword = value) ,
                    ),
                    
                    SizedBox(height: 20.0,),

                    TextButton(
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        if(_formKey.currentState!.validate()){
                            var result = await _userController.Register(userRegistrationDTO: UserRegistrationDTO(
                            UserName: userName,
                            Email: email,
                            Ime: ime,
                            Prezime: prezime,
                            OIB: oib,
                            Prebivaliste: prebivaliste,
                            Boraviste: boraviste,
                            Password: password,
                            DatumRodenja: DateFormat('MM-dd-yyyy').format(datumRodenja)
                          ));
                          

                          if(result.statusCode == 200){
                            setState(() {
                              loading = false;
                            });
                            CustomAlertDialog.showDialog(cont: context, title: "Registracija uspješna!", message:"Molimo potvrdite vašu e-mail adresu kako biste se mogli prijaviti u aplikaciju");
                          }
                          else{
                            setState(() {
                              loading = false;
                            });
                            if(result.statusCode != 502){
                              CustomAlertDialog.showDialog(title: "Greška", message: jsonDecode(result.body)['errors'][0]?? "Dogodila se greška pri registraciji!", cont: context,);
                            }
                            else{
                              CustomAlertDialog.showDialog(title: "Greška", message: "Dogodila se greška pri registraciji!", cont: context,);
                            }
                            
                          }
                        }
                          
                      }, 
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Registracija", style: TextStyle(fontSize: 18.0, color: Colors.white),),
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
            )
          ),
        ),
    );
  }
}