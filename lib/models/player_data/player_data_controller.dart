import 'package:fortnight/container.dart';
import 'package:fortnight/models/player_data/player_data.dart';

class PlayerDataController {
  Future<PlayerData> load() async {
    final gameClearTime = await localDatabaseRepository.loadGameClearTime();
    final superMode = await localDatabaseRepository.loadSuperMode();
    return PlayerData(gameClearTime: gameClearTime, superMode: superMode);
  }

  Future<void> save({
    int gameClearTime,
    bool superMode,
  }) async {
    if (gameClearTime != null) {
      await localDatabaseRepository.saveGameClearTime(gameClearTime);
    }
    if (superMode != null) {
      await localDatabaseRepository.saveSuperMode(value: superMode);
    }
  }
}
