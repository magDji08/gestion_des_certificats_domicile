import 'package:certificat_management/service/database_service.dart';
import 'package:get/get.dart';
import '../models/quartier.dart';

class QuartierController extends GetxController {
  final RxList<Quartier> quartiers = <Quartier>[].obs;
  // final DatabaseService databaseService = Get.find(); //instantiation de ma base de donnee

  late final DatabaseService databaseService;

  @override
  void onInit() {
    databaseService = Get.find();
    super.onInit();
  }

  @override
  void onReady() {
    loadQuartiers();
    super.onReady();
  }

  Future<void> loadQuartiers() async {
    final db = await databaseService.database;
    final maps = await db.query('quartiers', orderBy: 'nom');
    quartiers.assignAll(maps.map((map) => Quartier.fromMap(map)));
  }

  Future<int> createQuartier(String nom) async {
    final db = await databaseService.database;
    final quartier = Quartier(nom: nom);
    final id = await db.insert('quartiers', quartier.toMap());
    await loadQuartiers();
    return id;
  }

  Future<void> updateQuartier(Quartier quartier) async {
    final db = await databaseService.database;
    await db.update(
      'quartiers',
      quartier.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [quartier.id],
    );
    await loadQuartiers();
  }

  Future<void> deleteQuartier(int id) async {
    final db = await databaseService.database;
    await db.delete(
      'quartiers',
      where: 'id = ?',
      whereArgs: [id],
    );
    await loadQuartiers();
  }
}