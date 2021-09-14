import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {

  final String title;
  final String message;
  final BuildContext cont;

  CustomAlertDialog.showDialog({required this.title, required this.message, required this.cont}){
    showDialog(
      context: cont, 
      builder: (BuildContext context){
        return this;
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          child: Text("U redu")
        ),
      ],
    );
  }
}