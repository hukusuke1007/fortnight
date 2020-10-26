import 'package:fortnight/models/repositories/local_database.dart';
import 'package:fortnight/models/repositories/local_database_repository.dart';
import 'package:fortnight/models/repositories/package_info_repository.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

PackageInfoRepository _packageInfoRepository;
LocalDatabaseRepository _localDatabaseRepository;

PackageInfoRepository get packageInfoRepository => _packageInfoRepository;
LocalDatabaseRepository get localDatabaseRepository => _localDatabaseRepository;

Future<void> initContainer() async {
  _packageInfoRepository = await getPackageInfoRepository();
  _localDatabaseRepository = await getLocalDatabaseRepository();
}

Future<PackageInfoRepository> getPackageInfoRepository() async {
  final packageInfo = await PackageInfo.fromPlatform();
  return PackageInfoRepositoryImpl(packageInfo);
}

Future<LocalDatabaseRepository> getLocalDatabaseRepository() async {
  final prefs = await SharedPreferences.getInstance();
  return LocalDatabaseRepositoryImpl(LocalDatabase(prefs));
}
