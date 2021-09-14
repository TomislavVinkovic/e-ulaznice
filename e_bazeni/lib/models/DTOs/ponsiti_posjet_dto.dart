class PonistiPosjetDTO{
  final bool IsRevoked;
  final Errors;

  PonistiPosjetDTO({required this.IsRevoked, this.Errors});

  factory PonistiPosjetDTO.fromJson(Map<String, dynamic> json){
    return PonistiPosjetDTO(
      IsRevoked: json['isRevoked'],
      Errors: json['errors'] ?? null
    );
  }
}