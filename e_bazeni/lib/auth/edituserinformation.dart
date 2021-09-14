import 'package:e_bazeni/controllers/UserController.dart';
import 'package:e_bazeni/models/DTOs/userpatchDTO.dart';
import 'package:e_bazeni/resusable_objects/alert_dialog.dart';
import 'package:e_bazeni/resusable_objects/custom_appbar.dart';
import 'package:e_bazeni/resusable_objects/loading_screen.dart';
import 'package:e_bazeni/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EditUserInformation extends StatefulWidget {

  @override
  _EditUserInformationState createState() => _EditUserInformationState();
}

class _EditUserInformationState extends State<EditUserInformation> {

  UserController _userController = Get.find();

  TextEditingController txt = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UserToPatchDTO userToPatchDTO = UserToPatchDTO();

  bool loading = false;

  @override
  void initState() {
    txt.text = _userController.user.DatumRodenja;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Promjena podataka", cont: context, backButtonEnabled: true),
      body: !loading ? Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    suffixIcon: Icon(FontAwesomeIcons.userAlt),
                    labelText: "Korisničko ime",
                    border: OutlineInputBorder(),
                  ),
                  initialValue: _userController.user.UserName,
                  validator: (value) {
                    if(value == null || value == "") return "Ovo polje ne može ostati prazno";
                  },
                  onChanged: (value) => setState(() => userToPatchDTO.UserName = value),
                ),
          
                SizedBox(height: 15,),
                TextFormField(
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.mail),
                    labelText: "E-mail adresa",
                    border: OutlineInputBorder(),
                  ),
                  initialValue: _userController.user.Email,
                  validator: (value) {
                    if(value == null || value == "") return "Ovo polje ne može ostati prazno";
                  },
                  onChanged: (value) => setState(() => userToPatchDTO.Email = value),
                ),
                
                SizedBox(height: 15,),
                TextFormField(
                  decoration: InputDecoration(
                    suffixIcon: Icon(FontAwesomeIcons.pen),
                    labelText: "Ime",
                    border: OutlineInputBorder(),
                  ),
                  initialValue: _userController.user.Ime,
                  validator: (value) {
                    if(value == null || value == "") return "Ovo polje ne može ostati prazno";
                  },
                  onChanged: (value) => setState(() => userToPatchDTO.Ime = value),
                ),
          
                
                SizedBox(height: 15,),
                TextFormField(
                  decoration: InputDecoration(
                    suffixIcon: Icon(FontAwesomeIcons.pen),
                    labelText: "Prezime",
                    border: OutlineInputBorder(),
                  ),
                  initialValue: _userController.user.Prezime,
                  validator: (value) {
                    if(value == null || value == "") return "Ovo polje ne može ostati prazno";
                  },
                  onChanged: (value) => setState(() => userToPatchDTO.Prezime = value),
                ),
          
                
                SizedBox(height: 15,),
                TextFormField(
                  decoration: InputDecoration(
                    suffixIcon: Icon(FontAwesomeIcons.idCard),
                    labelText: "OIB",
                    border: OutlineInputBorder(),
                  ),
                  initialValue: _userController.user.OIB,
                  validator: (value) {
                    if(value == null || value == "") return "Ovo polje ne može ostati prazno";
                  },
                  onChanged: (value) => setState(() => userToPatchDTO.OIB = value),
                ),
          
                SizedBox(height: 15,),
                TextFormField(
                  controller: txt,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.calendar_today),
                    labelText: "Datum rođenja",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if(value == null || value == "") return "Ovo polje ne može ostati prazno";
                  },
                  onTap: ()async{
                    var date = await showDatePicker(
                      context: context, 
                      initialDate: DateTime.tryParse(_userController.user.DatumRodenja) ?? DateTime.now(), 
                      firstDate: DateTime(1930, 1, 1), 
                      lastDate: DateTime.now()
                    );
                    if(date != null){
                      setState(() {
                        txt.text = DateFormat("dd.MM.yyyy").format(date);
                        userToPatchDTO.DatumRodenja = DateFormat("MM-dd-yyyy").format(date);
                      });
                    }
                  },
                ),
          
                SizedBox(height: 15,),
                TextFormField(
                  decoration: InputDecoration(
                    suffixIcon: Icon(FontAwesomeIcons.building),
                    labelText: "Prebivalište",
                    border: OutlineInputBorder(),
                  ),
                  initialValue: _userController.user.Prebivaliste,
                  validator: (value) {
                    if(value == null || value == "") return "Ovo polje ne može ostati prazno";
                  },
                  onChanged: (value) => setState(() => userToPatchDTO.Prebivaliste = value),
                ),
          
                SizedBox(height: 15,),
                TextFormField(
                  
                  decoration: InputDecoration(
                    suffixIcon: Icon(FontAwesomeIcons.building),
                    labelText: "Boravište",
                    border: OutlineInputBorder(),
                  ),
                  initialValue: _userController.user.Boraviste,
                  validator: (value) {
                    if(value == null || value == "") return "Ovo polje ne može ostati prazno";
                  },
                  onChanged: (value) => setState(() => userToPatchDTO.Boraviste = value),
                ),
          
                SizedBox(height: 30,),
          
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent[700]!)
                  ),
                  onPressed: () async{
                    if(_formKey.currentState!.validate()){
                      setState(() {
                        loading = true;
                      });
                      var result = await _userController.EditUserInformation(userToPatchDTO);
                      if(result.Success){
                        setState(() {
                        loading = false;
                      });
                        CustomAlertDialog.showDialog(title: "Uspjeh", message: "Korisnički podaci uspješno promijenjeni!", cont: context);
                        //Navigator.pop(context);
                      }
                      else{
                        CustomAlertDialog.showDialog(title: "Greska", message: result.Error.toString(), cont: context);
                      }
                    }
                  }, 
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Uredi podatke",
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  )
                )
              ],
            ),
          ),
        ),
      ): LoadingScreen(size: 70, color: Colors.redAccent[700]!),
    );
  }
}