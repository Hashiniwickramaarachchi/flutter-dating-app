import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class termandcondition extends StatefulWidget {
  termandcondition({super.key});

  @override
  State<termandcondition> createState() => _termandconditionState();
}

class _termandconditionState extends State<termandcondition> {
  late String pdfPath; // Field to store the file path
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    loadPdfFromAssets(); // Load the PDF when the widget is initialized
  }

  // Method to load PDF from assets and save it locally
  Future<void> loadPdfFromAssets() async {
    try {
      // Load the PDF from assets
      final ByteData bytes = await rootBundle.load('assetss/Terms of use.pdf');
      final Uint8List pdfBytes = bytes.buffer.asUint8List();

      // Get the document directory where we can save the PDF file
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/Terms_of_use.pdf');

      // Write the bytes to the file
      await file.writeAsBytes(pdfBytes);

      // Set the file path and update the loading state
      setState(() {
        pdfPath = file.path;
        isLoading = false; // PDF is ready, stop loading
      });
    } catch (e) {
      print('Error loading PDF: $e');
      setState(() {
        isLoading = false; // Stop loading if there's an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height / 400,
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show a loading indicator while the PDF is being loaded
          : PDFView(
              filePath: pdfPath, // Display the PDF using the local file path
            ),
    );
  }
}
