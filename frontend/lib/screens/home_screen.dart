import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PlatformFile? _selectedFile;

  Future<void> pickFile() async{
      final result = await FilePicker.platform.pickFiles();
      if (result != null){
        setState(() {
          _selectedFile = result.files.first;
        });
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: Padding(padding: EdgeInsets.all(20), 
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.sync_alt , color: Color(0xFF3B82F6), // Blue accent
                            size: 32,),
                            SizedBox(width: 8),
                  Text("ConvertEasy", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF1E293B)),)
                ]
                ,
                ),
          
                SizedBox(height: 24,),
          
                Container(
                  width: 800,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(children: [
                      Text("File Conversion",  style: TextStyle(
                            fontSize: 28, // Larger font
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),),
                      Text("Convert your files quickly and securely in three simple steps", 
                      style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF64748B), // Better gray color
                          ),
                          textAlign: TextAlign.center,
                          ),
                      
                      SizedBox(height: 30,),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        Column(  
                          children: [
                          Icon(Icons.cloud_upload, size: 40,color: Color(0xFF3B82F6),),
                          SizedBox(height: 12,),
                          Text('Upload', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                          Text("Select or drag your files", style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey.shade600))
                    
                        ],),
                        Column(
                          children: [
                          Icon(Icons.settings, size: 40, color: Color(0xFF3B82F6),),
                          SizedBox(height: 12,),
                          Text('Convert', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                          Text("Choose format and convert", style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey.shade600))
                        ],),
                        Column(
                          children: [
                           Icon(Icons.download, size: 40, color: Color(0xFF3B82F6),),
                           SizedBox(height: 12,),
                          Text('Download', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                          Text("Get your converted file", style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey.shade600))
                        ],),
                      ],),
          
                      SizedBox(height: 40,),
                    
                      // file upload section
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xFFF8FAFC),borderRadius: BorderRadius.circular(15),
                          border: Border.all( color: Color(0xFFCBD5E1), // Softer border color
                              style: BorderStyle.solid,
                              width: 2,)),
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            children: [
                              Icon(Icons.cloud_upload,
                                  size: 64,
                                  color: Color(0xFF94A3B8), ),
                              SizedBox(height: 16,),
                              Text("Drag and Drop your files here", style: TextStyle(fontSize: 18,  fontWeight: FontWeight.w500,
                                    color: Color(0xFF1E293B),),),
                              Text("or click to browse. Supports PDF, DOC", style: TextStyle(fontWeight: FontWeight.w400, color: Color(0xFF64748B),)),
                              SizedBox(height: 30,),
                              ElevatedButton(
                                onPressed: pickFile,
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(170, 30), 
                                backgroundColor: Color(0xFF3B82F6), 
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    ),
                              child: Row(
                                spacing: 8,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.folder_open, size: 20),
                                  Text("Browse files"),
                                ],
                              ))
                            ],
                          ),
                        ),
                      ),

                      // Show selected file preview
if (_selectedFile != null) ...[
  SizedBox(height: 16),
  Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Color(0xFFF1F5F9),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(
          Icons.insert_drive_file,
          color: Color(0xFF3B82F6),
          size: 32,
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _selectedFile!.name,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E293B),
                ),
              ),
              SizedBox(height: 4),
              Text(
                "${(_selectedFile!.size / 1024 / 1024).toStringAsFixed(1)} MB",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _selectedFile = null;
            });
          },
          icon: Icon(
            Icons.close,
            color: Color(0xFFEF4444),
          ),
        ),
      ],
    ),
  ),
],
        
                      SizedBox(height: 30,),
                    
                      // convert button
                      ElevatedButton(
                        onPressed: () {}, 
                      style : ElevatedButton.styleFrom( 
                       backgroundColor: Color(0xFF3B82F6),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),),
                      child: Text("Convert"),
                      ),
                    ],),
                  ),
                ),
                ],
                ),
        ),
      ),
            ),
    );
  }
}