class Zahtjev{
  final id;
  final tipUlazniceId;
  final userId;
  final nazivTipaUlaznice;
  final cijena;

  Zahtjev({this.id,this.tipUlazniceId, this.userId, this.nazivTipaUlaznice, this.cijena});

  
  Map<String, dynamic> toJsonMap() =>{
    'tipUlazniceZahtjevId': tipUlazniceId,
    'applicationUserZahtjevId': userId,
  };
}