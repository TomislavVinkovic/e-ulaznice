class UserRegistrationDTO{
  final String UserName;
  final String Email;
  final String Ime;
  final String Prezime;
  final String OIB;
  final String Prebivaliste;
  final String Boraviste;
  final String Password;
  final String DatumRodenja;

  UserRegistrationDTO({required this.UserName, 
    required this.Password, 
    required this.Email, 
    required this.Ime, 
    required this.Prezime, 
    required this.OIB, 
    required this.Prebivaliste, 
    required this.Boraviste,
    required this.DatumRodenja
  });

  Map<String, dynamic> toJsonMap() =>{
    'username': UserName,
    'email': Email,
    'ime': Ime,
    'prezime': Prezime,
    'oib': OIB,
    'prebivaliste': Prebivaliste,
    'boraviste': Boraviste,
    'password': Password,
    'datumRodenja': DatumRodenja
  };
}