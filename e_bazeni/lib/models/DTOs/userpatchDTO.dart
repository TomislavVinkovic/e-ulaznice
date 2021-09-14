class UserToPatchDTO{
  String? UserName;
  String? Email;
  String? Ime;
  String? Prezime;
  String? OIB;
  String? DatumRodenja;
  String? Prebivaliste;
  String? Boraviste;

  UserToPatchDTO({this.UserName, this.Email, this.Ime, this.Prezime, this.OIB, this.DatumRodenja, this.Prebivaliste, this.Boraviste});

  Map<String, dynamic> toJsonMap() => {
    "userName": UserName,
    "email": Email,
    "ime": Ime,
    "prezime": Prezime,
    "oib": OIB,
    "datumRodenja": DatumRodenja,
    "prebivaliste": Prebivaliste,
    "boraviste": Boraviste
  };

}