import 'package:intl/intl.dart';

class User{
  final Id;
  final UserName;
  final Email;
  final OIB;
  final Ime;
  final Prezime;
  final DatumRodenja;
  final Prebivaliste;
  final Boraviste;
  final Role;

  User({
    this.Id, 
    this.UserName, 
    this.Email, 
    this.OIB, 
    this.Ime, 
    this.Prezime, 
    this.DatumRodenja, 
    this.Prebivaliste, 
    this.Boraviste,
    this.Role
  }); 

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      Id: json['user']['id'],
      UserName: json['user']['userName'], 
      Email: json['user']['email'], 
      OIB: json['user']['oib'], 
      Ime: json['user']['ime'], 
      Prezime: json['user']['prezime'], 
      DatumRodenja: DateFormat('dd.MM.yyyy.').format(DateTime.parse(json['user']['datumRodenja'])) , 
      Prebivaliste: json['user']['prebivaliste'],
      Boraviste: json['user']['boraviste'],
      Role: json['role']
    );
  }

}