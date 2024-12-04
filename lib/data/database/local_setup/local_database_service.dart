import 'package:code_challenge/data/database/handler/stored_deivce_handler.dart';
import 'package:code_challenge/data/database/dto/stored_device_data.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class LocalDatabaseService {
  late final Isar database;

  late final StoredDeviceHandler storedDeviceHandler;

  Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();

    final List<CollectionSchema> schemas = [
      StoredDeviceSchema,
    ];

    database = await Isar.open(
      schemas,
      directory: dir.path,
      name: 'myInstance',
    );

    storedDeviceHandler = StoredDeviceHandler(database);
  }

  Future<void> close() async {
    await database.close();
  }
}
