import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: EdgeInsets.all(20), 
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.arrow_back_ios_new_rounded),
                Text("ConvertEasy", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
              ]
              ,
              ),
        
              SizedBox(height: 24,),
        
              Container(
                width: 800,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9)),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(children: [
                    Text("File Conversion", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                    Text("Convert your files quickly and securely in three simple steps", style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey.shade600),),
                    
                    SizedBox(height: 30,),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      Column(  
                        children: [
                        Icon(Icons.upload, size: 40,),
                        SizedBox(height: 12,),
                        Text('Upload', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                        Text("Select or drag your files", style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey.shade600))
                  
                      ],),
                      Column(
                        children: [
                        Icon(Icons.settings, size: 40,),
                        SizedBox(height: 12,),
                        Text('Convert', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                        Text("Choose format and convert", style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey.shade600))
                      ],),
                      Column(
                        children: [
                         Icon(Icons.download, size: 40,),
                         SizedBox(height: 12,),
                        Text('Download', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                        Text("Get your converted file", style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey.shade600))
                      ],),
                    ],),
        
                    SizedBox(height: 40,),
                  
                    // file upload section
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(border: Border.all()),
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          children: [
                            Icon(Icons.file_upload_outlined),
                            Text("Drag and Drop your files here"),
                            Text("or click to browse. Supports PDF, DOC"),
                            SizedBox(height: 30,),
                            ElevatedButton(onPressed: () {}, 
                            style: ElevatedButton.styleFrom(fixedSize: Size(170, 30)),
                            child: Row(
                              spacing: 8,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.folder),
                                Text("Browse files"),
                              ],
                            ))
                          ],
                        ),
                      ),
                    ),
                  
                    // convert button
                    ElevatedButton(onPressed: () {}, 
                    child: Text("Convert"),
                    ),
                  ],),
                ),
              ),
              ],
              ),
      ),
            ),
    );
  }
}