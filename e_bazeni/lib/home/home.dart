import 'package:e_bazeni/controllers/UlaznicaController.dart';
import 'package:e_bazeni/controllers/UserController.dart';
import 'package:e_bazeni/home/kupac_home_screen.dart';
import 'package:e_bazeni/home/zaposlenik_scanner_home_screen.dart';
import 'package:e_bazeni/models/User.dart';
import 'package:e_bazeni/resusable_objects/custom_appbar.dart';
import 'package:e_bazeni/resusable_objects/loading_screen.dart';
import 'package:e_bazeni/wrapper.dart';
import 'package:e_bazeni/zahtjevi/moji_zahtjevi.dart';
import 'package:e_bazeni/zahtjevi/novizahtjev.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Scaffold(
        appBar: CustomAppBar(title: "E-bazeni", cont: context, backButtonEnabled: false,),
        body: _userController.user.Role == "Kupac" ? KupacHomeScreen() : ZaposlenikScannerHomeScreen()
      ),
    );
  }
}