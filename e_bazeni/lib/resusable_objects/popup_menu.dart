import 'package:e_bazeni/auth/my_profile.dart';
import 'package:e_bazeni/controllers/UlaznicaController.dart';
import 'package:e_bazeni/controllers/UserController.dart';
import 'package:e_bazeni/controllers/ZahtjevController.dart';
import 'package:e_bazeni/home/home.dart';
import 'package:e_bazeni/models/Ulaznica.dart';
import 'package:e_bazeni/models/Zahtjev.dart';
import 'package:e_bazeni/ulaznice/kreiraj_ulaznicu.dart';
import 'package:e_bazeni/ulaznice/moja_ulaznica_zaposlenik.dart';
import 'package:e_bazeni/ulaznice/ponisti_posjet.dart';
import 'package:e_bazeni/wrapper.dart';
import 'package:e_bazeni/zahtjevi/moji_zahtjevi.dart';
import 'package:e_bazeni/zahtjevi/novizahtjev.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class PopupMenu extends StatelessWidget {

  TextStyle listItemStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 15
  );

  UserController _userController = Get.find();
  UlaznicaController _ulaznicaController = Get.find();
  ZahtjevController _zahtjevController = Get.find();

  Future logout(BuildContext context) async{
    await _userController.Logout();
    _ulaznicaController.ulaznica.value = Ulaznica();
    _zahtjevController.zahtjev.value = Zahtjev();
    Navigator.pop(context);
    Get.to(() => Wrapper());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 80, 30, 100),
      child: Center(
        child: Material(
          child: _userController.user.Role == "Kupac" ? ListView(
            children: [
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.topLeft, 
                        child: Text(
                          "E-bazeni",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                          ),
                        )
                      ),
                    )
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    )
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ListTile(
                  leading: Icon(FontAwesomeIcons.user),
                  title: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.topLeft, 
                    child: Text(
                      "${_userController.user.Ime} ${_userController.user.Prezime}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      ),
                    ),
                  ),
                  subtitle: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.topLeft, 
                    child: Text(
                      _userController.user.Email,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15
                      ),
                    ),
                  ),
                ),
              ),

              Divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 6, 4, 6),
                child: ListTile(
                  onTap: () {
                    Get.offAll(() => Wrapper());
                  },
                  leading: Icon(FontAwesomeIcons.home, size: 30,),
                  title: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.topLeft, 
                    child: Text("Početna", style: listItemStyle,)
                  )
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(4, 6, 4, 6),
                child: ListTile(
                  onTap: () {
                    Get.to(() => MyProfile());
                  },
                  leading: Icon(FontAwesomeIcons.userCircle,  size: 30,),
                  title: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.topLeft, 
                    child: Text("Moj profil", style: listItemStyle,)
                  )
                ),
              ),

              _ulaznicaController.ulaznica.value.brojUlaznice == null ?
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 6, 4, 6),
                child: ListTile(
                  onTap: (){
                    Get.to(() => MojiZahtjevi());
                  },
                  leading: Icon(FontAwesomeIcons.ticketAlt, size: 30,),
                  title: Text("Moj zahtjev", style: listItemStyle,),
                ),
              ): Container(),

              Padding(
                padding: const EdgeInsets.fromLTRB(4, 6, 4, 6),
                child: ListTile(
                  onTap: () async{
                    await logout(context);
                  },
                  leading: Icon(FontAwesomeIcons.signOutAlt, size: 30,),
                  title: Text("Odjava", style: listItemStyle,),
                ),
              ),
              
            ],
          ): _userController.user.Role == "Admin" || _userController.user.Role == "Zaposlenik" ? ListView(
            children: [
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text("E-bazeni"),
                    )
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    )
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ListTile(
                  leading: Icon(FontAwesomeIcons.user),
                  title: Text(
                    "${_userController.user.Ime} ${_userController.user.Prezime}",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  subtitle: Text(
                    _userController.user.Email,
                    style: TextStyle(
                      fontSize: 10
                    ),
                  ),
                ),
              ),

              Divider(),

              Padding(
                padding: const EdgeInsets.fromLTRB(4, 6, 4, 6),
                child: ListTile(
                  onTap: () {
                    Get.offAll(() => Wrapper());
                  },
                  leading: Icon(FontAwesomeIcons.home,  size: 30,),
                  title: Text("Početna", style: listItemStyle,)
                ),
              ),
              _ulaznicaController.ulaznica.value.brojUlaznice == null ?
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 6, 4, 6),
                child: ListTile(
                  onTap: () {
                    Get.to(() => MojaUlaznicaZaposlenik());
                  },
                  leading: Icon(FontAwesomeIcons.ticketAlt, size: 30,),
                  title: Text("Moja ulaznica", style: listItemStyle,)
                ),
              ): Container(),

              Padding(
                padding: const EdgeInsets.fromLTRB(4, 6, 4, 6),
                child: ListTile(
                  onTap: () {
                    Get.to(() => KreirajUlaznicu());
                  },
                  leading: Icon(Icons.qr_code_2_outlined, size: 30,),
                  title: Text("Kreiraj ulaznicu iz zahtjeva", style: listItemStyle,)
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(4, 6, 4, 6),
                child: ListTile(
                  onTap: () {
                    Get.to(() => PonistiPosjet());
                  },
                  leading: Icon(Icons.cancel_outlined, size: 30,),
                  title: Text("Poništi posjet", style: listItemStyle,),
                ),
              ),


              Padding(
                padding: const EdgeInsets.fromLTRB(4, 6, 4, 6),
                child: ListTile(
                  onTap: ()async{
                    await logout(context);
                  },
                  leading: Icon(FontAwesomeIcons.signOutAlt, size: 30,),
                  title: Text("Odjava", style: listItemStyle,),
                ),
              ),
              
            ],
          ): ListView(),
        ),
      ),
    );
  }
}