import 'package:flutter/material.dart';
import 'package:tubes_pm/screen/task_detail.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  bool isResearchChecked = false;
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 20,
        backgroundColor: Color.fromRGBO(69, 153, 87, 1),
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute<void>(builder: (context) => const DetailPage(),));
        },
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SafeArea(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // biar ke kiri
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.settings, size: 32),
                    SizedBox(width: 210),
                    Icon(Icons.search, size: 32),
                    SizedBox(width: 36),
                    Icon(Icons.notifications, size: 32),
                  ],
                ),
              ),
              SizedBox(height: 10,),

              Padding(
   padding: EdgeInsets.zero, 
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Today,",
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
      SizedBox(height: 4),
      Text(
        "19 March 2025",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
),

              SizedBox(height: 50,),

              Row(
                children: [
                  Text("Today"),
                  Container(width: 20,height: 21,decoration: BoxDecoration(borderRadius: BorderRadius.circular(7),color: Color.fromRGBO(225, 255, 235, 1)),child: Center(child: Text("1"),),),
                  SizedBox(width: 267,),
                  Icon(Icons.arrow_upward),
                ],
              ),
              SizedBox(height: 10,),

              
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(95, 251, 129, 0.5),
                  borderRadius: BorderRadius.circular(30)
                ),

                width: 342,
                height: 110,
                child: Padding(padding: EdgeInsetsGeometry.all(12),child: Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: isResearchChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isResearchChecked = value!;
                            });
                          },
                        ),
                        Text("Sharing UI Design - Basic", style: TextStyle(color: Color.fromRGBO(69, 153, 87, 1),fontWeight: FontWeight.bold),),
                      ],
                    ),

                    Row(
                      children: [
                        SizedBox(width: 48,),
                        Container(
                          width: 128
                          ,
                          height: 23,
                          decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(30)),child: Center(child: Text("27 March 2025",style: TextStyle(color: Color.fromRGBO(69, 153, 87, 1),fontWeight: FontWeight.bold),),)),
                        SizedBox(width: 14),
                        Text("08:00 AM",style: TextStyle(color: Color.fromRGBO(69, 153, 87, 1),fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ],
                ),)
              ),

              SizedBox(height: 30,),

              Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Workspace"),
                        Container(width: 20,height: 21,decoration: BoxDecoration(borderRadius: BorderRadius.circular(7),color: Color.fromRGBO(225, 255, 235, 1)),child: Center(child: Text("3"),),),
                        SizedBox(width: 235,),
                        Icon(Icons.arrow_upward),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: isResearchChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isResearchChecked = value!;
                            });
                          },
                        ),
                        Text("Research Product for UI8"),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 48,),
                        Container(width: 75, height: 23,child: Center(child: Text("Today"),),decoration: BoxDecoration(color: Color.fromRGBO(225, 255, 235, 1)),),
                        SizedBox(width: 20),

                        Text("05:00 AM"),
                      ],
                    ),
                  ],
                ),
              ),

               SizedBox(height: 30,),
              Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: isResearchChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isResearchChecked = value!;
                            });
                          },
                        ),
                        Text("Create  Action Plan for Product"),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 48,),
                        Container(width: 75, height: 23,child: Center(child: Text("Today"),),decoration: BoxDecoration(color: Color.fromRGBO(225, 255, 235, 1)),),
                        Text("13:05 AM"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 48,),
                        Checkbox(
                          value: isResearchChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isResearchChecked = value!;
                            });
                          },
                        ),
                        Text("Research"),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 48,),
                        Checkbox(
                          value: isResearchChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isResearchChecked = value!;
                            });
                          },
                        ),
                        Text("Deffine"),
                      ],
                    ),
                  ],
                ),
              ),

               SizedBox(height: 30,),
              Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: isResearchChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isResearchChecked = value!;
                            });
                          },
                        ),
                        Text("Design Multi -Preview"),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 48,),
                        Container(width: 75, height: 23,child: Center(child: Text("Today"),),decoration: BoxDecoration(color: Color.fromRGBO(225, 255, 235, 1)),),
                        SizedBox(width: 20),
                        Text("05:00 AM"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            
          ),
        ),
      ),);
  }
}
