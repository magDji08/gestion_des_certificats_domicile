import 'package:get/get.dart';
import '../models/certificat.dart';
import '../service/database_service.dart';

import 'dart:math';

class CertificatController extends GetxController {
  final RxList<Certificat> certificats = <Certificat>[].obs;
  late final DatabaseService databaseService;

  @override
  void onInit() {
    databaseService = Get.find();
    super.onInit();
  }

  @override
  void onReady() {
    loadCertificats();
    super.onReady();
  }

  Future<void> loadCertificats() async {
    final db = await databaseService.database;
    final maps = await db.query('certificats', orderBy: 'date_emission DESC');
    certificats.assignAll(maps.map((map) => Certificat.fromMap(map)));
  }

  Future<int> createCertificat(Certificat certif) async {
    final db = await databaseService.database;
    final id = await db.insert('certificats', certif.toMap());
    await loadCertificats();
    return id;
  }

  Future<void> updateCertificat(Certificat certif) async {
    final db = await databaseService.database;
    await db.update(
      'certificats',
      certif.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [certif.id],
    );
    await loadCertificats();
  }

  Future<void> deleteCertificat(int id) async {
    final db = await databaseService.database;
    await db.delete('certificats', where: 'id = ?', whereArgs: [id]);
    await loadCertificats();
  }

  String generateCertificatNumber() {
    final now = DateTime.now();
    final random = Random();
    return '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${random.nextInt(9999).toString().padLeft(4, '0')}';
  }
}
