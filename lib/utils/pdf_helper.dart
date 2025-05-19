import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/certificat.dart';

Future<void> generateCertificatPdf(Certificat certif, String nomHabitant, String dateNaissance, String adresse) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            // En-tête avec le titre de la République
            pw.Text('REPUBLIQUE DU SÉNÉGAL',
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.Text('Un Peuple - Un But - Une Foi',
                style: pw.TextStyle(fontSize: 12)),
            pw.SizedBox(height: 20),
            
            // Information de la commune
            pw.Text('COMMUNE D\'ARRONDISSEMENT DE PIKINE',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.Text('(Guinaw Rail Nord)',
                style: pw.TextStyle(fontSize: 12)),
            pw.Text('DAKAR',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 30),
            
            // Titre du certificat
            pw.Text('CERTIFICAT DE DOMICILE',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 40),
            
            // Corps du certificat
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 50),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Je soussigné, Mr Waldiodio Ndiaye, Maire de GUINAW RAIL NORD,',
                      style: pw.TextStyle(fontSize: 12)),
                  pw.SizedBox(height: 15),
                  pw.Text('Certifie que M./Mme/Mlle',
                      style: pw.TextStyle(fontSize: 12)),
                  pw.SizedBox(height: 5),
                  pw.Text(nomHabitant,
                      style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 5),
                  pw.Text('Né(e) le $dateNaissance',
                      style: pw.TextStyle(fontSize: 12)),
                  pw.SizedBox(height: 5),
                  pw.Text('Est domicilié(e) à la villa N°$adresse',
                      style: pw.TextStyle(fontSize: 12)),
                  pw.SizedBox(height: 30),
                  pw.Text('En foi de quoi, ce présent certificat lui est délivré pour servir et valoir ce que de droit.',
                      style: pw.TextStyle(fontSize: 12)),
                ],
              ),
            ),
            
            // Pied de page
            pw.Spacer(),
            pw.Column(
              children: [
                pw.Text('PIKINE', style: pw.TextStyle(fontSize: 12)),
                pw.Text('GUINAW RAIL NORD', style: pw.TextStyle(fontSize: 12)),
                pw.Text('Le Développement', style: pw.TextStyle(fontSize: 12)),
                pw.SizedBox(height: 20),
                pw.Text('Dakar, le ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    style: pw.TextStyle(fontSize: 12)),
              ],
            ),
          ],
        );
      },
    ),
  );

  final output = await getTemporaryDirectory();
  final file = File("${output.path}/certificat_domicile_${nomHabitant.replaceAll(' ', '_')}.pdf");
  await file.writeAsBytes(await pdf.save());
  await OpenFile.open(file.path);
}