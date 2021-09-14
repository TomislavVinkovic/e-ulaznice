import 'package:e_bazeni/controllers/UlaznicaController.dart';
import 'package:e_bazeni/controllers/UserController.dart';
import 'package:e_bazeni/models/Ulaznica.dart';
import 'package:e_bazeni/resusable_objects/alert_dialog.dart';
import 'package:e_bazeni/resusable_objects/custom_appbar.dart';
import 'package:e_bazeni/resusable_objects/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class PonistiPosjet extends StatefulWidget {

  @override
  _PonistiPosjetState createState() => _PonistiPosjetState();
}

class _PonistiPosjetState extends State<PonistiPosjet> {

  UserController _userController = Get.find();
  UlaznicaController _ulaznicaController = Get.find();

  var cardColor = Colors.white;
  var qrColor = Colors.black;
  var buttonColor = Colors.redAccent[700]!;
  String qrImageData = "";
  String validationString = "";

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(backButtonEnabled: true, cont: context, title: "Poništi posjet",),
      backgroundColor: cardColor,
      body: !loading? Center( 
        child: Card(
          color: cardColor,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50, 40, 50, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                QrImage(data: qrImageData, size: 200, foregroundColor: qrColor,),
                SizedBox(height: 80,),
                TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(buttonColor)
                ),
                onPressed: () async{
                  var brojUlaznice = await scanner.scan();
                  if(brojUlaznice != null){
                    var ponsitiPosjetDTO = await _ulaznicaController.PonistiPosjet(brojUlaznice: brojUlaznice);
                    if(ponsitiPosjetDTO.IsRevoked == true){
                      setState(() {
                        qrImageData = brojUlaznice;
                        cardColor = Colors.green;
                        qrColor = Colors.white;
                        buttonColor = Colors.green[800]!;
                        validationString = "Posjet uspješno poništen!";
                      });
                    }
                    else{
                      setState(() {
                        qrImageData = brojUlaznice;
                        cardColor = Colors.redAccent;
                        buttonColor = Colors.red;
                        qrColor = Colors.white;
                        validationString = "Posjet nije mogao biti poništen! Posjet je već poništen ili ulaznica nije valjana!";
                      });
                    }
                  }
                  else{
                    CustomAlertDialog.showDialog(title: "Greška", message: "QR kod nije mogao biti skeniran", cont: context,);
                  }
                }, 
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Skeniraj ulaznicu", style: TextStyle(color: Colors.white),),
                )
              ),
              SizedBox(height: 30.0,),
              Text(
                validationString,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              )
              ],
            ),
          ),
        ),
      ): LoadingScreen(size: 70, color: Colors.red),
    );
    
  }
}