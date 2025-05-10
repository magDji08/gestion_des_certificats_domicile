// controllers/maison_controller.dart
import 'package:certificat_management/service/database_service.dart';
import 'package:get/get.dart';
import '../models/maison.dart';

class MaisonController extends GetxController {
  final RxList<Maison> maisons = <Maison>[].obs;
  late final DatabaseService databaseService;

  @override
  void onInit() {
    databaseService = Get.find<DatabaseService>();
    super.onInit();
  }

  @override
  void onReady() {
    loadMaisons();
    super.onReady();
  }

  Future<void> loadMaisons() async {
    final db = await databaseService.database;
    final maps = await db.query('maisons', orderBy: 'adresse');
    maisons.assignAll(maps.map((map) => Maison.fromMap(map)));
  }

  Future<int> createMaison(String adresse, int quartierId) async {
    final db = await databaseService.database;
    final maison = Maison(adresse: adresse, quartierId: quartierId);
    final id = await db.insert('maisons', maison.toMap());
    await loadMaisons();
    return id;
  }

  Future<void> updateMaison(Maison maison) async {
    final db = await databaseService.database;
    await db.update(
      'maisons',
      maison.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [maison.id],
    );
    await loadMaisons();
  }

  Future<void> deleteMaison(int id) async {
    final db = await databaseService.database;
    await db.delete('maisons', where: 'id = ?', whereArgs: [id]);
    await loadMaisons();
  }
}
