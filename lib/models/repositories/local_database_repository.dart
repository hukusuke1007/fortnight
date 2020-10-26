import 'package:flutter/foundation.dart';
import 'package:fortnight/models/repositories/local_database.dart';

abstract class LocalDatabaseRepository {
  Future<void> saveGameClearTime(int value);
  Future<int> loadGameClearTime();

  Future<void> saveSuperMode({@required bool value});
  Future<bool> loadSuperMode();
}

class LocalDatabaseRepositoryImpl implements LocalDatabaseRepository {
  LocalDatabaseRepositoryImpl(this._localDatabase);
  final LocalDatabase _localDatabase;

  @override
  Future<void> saveGameClearTime(int value) =>
      _localDatabase.save(LocalDatabaseKey.gameClearTime, value);

  @override
  Future<int> loadGameClearTime() =>
      _localDatabase.load(LocalDatabaseKey.gameClearTime);

  @override
  Future<void> saveSuperMode({@required bool value}) =>
      _localDatabase.save(LocalDatabaseKey.superMode, value);

  @override
  Future<bool> loadSuperMode() =>
      _localDatabase.load(LocalDatabaseKey.superMode);
}
