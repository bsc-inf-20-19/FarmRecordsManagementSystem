import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class PDFGenerator {
  static Future<void> generateAndSharePdf(
      BuildContext context, String title, List<Map<String, dynamic>> data) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          children: [
            pw.Text(title, style: const pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 20),
            ...data.map((item) => pw.Text(item.toString())).toList(),
          ],
        ),
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/$title.pdf");
    await file.writeAsBytes(await pdf.save());

    Share.shareFiles([file.path], text: 'Here is the $title data.');
  }

  static Future<void> generateAndShareFieldPdf(BuildContext context, List<Map<String, dynamic>> fields) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          children: [
            pw.Text('Fields', style: const pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 20),
            ...fields.map((field) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Field Name: ${field['fieldName']}', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.Text('Field Type: ${field['fieldType'] ?? 'N/A'}'),
                pw.Text('Light Profile: ${field['lightProfile'] ?? 'N/A'}'),
                pw.Text('Field Status: ${field['fieldStatus'] ?? 'N/A'}'),
                pw.Text('Field Size: ${field['fieldSize']?.toString() ?? 'N/A'}'),
                pw.Text('Notes: ${field['notes'] ?? 'N/A'}'),
                pw.Divider(),
              ],
            )).toList(),
          ],
        ),
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/Fields.pdf");
    await file.writeAsBytes(await pdf.save());

    Share.shareFiles([file.path], text: 'Here are the Fields data.');
  }

  static Future<void> generateAndShareTasksPdf(BuildContext context, List<Map<String, dynamic>> tasks) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          children: [
            pw.Text('Tasks', style: const pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 20),
            ...tasks.map((task) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Task Name: ${task['taskName']}', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.Text('Status: ${task['status'] ?? 'N/A'}'),
                pw.Text('Date: ${task['taskDate'] ?? 'N/A'}'),
                pw.Text('Field: ${task['field'] ?? 'N/A'}'),
                pw.Text('Notes: ${task['notes'] ?? 'N/A'}'),
                pw.Divider(),
              ],
            )).toList(),
          ],
        ),
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/Tasks.pdf");
    await file.writeAsBytes(await pdf.save());

    Share.shareFiles([file.path], text: 'Here are the Tasks data.');
  }

  static Future<void> generateAndShareTreatmentPdf(BuildContext context, List<Map<String, dynamic>> treatments) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          children: [
            pw.Text('Treatments', style: const pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 20),
            ...treatments.map((treatment) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Treatment Type: ${treatment['treatment_type']}', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.Text('Treatment Date: ${treatment['date']}'),
                pw.Text('Status: ${treatment['status']}'),
                pw.Text('Field: ${treatment['field']}'),
                pw.Text('Product Used: ${treatment['product_used']}'),
                pw.Text('Quantity: ${treatment['quantity']}'),
                pw.Divider(),
              ],
            )).toList(),
          ],
        ),
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/Treatments.pdf");
    await file.writeAsBytes(await pdf.save());

    Share.shareFiles([file.path], text: 'Here are the Treatments data.');
  }
}
