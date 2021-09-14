class EditUserInformationResponse{
  final String? Error;
  final bool Success;

  EditUserInformationResponse({this.Error, required this.Success});

  factory EditUserInformationResponse.fromJson(Map<String, dynamic> json){
    String? error = null;
    try{
      error = json['errors'][0];
    }
    catch(exception){}
    return EditUserInformationResponse(
      Error: error,
      Success: json['success']
    );
  }

}