import 'package:e_bazeni/controllers/UlaznicaController.dart';
import 'package:e_bazeni/models/DTOs/kreacija_ulaznice_request.dart';
import 'package:e_bazeni/models/DTOs/kreacija_ulaznice_response.dart';
import 'package:e_bazeni/resusable_objects/alert_dialog.dart';
import 'package:e_bazeni/resusable_objects/custom_appbar.dart';
import 'package:e_bazeni/resusable_objects/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class KreirajUlaznicu extends StatefulWidget {

  @override
  _KreirajUlaznicuState createState() => _KreirajUlaznicuState();
}

class _KreirajUlaznicuState extends State<KreirajUlaznicu> {

  UlaznicaController _ulaznicaController = Get.find();

  bool loading = false;

  Color cardColor = Colors.white;
  Color qrColor = Colors.black;
  Color buttonColor = Colors.redAccent[700]!;
  Color validationColor = Colors.white;
  String qrImageData = "";
  String validationString = "";

  String brojZahtjevaToSend = "";
  dynamic endDate;
  
  var _formKey = GlobalKey<FormState>();
  TextEditingController txt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(backButtonEnabled: true, cont: context, title: "Kreiraj ulaznicu",),
      backgroundColor: cardColor,
      body: !loading? Form( 
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50, 40, 50, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                QrImage(data: qrImageData, size: 200, foregroundColor: qrColor,),
                SizedBox(height: 30,),
                TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(buttonColor)
                ),
                onPressed: () async{
                  var brojZahtjeva = await scanner.scan();
                  if(brojZahtjeva != null){
                    setState(() {
                      qrImageData = brojZahtjeva.toString();
                      brojZahtjevaToSend = brojZahtjeva.toString();
                    });
                  }
                  else{
                    CustomAlertDialog.showDialog(title: "Greška", message: "QR kod nije mogao biti skeniran", cont: context,);
                  }
                }, 
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Skeniraj zahtjev", style: TextStyle(color: Colors.white),),
                )
              ),
        
              SizedBox(height: 70.0,),
        
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
                    initialDate: DateTime.now(), 
                    firstDate: DateTime.now(), 
                    lastDate: DateTime.now().add(Duration(days: 365*10))
                  );
                  if(date != null && date != endDate){
                    setState(() {
                      endDate = date;
                      txt.text = DateFormat('dd.MM.yyyy.').format(endDate);
                    });
                  }
        
                },
              ),
        
              SizedBox(height: 20.0,),
        
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(buttonColor)
                ),
                onPressed: () async{
                  setState(() {
                    loading = true;
                  });
                  if(brojZahtjevaToSend != "" || endDate != null){
                      var kreacijaUlazniceRequest = KreacijaUlazniceRequest(zahtjevId: brojZahtjevaToSend, endDate: DateFormat("MM-dd-yyyy").format(endDate));
                      KreacijaUlazniceResponse kreacijaUlazniceResponse = await _ulaznicaController.KreirajUlaznicu(kreacijaUlazniceRequest: kreacijaUlazniceRequest);
                      if(kreacijaUlazniceResponse.isSuccessful){
                        setState(() {
                          cardColor = Colors.green;
                          qrColor = Colors.white;
                          buttonColor = Colors.green[800]!;
                          validationString = "Ulaznica uspješno kreirana!";
                          loading = false;
                        });
                      }
                      else{
                        cardColor = Colors.redAccent;
                        buttonColor = Colors.red;
                        qrColor = Colors.white;
                        validationString = kreacijaUlazniceResponse.errors[0];
                        loading = false;
                    }
                  }
        
                  else{
                    setState(() {
                      loading = false;
                      validationString = "Molimo skenirajte ulaznicu i postavite konačan datum!";
                      validationColor = Colors.black;
                    });
                  }
                  
                }, 
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Pošalji zahtjev", style: TextStyle(color: Colors.white),),
                )
              ),
        
              SizedBox(height: 20.0,),
        
              Text(
                validationString,
                style: TextStyle(
                  color: validationColor,
                  fontSize: 13,
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