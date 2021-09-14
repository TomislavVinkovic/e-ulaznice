import 'package:e_bazeni/controllers/UserController.dart';
import 'package:e_bazeni/controllers/ZahtjevController.dart';
import 'package:e_bazeni/models/Zahtjev.dart';
import 'package:e_bazeni/resusable_objects/alert_dialog.dart';
import 'package:e_bazeni/resusable_objects/custom_appbar.dart';
import 'package:e_bazeni/resusable_objects/loading_screen.dart';
import 'package:e_bazeni/zahtjevi/novizahtjev.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MojiZahtjevi extends StatefulWidget {

  @override
  _MojiZahtjeviState createState() => _MojiZahtjeviState();
}

class _MojiZahtjeviState extends State<MojiZahtjevi> {

  ZahtjevController _zahtjevController = Get.find();
  UserController _userController = Get.find();

  Zahtjev zahtjevForUser = Zahtjev();

  bool loading = false;
    
  void setZahtjev() async{
    setState(() {
      loading = true;
    });
    await _zahtjevController.GetZahtjevByUserId();
    setState(() {
      zahtjevForUser = _zahtjevController.zahtjev.value;
      loading = false;
    });
  }

  @override
  void initState() {
    if(mounted){
      super.initState();
      setZahtjev();
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Moji zahtjevi", cont: context, backButtonEnabled: true,),
      body: loading? LoadingScreen(size: 70, color: Colors.redAccent[700]!) : zahtjevForUser.id == null ?
      Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Niste još podnijeli niti jedan zahtjev za sezonskom ulaznicom.",
            textAlign: TextAlign.center,
            ),
        ),
      ) 
      : Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 50, 30, 100),
          child: Card(
            elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: QrImage(
                      data: _zahtjevController.zahtjev.value.id.toString(),
                      version: QrVersions.auto,
                      size: 200,
                      foregroundColor: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text("${_userController.user.Ime} ${_userController.user.Prezime}",
                   textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text("${_zahtjevController.zahtjev.value.nazivTipaUlaznice.toString()}",
                   textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text("${_zahtjevController.zahtjev.value.cijena.toString()} kn",
                   textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.red[800]!),
                      
                          ),
                          onPressed: () async{
                            bool isDeleted = await _zahtjevController.DeleteZahtjev();
                            if(isDeleted == true){
                              CustomAlertDialog.showDialog(title: "Uspjeh", message: "Uspješno ste izbrisali zahtjev!", cont: context,);
                              setState(() {
                                zahtjevForUser = Zahtjev();
                              });
                            }
                            else{
                              CustomAlertDialog.showDialog(title: "Greška", message: "Zahtjev nije uspješno obrisan. Za više informacija, obratite se korisničkoj podršci", cont: context,);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(FontAwesomeIcons.trash, color: Colors.white,),
                          )
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
        ),
      )
      );
  }
}