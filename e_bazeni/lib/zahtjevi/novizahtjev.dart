import 'package:e_bazeni/controllers/ZahtjevController.dart';
import 'package:e_bazeni/controllers/UserController.dart';
import 'package:e_bazeni/models/Zahtjev.dart';
import 'package:e_bazeni/resusable_objects/custom_appbar.dart';
import 'package:e_bazeni/resusable_objects/loading_screen.dart';
import 'package:e_bazeni/services/apiservice.dart';
import 'package:e_bazeni/zahtjevi/moji_zahtjevi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoviZahtjev extends StatefulWidget {

  @override
  _NoviZahtjevState createState() => _NoviZahtjevState();
}

class _NoviZahtjevState extends State<NoviZahtjev> {

  
  UserController _userController = Get.find();
  ZahtjevController _zahtjevController = Get.find();

  List<DropdownMenuItem<int>> tipoviUlaznica = [];

  bool loading = false;

  Future initList() async{
    setState(() {
      loading = true;
    });
    await _zahtjevController.GetTipoviUlaznica();
    if(mounted){
      setState(() {
      tipoviUlaznica = _zahtjevController.tipoviUlaznica.map((key, value) {
        return MapEntry(
          key,
          DropdownMenuItem(
            value: key,
            child: Text(value.toString())
          )
        );
      }).values.toList();
      loading = false;
    });
    }
  }

  void getZahtjev() async{
    await _zahtjevController.GetZahtjevByUserId();
  }

  @override
  void initState() {
    super.initState();
    getZahtjev();
    initList();
  }

  var _formKey = GlobalKey<FormState>();
  
  int tipUlaznice = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(title: "Novi zahtjev za sezonskom ulaznicom", cont: context, backButtonEnabled: true,),
      body: SafeArea(
        child: !loading ? SingleChildScrollView(
          child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 50, 30, 0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            hintText: "${_userController.user.Ime} ${_userController.user.Prezime}",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)
                            ),
                          ),
                          enabled: false,
                        ),
                        SizedBox(height: 20,),
                        TextField(
                          decoration: InputDecoration(
                            hintText: "${_userController.user.DatumRodenja}",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)
                            ),
                          ),
                          enabled: false,
                        ),
                        SizedBox(height: 20,),
                        TextField(
                          decoration: InputDecoration(
                            hintText: "${_userController.user.Prebivaliste}",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)
                            ),
                          ),
                          enabled: false,
                        ),
                        SizedBox(height: 20,),
                        TextField(
                          decoration: InputDecoration(
                            hintText: "${_userController.user.Boraviste}",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)
                            ),
                          ),
                          enabled: false,
                        ),
                        SizedBox(height: 20,),
                        DropdownButtonFormField(
                          isExpanded: true,
                          hint: Text("-- Odaberite tip ulaznice --"),
                          decoration: InputDecoration(
                            
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)
                            ),
                          ),
                          items: tipoviUlaznica,
                          onChanged: (value) => setState(() => tipUlaznice = int.parse(value!.toString())),
                          validator: (value) {
                            if(tipUlaznice == 0){
                              return "Neispravan tip ulaznice";
                            }
                          },
                        ),
                        SizedBox(height: 20.0,),
                        TextButton(
                          onPressed: () async {
                            if(_formKey.currentState!.validate() && tipUlaznice != 0){
                              var result = await _zahtjevController.CreateZahtjev(zahtjev: Zahtjev(
                                userId: _userController.user.Id,
                                tipUlazniceId: tipUlaznice
                              ));
                              if(result.statusCode == 201){
                                Get.off(() => MojiZahtjevi());
                              }
                            } 
                          }, 
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("Dodaj novi zahtjev", style: TextStyle(color: Colors.white),),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent[700]!),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
        ): LoadingScreen(size: 70.0, color: Colors.redAccent[700]!),
      ),
    );
  }
}