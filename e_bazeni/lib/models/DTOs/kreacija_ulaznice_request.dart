import 'package:intl/intl.dart';

class KreacijaUlazniceRequest{
  final String zahtjevId;
  final String endDate;

  KreacijaUlazniceRequest({required this.zahtjevId, required this.endDate});

  Map<String, dynamic> toJsonMap() => {
    "zahtjevId": zahtjevId,
    "endDate": endDate
  };

}