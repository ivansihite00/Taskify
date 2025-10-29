import 'package:flutter/material.dart';
import 'package:tubes_pm/screen/task.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(212, 255, 221, 1),
        body: Center(
          child:SafeArea(child:  Column(
            children: [

              SizedBox(
                height: 120,
              ),
              Image.asset("assets/logo.png"),
              SizedBox(
                height: 47,
              ),
              Image.asset("assets/welcome.png"),

              SizedBox(
                height: 20,
              ),

              Container(
                width: 273,
                height: 60,
                child: Text("Plan your day and stay productive",style: TextStyle(fontSize: 20),maxLines: 2,)),

              SizedBox(
                height: 57,
              ),

             SizedBox(
              width: 322,
              height: 67,
              child:  ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(94, 205, 118, 1),
                  foregroundColor: Colors.white
                ),
                onPressed: (){

                  Navigator.push(context, MaterialPageRoute<void>(builder: (context) => const TaskPage(),));

              }, child: Text("Get Started",style: TextStyle(
                fontSize: 24
              ),)),
             ),
            ],
          ),)
        ),
    );
  }
}