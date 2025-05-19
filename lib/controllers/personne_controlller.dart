import 'package:get/get.dart';
import '../models/personne.dart';
import '../service/database_service.dart';

class PersonneController extends GetxController {
  final RxList<Personne> personnes = <Personne>[].obs;
  late final DatabaseService databaseService;

  @override
  void onInit() {
    databaseService = Get.find<DatabaseService>();
    super.onInit();
  }

  @override
  void onReady() {
    loadPersonnes();
    super.onReady();
  }

  /// 🔁 Charge toutes les personnes triées par nom
  Future<void> loadPersonnes() async {
    final db = await databaseService.database;
    final maps = await db.query('personnes', orderBy: 'nom');
    personnes.assignAll(maps.map((map) => Personne.fromMap(map)));
  }

  /// ➕ Insère une nouvelle personne dans la base
  Future<int> createPersonne(Personne personne) async {
    final db = await databaseService.database;
    final id = await db.insert('personnes', personne.toMap());
    await loadPersonnes();
    return id;
  }

  /// ✏️ Met à jour les données d'une personne
  Future<void> updatePersonne(Personne personne) async {
    final db = await databaseService.database;
    await db.update(
      'personnes',
      personne.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [personne.id],
    );
    await loadPersonnes();
  }

  /// ❌ Supprime une personne par ID
  Future<void> deletePersonne(int id) async {
    final db = await databaseService.database;
    await db.delete('personnes', where: 'id = ?', whereArgs: [id]);
    await loadPersonnes();
  }

  /// 📂 Retourne les propriétaires
  List<Personne> get proprietaires => personnes.where((p) => p.role == 'proprietaire').toList();

  /// 📂 Retourne les habitants
  List<Personne> get habitants => personnes.where((p) => p.role == 'habitant').toList();
}
