import 'package:e_bazeni/controllers/UlaznicaController.dart';
import 'package:e_bazeni/controllers/UserController.dart';
import 'package:e_bazeni/resusable_objects/alert_dialog.dart';
import 'package:e_bazeni/resusable_objects/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class ZaposlenikScannerHomeScreen extends StatefulWidget {

  @override
  _ZaposlenikScannerHomeScreenState createState() => _ZaposlenikScannerHomeScreenState();
}

class _ZaposlenikScannerHomeScreenState extends State<ZaposlenikScannerHomeScreen> {

  UserController _userController = Get.find();
  UlaznicaController _ulaznicaController = Get.find();
  late Color qrColor;
  dynamic cardColor;
  var buttonColor = Colors.redAccent[700]!;
  String qrImageData = "";
  String validationString = "";

  bool loading = false;

  late Brightness brightnessValue;

  @override
  Widget build(BuildContext context) {
    brightnessValue = MediaQuery.of(context).platformBrightness;
    brightnessValue == Brightness.light ? qrColor = Colors.black: qrColor = Colors.white;
    return Scaffold(
      backgroundColor: cardColor == null ? qrColor == Colors.black ? Colors.white: Colors.black12: cardColor,
      body: !loading? Center( 
        child: Card(
          color: cardColor == null ? qrColor == Colors.black ? Colors.white: Colors.black12: cardColor,
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
                  if(await Permission.camera.request().isGranted){
                    var brojUlaznice = await scanner.scan();
                    if(brojUlaznice == null){
                      CustomAlertDialog.showDialog(title: "Greška", message: "Neispravan QR kod", cont: context,);
                      return;
                    }
                    setState(() {
                      loading = true;
                    });
                    var ovjeraUlazniceDTO = await _ulaznicaController.OvjeraUlaznice(brojUlaznice: brojUlaznice);
                    if(ovjeraUlazniceDTO.IsValid){
                      if(ovjeraUlazniceDTO.AlreadyVisited == null || ovjeraUlazniceDTO.AlreadyVisited == false){
                        setState(() {
                          qrImageData = brojUlaznice;
                          cardColor = Colors.green;
                          qrColor = Colors.white;
                          buttonColor = Colors.green[800]!;
                          validationString = "Valjana ulaznica";
                          loading = false;
                        });
                      }
                      else{
                         setState(() {
                          qrImageData = brojUlaznice;
                          cardColor = Colors.deepOrange;
                          qrColor = Colors.white;
                          buttonColor = Colors.orange[700]!;
                          validationString = "Valjana ulaznica, korisnik već ušao";
                          loading = false;
                        });
                      }
                    }
                    else{
                      setState(() {
                        qrImageData = brojUlaznice;
                        cardColor = Colors.redAccent;
                        qrColor = Colors.white;
                        buttonColor = Colors.red;
                        validationString = "Ulaznica nije valjana";
                        loading = false;
                      });
                    }
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
                  fontSize: 20,
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