import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  bool isResearchChecked = false;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(padding: EdgeInsetsGeometry.all(12),child: Column(
        children: [
          Container(
            child: Row(
              children: [
                SizedBox(width: 320,),
                Icon(Icons.more_horiz,size:  32,),
                
              ],
            ),
          ),

          Padding(padding: EdgeInsets.zero, 
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [
              Text(
        "Task todo,",
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
      SizedBox(height: 8),
      Text(
        "Create Actionable Plans for Product  - Phase 01",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          height: 1.4,
        ),
      ),
      SizedBox(height: 10),
      
      Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(225, 255, 235, 1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "Today",
                  style: TextStyle(
                    color: Color.fromRGBO(69, 153, 87, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "13:05 PM",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 32),
          Text(
            "Descriptions",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
           const Text(
            "Make sure all Stakeholder available\nfor the next meeting.",
            style: TextStyle(
              fontSize: 17,
              color: Colors.black,
              height: 1.4,
            ),
           ),
           SizedBox(height: 20),
           Text(
                "Todo",
                style: TextStyle(color: Colors.grey[600], fontSize: 15),
              ),
              SizedBox(height: 12),
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
                        Text("Research",style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(width: 25),

                        Checkbox(
                          value: isResearchChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isResearchChecked = value!;
                            });
                          },
                        ),
                        Text("Deffine",style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(width: 25)
                      ],
                    ),
                  ],
                ),
              ), 
              SizedBox(height: 25),
              Text(
                "Assign",
                style: TextStyle(color: Colors.grey[600], fontSize: 15,fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 56,height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD8F5E2),
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(image: AssetImage("assets/avatar1.png"),
                      fit: BoxFit.cover
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFD8F5E2),
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage("assets/avatar2.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 12),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFD8F5E2),
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage("assets/avatar3.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 12),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFD8F5E2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.green,
                size: 28,
              ),
            ),
            
                ],
              ),
              Text(
          "Attachments",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.image_outlined, size: 28, color: Colors.black),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                "Preview Image.jpg",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              "270.3 KB",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.insert_drive_file_outlined,
                size: 28, color: Colors.black),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                "Brief.zip",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              "10.9 MB",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),

          ],
        )
        
        
        


            
            ],
          ),
          )

        ],
      ),),
    );
  }
}