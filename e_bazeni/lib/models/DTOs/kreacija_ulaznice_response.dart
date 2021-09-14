class KreacijaUlazniceResponse{
  final bool isSuccessful;
  final List<String> errors;

  KreacijaUlazniceResponse({required this.isSuccessful, required this.errors});

  factory KreacijaUlazniceResponse.fromJson(Map<String, dynamic> json){
    return KreacijaUlazniceResponse(
      isSuccessful: json['isSuccessful'],
      errors: json['errors'] ?? []
    );
  }

}