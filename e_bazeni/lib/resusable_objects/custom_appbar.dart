import 'package:e_bazeni/resusable_objects/popup_menu.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  @override
  Size get preferredSize => const Size.fromHeight(60);

  final String title;
  final BuildContext cont;
  final bool backButtonEnabled;
  CustomAppBar({required this.title, required this.cont, required this.backButtonEnabled});

  @override
  Widget build(BuildContext context) {
    
    return AppBar(
      leading: !backButtonEnabled? Container(): IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white,),
        onPressed: () => Navigator.pop(cont),
      ),
      actions: [
        IconButton(
          onPressed: (){
            showDialog(
              context: cont, 
              builder: (BuildContext context){
                return PopupMenu();
              }
            );
          }, 
          icon: Icon(Icons.menu)
        )
      ],
      title: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.topLeft, 
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20
          ),
        ),
        
      ),
      backgroundColor: Colors.redAccent[700],
    );
  }
}