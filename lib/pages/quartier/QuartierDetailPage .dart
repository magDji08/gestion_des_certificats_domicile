import 'package:certificat_management/controllers/maison_controller.dart';
import 'package:certificat_management/models/quartier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class QuartierDetailPage extends StatelessWidget {
  final Quartier quartier;

  const QuartierDetailPage(this.quartier, {super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(quartier.nom),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.info), text: 'Détails'),
              Tab(icon: Icon(Icons.home), text: 'Maisons'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDetailsTab(),
            _buildMaisonsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow(Icons.calendar_today, 'Date création', DateFormat('dd/MM/yyyy').format(quartier.createdAt)),
              const SizedBox(height: 20),
              _detailRow(Icons.numbers, 'Nombre de maisons', '12'), // À remplacer par vos données
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.indigo),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: Colors.grey.shade600)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildMaisonsTab() {
    return Obx(() {
      final maisons = Get.find<MaisonController>().maisons.where((m) => m.quartierId == quartier.id).toList();
      return ListView.builder(
        itemCount: maisons.length,
        itemBuilder: (_, index) => ListTile(
          leading: const Icon(Icons.home),
          title: Text(maisons[index].adresse),
          subtitle: Text('Ajoutée le ${DateFormat('dd/MM/yy').format(maisons[index].createdAt)}'),
        ),
      );
    });
  }
}