import 'package:package_info/package_info.dart';

abstract class PackageInfoRepository {
  String get version;
}

class PackageInfoRepositoryImpl implements PackageInfoRepository {
  PackageInfoRepositoryImpl(this._packageInfo);
  final PackageInfo _packageInfo;

  @override
  String get version => _packageInfo.version;
}
