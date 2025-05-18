import 'package:certificat_management/service/database_service.dart';
import 'package:get/get.dart';
import '../models/personne.dart';

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

  Future<void> loadPersonnes() async {
    final db = await databaseService.database;
    final maps = await db.query('personnes', orderBy: 'nom');
    personnes.assignAll(maps.map((map) => Personne.fromMap(map)));
  }

  Future<int> createPersonne(Personne personne) async {
    final db = await databaseService.database;
    final id = await db.insert('personnes', personne.toMap());
    await loadPersonnes();
    return id;
  }

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

  Future<void> deletePersonne(int id) async {
    final db = await databaseService.database;
    await db.delete('personnes', where: 'id = ?', whereArgs: [id]);
    await loadPersonnes();
  }

  List<Personne> get proprietaires => personnes.where((p) => p.role == 'proprietaire').toList();
  List<Personne> get habitants => personnes.where((p) => p.role == 'habitant').toList();
}
