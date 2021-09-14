import 'package:e_bazeni/auth/edituserinformation.dart';
import 'package:e_bazeni/controllers/UserController.dart';
import 'package:e_bazeni/resusable_objects/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MyProfile extends StatefulWidget {

  @override
  _MyProfileState createState() => _MyProfileState();
}


class _MyProfileState extends State<MyProfile> {

  UserController _userController = Get.find();
  late Brightness brightnessValue;


  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    brightnessValue = MediaQuery.of(context).platformBrightness;
    return Scaffold(
      appBar: CustomAppBar(backButtonEnabled: true, cont: context, title: 'Moj profil',),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(60, 0, 60, 10),
              child: RefreshIndicator(
                onRefresh: () async{
                  setState(() {});
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 50,),
                      Image.asset("assets/images/profile.png", width: 200,),
                      SizedBox(height: 20,),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.topLeft, 
                        child: Text(
                          "${_userController.user.Ime} ${_userController.user.Prezime}",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.topLeft, 
                        child: Text(
                          "${_userController.user.UserName}\n ${_userController.user.Email}",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 15,
                              color: brightnessValue == Brightness.light ?  Colors.grey[700]: Colors.grey[400]
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                      alignment: Alignment.topLeft, 
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, size: 18),
                            SizedBox(width: 20,),
                            Text(
                              "${_userController.user.DatumRodenja}",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  fontSize: 15,
                                  color: brightnessValue == Brightness.light ?  Colors.grey[700]: Colors.grey[400]
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      FittedBox(
                        child: Row(
                          children: [
                            Icon(FontAwesomeIcons.building, size: 18),
                            SizedBox(width: 20,),
                            Text(
                              "${_userController.user.Prebivaliste}, ${_userController.user.Boraviste}",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  color: brightnessValue == Brightness.light ?  Colors.grey[700]: Colors.grey[400]
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 30,),
                      TextButton(
                        onPressed: () => Get.to(EditUserInformation()),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent[700]!)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Uredi informacije profila",
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ),
                        )
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}