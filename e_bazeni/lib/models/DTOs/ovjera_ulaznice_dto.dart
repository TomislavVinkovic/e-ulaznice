import 'package:intl/intl.dart';

class OvjeraUlazniceDTO{
  final ImeKorisnika;
  final PrezimeKorisnika;
  final EndDate;
  final AlreadyVisited;
  final IsValid;

  OvjeraUlazniceDTO({this.ImeKorisnika, this.PrezimeKorisnika, this.EndDate, this.AlreadyVisited, this.IsValid, });

  factory OvjeraUlazniceDTO.fromJson(Map<String, dynamic> json){
    var date = "";
    if(json['endDate'] != null){
      date = DateFormat('dd.MM.yyyy.').format(DateTime.parse(json['endDate']));
    }
    return OvjeraUlazniceDTO(
      ImeKorisnika: json['imeKorisnika'] ?? null, 
      PrezimeKorisnika: json['prezimeKorisnika'] ?? null, 
      EndDate: date == "" ? null : date, 
      AlreadyVisited: json['alreadyVisited'],
      IsValid: json['isValid']
    );
  }

}