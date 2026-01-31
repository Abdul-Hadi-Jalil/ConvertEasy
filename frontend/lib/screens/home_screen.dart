import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? formatSelected;

  int _currentStep = 1;
  bool _isDownloadReady = false;
  Uint8List? _pdfBytes; // Store PDF after conversion
  PlatformFile? _selectedFile;

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  Future<void> convertFile() async {
    if (_selectedFile == null) return;

    final url = Uri.parse('http://127.0.0.1:8000/word_to_pdf');

    var request = http.MultipartRequest('POST', url);

    Uint8List fileBytes;
    fileBytes = _selectedFile!.bytes!;

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: _selectedFile!.name,
      ),
    );

    final response = await request.send();

    if (response.statusCode == 200) {
      // Store PDF bytes for later download
      _pdfBytes = await response.stream.toBytes();
      setState(() {}); // Update UI to show download button
    }
  }

  // 2. Download only (triggered by download button)
  Future<void> downloadPdf() async {
    if (_pdfBytes == null) return;

    final blob = html.Blob([_pdfBytes!], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..download = _selectedFile!.name
          .replaceAll('.docx', '.pdf')
          .replaceAll('.doc', '.pdf')
      ..click();

    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.sync_alt,
                      color: Color(0xFF3B82F6), // Blue accent
                      size: 32,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "ConvertEasy",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24),

                Container(
                  width: 800,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        Text(
                          "File Conversion",
                          style: TextStyle(
                            fontSize: 28, // Larger font
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          "Convert your files quickly and securely in three simple steps",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF64748B), // Better gray color
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 30),

                        // upload, convert, download
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Icon(
                                  Icons.cloud_upload,
                                  size: 40,
                                  color: Color(0xFF3B82F6),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Upload',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  "Select or drag your files",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Icon(
                                  Icons.settings,
                                  size: 40,
                                  color: Color(0xFF3B82F6),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Convert',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  "Choose format and convert",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Icon(
                                  Icons.download,
                                  size: 40,
                                  color: Color(0xFF3B82F6),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Download',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  "Get your converted file",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 40),

                        if (_currentStep == 3) ...[
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: _isDownloadReady
                                  ? Color(0xFFF0FDF4)
                                  : Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: _isDownloadReady
                                    ? Color(0xFFBBF7D0)
                                    : Color(0xFFCBD5E1),
                                width: 2,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: Column(
                                children: [
                                  // Show loading first
                                  if (!_isDownloadReady) ...[
                                    CircularProgressIndicator(
                                      color: Color(0xFF3B82F6),
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      'Preparing your file...',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      'Please wait a moment',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ] else ...[
                                    // Show success after 3 seconds
                                    Icon(
                                      Icons.check_circle,
                                      size: 58,
                                      color: const Color.fromARGB(
                                        255,
                                        92,
                                        215,
                                        96,
                                      ),
                                    ),

                                    SizedBox(height: 20),

                                    const Text(
                                      'Conversion Complete!',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                    Text(
                                      "Your file has been successfully converted and is ready for download.",
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ]
                        // file upload section
                        else if (_currentStep == 1) ...[
                          InkWell(
                            onTap: pickFile,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Color(
                                    0xFFCBD5E1,
                                  ), // Softer border color
                                  style: BorderStyle.solid,
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(30),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.cloud_upload,
                                      size: 64,
                                      color: Color(0xFF94A3B8),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "Drag and Drop your files here",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                    Text(
                                      "or click to browse. Supports PDF, DOC",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    ElevatedButton(
                                      onPressed: pickFile,
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: Size(170, 30),
                                        backgroundColor: Color(0xFF3B82F6),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        spacing: 8,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.folder_open, size: 20),
                                          Text("Browse files"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]
                        // extention select to which file to be converted
                        else if (_currentStep == 2) ...[
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Color(0xFFCBD5E1), // Softer border color
                                style: BorderStyle.solid,
                                width: 2,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                spacing: 14,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Converted to',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),

                                  // file conversions to choose
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        formatSelected = "pdf";
                                      });
                                    },
                                    child: Container(
                                      width: 95,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        border: BoxBorder.all(
                                          color: formatSelected == 'pdf'
                                              ? Color(0xFF3B82F6)
                                              : Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        color: formatSelected == 'pdf'
                                            ? Color(0xFF3B82F6).withOpacity(0.1)
                                            : Colors.white,
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        spacing: 8,
                                        children: [
                                          Icon(
                                            Icons.file_open_rounded,
                                            color: formatSelected == 'pdf'
                                                ? Color(0xFF3B82F6)
                                                : Colors.grey,
                                          ),
                                          Text(
                                            'PDF',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: formatSelected == 'pdf'
                                                  ? Color(0xFF3B82F6)
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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

                        SizedBox(height: 30),

                        // convert button
                        if (_currentStep == 1) ...[
                          ElevatedButton(
                            onPressed: () {
                              if (_selectedFile != null) {
                                setState(() {
                                  _currentStep = 2;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF3B82F6),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 30,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              "Convert",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ]
                        // back and start conversion button
                        else if (_currentStep == 2) ...[
                          Row(
                            spacing: 12,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _currentStep = 1;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,

                                  padding: EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: 30,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      style: BorderStyle.solid,
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "Back",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),

                              ElevatedButton(
                                onPressed: () {
                                  // send file to backend for conversion
                                  convertFile();

                                  // When moving to step 3
                                  setState(() {
                                    _currentStep = 3;
                                    _isDownloadReady = false;
                                  });

                                  // After 3 seconds, show success
                                  Future.delayed(Duration(seconds: 3), () {
                                    setState(() {
                                      _isDownloadReady = true;
                                    });
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF3B82F6),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: 30,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "Start Conversion",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ]
                        // download and back button
                        else if (_currentStep == 3) ...[
                          Row(
                            spacing: 12,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _currentStep = 2;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,

                                  padding: EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: 30,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      style: BorderStyle.solid,
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "Back",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),

                              ElevatedButton(
                                onPressed: () {
                                  // download the file
                                  downloadPdf();

                                  setState(() {
                                    _currentStep = 3;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF3B82F6),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: 30,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "Download",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
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
