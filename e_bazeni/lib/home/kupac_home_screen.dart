import 'dart:async';
import 'package:e_bazeni/controllers/UlaznicaController.dart';
import 'package:e_bazeni/controllers/UserController.dart';
import 'package:e_bazeni/controllers/ZahtjevController.dart';
import 'package:e_bazeni/resusable_objects/alert_dialog.dart';
import 'package:e_bazeni/resusable_objects/loading_screen.dart';
import 'package:e_bazeni/zahtjevi/novizahtjev.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class KupacHomeScreen extends StatefulWidget {

  @override
  _KupacHomeScreenState createState() => _KupacHomeScreenState();
}


class _KupacHomeScreenState extends State<KupacHomeScreen> with SingleTickerProviderStateMixin{

  UserController _userController = Get.find();
  UlaznicaController _ulaznicaController = Get.find();
  ZahtjevController _zahtjevController = Get.find();
  
  GlobalKey qrKey = GlobalKey();
  GlobalKey buttonKey = GlobalKey();
  List<TargetFocus> targets = [];

  Brightness brightnessValue = Brightness.light;
  
  void showTutorial(BuildContext context, TutorialCoachMark tutorialCoachMark, List<TargetFocus> targets, GlobalKey qrKey, GlobalKey buttonKey) async{
    targets.clear();
      targets.add(
      TargetFocus(
        paddingFocus: 1,
        identify: "qrKey",
        keyTarget: qrKey,
        alignSkip: Alignment.bottomRight,
        
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (_context, controller){
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ovdje kliknite za skeniranje QR koda postojeće ulaznice za više korisnika(obiteljska ulaznica)",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white
                      ),
                    )
                  ],
                ),
              );
            }
          )
        ]
      )
    );
    targets.add(
    TargetFocus(
      radius: 5,
      identify: "buttonKey",
      keyTarget: buttonKey,
      alignSkip: Alignment.topRight,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (_context, controller){
            return Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ovdje kliknite za slanje zahtjeva za novom ulaznicom",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                  SizedBox(height: 70,)
                ],
              ),
            );
          }
        )
      ]
    )
  );
    tutorialCoachMark.show();
  }

  Future getUlaznica() async{
    await _ulaznicaController.GetUlaznicaByUserId();
  }

  late AnimationController _pulseController;
  late Animation<Color?> _colorAnimation;

  void getZahtjev() async{
    await _zahtjevController.GetZahtjevByUserId();
  }
  @override
  void initState() {
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this
    )..repeat();
    _colorAnimation = ColorTween(
      begin: Colors.grey[300],
      end: Colors.black
    ).animate(_pulseController);

    getUlaznica();
    getZahtjev();
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    brightnessValue = MediaQuery.of(context).platformBrightness;
    return Scaffold(
      body: GetBuilder<UlaznicaController>(
        builder: (controller) => 
        controller.loading.value == true? LoadingScreen(color: Colors.redAccent[700]!, size: 50.0,):
        controller.ulaznica.value.brojUlaznice == null ? RefreshIndicator(
          onRefresh: () async{
            await getUlaznica();
          },
          color: Colors.redAccent[700],
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, _) => Padding(
                padding: const EdgeInsets.fromLTRB(25, 80, 25, 80),
                child: Card(
                  elevation: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        key: qrKey,
                        onTap: () async{
                          if(await Permission.camera.request().isGranted){
                            var brojUlaznice = await scanner.scan();
                            if(brojUlaznice != null){
                              bool success = await _ulaznicaController.AddKorisnikToUlaznica(brojUlaznice);
                              if(!success){
                                CustomAlertDialog.showDialog(
                                  title: "Greška", 
                                  message: "Broj ulaznice nije valjan ili pokušavate koristiti ulaznicu za dijete kao punoljetna osoba", 
                                  cont: context
                                );
                              }
                            }
                            else{
                              CustomAlertDialog.showDialog(
                                title: "Greška", 
                                message: "QR kod je neispravan", 
                                cont: context
                              );
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: QrImage(
                            data: "",
                            foregroundColor: _colorAnimation.value,
                            size: 200,
                          ),
                        ),
                      ),
                      SizedBox(height: 60.0,),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.topLeft, 
                        child: Text(
                          "Trenutno nemate registriranu ulaznicu",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      SizedBox(height: 30,),
                        GetBuilder<ZahtjevController>(
                          builder: (controller) => controller.zahtjev.value.id == null? Padding(
                          padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                          child: TextButton(
                            key: buttonKey,
                            onPressed: (){
                              Get.to(() => NoviZahtjev());
                            } ,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("Pošalji zahtjev za sezonsku ulaznicu", style: TextStyle(color: Colors.white, fontSize: 13), textAlign: TextAlign.center,),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent[700]!)
                                      
                            ),
                          ),
                      ): Padding(
                          padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                          child: TextButton(
                            key: buttonKey,
                            onPressed: (){} ,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("Zahtjev za sezonskom ulaznicom je poslan!", style: TextStyle(color: Colors.white, fontSize: 13), textAlign: TextAlign.center,),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.green[400]!)
                                      
                            ),
                          ),
                      ),
                        )
                      
                    ],
                  ),
                ),
              ),
            )
          ),
        ): Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 50, 25, 50),
            child: Card(
              elevation: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  QrImage(
                    data: controller.ulaznica.value.brojUlaznice,
                    version: QrVersions.auto,
                    size: 250.0,
                    foregroundColor: brightnessValue == Brightness.dark ? Colors.white: Colors.black
                  ),
                  SizedBox(height: 20,),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.topLeft, 
                    child: Text("${_userController.user.Ime} ${_userController.user.Prezime}", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),)
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.topLeft, 
                        child: Icon(Icons.calendar_today_outlined, size: 30,)
                      ),
                      SizedBox(width: 15,),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                      alignment: Alignment.topLeft, 
                        child: Text("Ulaznica valjana do: ${_ulaznicaController.ulaznica.value.endDate}", style: TextStyle(fontSize: 15))
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.topLeft, 
                      child: Text(
                        int.parse(_ulaznicaController.ulaznica.value.preostaloKorisnika) != 0 ?
                        "Ulaznicu trenutno koristi ${_ulaznicaController.ulaznica.value.brojKorisnika} korisnik/a i može ju koristiti još maksimalno ${_ulaznicaController.ulaznica.value.preostaloKorisnika} korisnik/a":
                        "Ulaznicu trenutno koristi ${_ulaznicaController.ulaznica.value.brojKorisnika} korisnik/a i nitko je više ne može koristiti",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: brightnessValue == Brightness.light ? Colors.grey[700] : Colors.grey[400],
                          fontSize: 15
                        ),
                        ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ),
      floatingActionButton: !_ulaznicaController.loading.value ?  GetBuilder<UlaznicaController>(
        builder: (controller) =>  _ulaznicaController.ulaznica.value.brojUlaznice == null? FloatingActionButton(
          child: Icon(FontAwesomeIcons.questionCircle),
          backgroundColor: Colors.redAccent[700],
          onPressed: () {
            showTutorial(
              context, 
              TutorialCoachMark(
                context, 
                targets: targets,
                textSkip: "Preskoči tutorijal",
              ), 
              targets, 
              qrKey, 
              buttonKey
            );
          },
        ):Container(),
      ): Container(),
    );
  }
}