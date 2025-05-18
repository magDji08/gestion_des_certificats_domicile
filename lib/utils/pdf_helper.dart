import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/certificat.dart';

Future<void> generateCertificatPdf(Certificat certif, String nomHabitant) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) => pw.Center(
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text('CERTIFICAT DE DOMICILE', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text('Numéro : ${certif.numero}'),
            pw.Text('Délivré à : $nomHabitant'),
            pw.Text('Date d\'émission : ${certif.dateEmission.toLocal().toString().split(" ")[0]}'),
          ],
        ),
      ),
    ),
  );

  final output = await getTemporaryDirectory();
  final file = File("${output.path}/certificat_${certif.numero}.pdf");
  await file.writeAsBytes(await pdf.save());
  await OpenFile.open(file.path);
}
