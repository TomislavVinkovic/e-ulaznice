import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'authlogin.dart';
import 'authregister.dart';

class AuthHome extends StatefulWidget {
  const AuthHome({ Key? key }) : super(key: key);

  @override
  _AuthHomeState createState() => _AuthHomeState();
}

class _AuthHomeState extends State<AuthHome> with SingleTickerProviderStateMixin{

  late AnimationController _animationController;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000)
    );
    _animation = CurvedAnimation(
      parent: _animationController, 
      curve: Curves.easeOut
    );
    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(      
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 100,),
                FadeTransition(
                  opacity: _animation,
                  child: Hero(
                    tag: 'logo',
                    child: Image.asset("assets/images/templogo.png", width: 150, height: 150,)
                  ),
                ),
                SizedBox(height: 40,),
                FadeTransition(
                  opacity: _animation,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent[700]?? Colors.redAccent),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )
                      ),
                    ),
                    onPressed: () => Get.to(() => Login()),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("Prijava", style: TextStyle(fontSize: 18.0, color: Colors.white),),
                    )
                  ),
                ),

                SizedBox(height: 20.0,),

                FadeTransition(
                  opacity: _animation,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent[700]?? Colors.redAccent),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )
                      ),
                    ),
                    onPressed: () => Get.to(() => Register()),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("Registracija", style: TextStyle(fontSize: 18.0, color: Colors.white),),
                    )
                  ),
                ),
                
              ],
            ),
          ),
        ),
      )
    );
  }
}