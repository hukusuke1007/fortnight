import 'package:fortnight/container.dart';
import 'package:fortnight/models/app_info/app_info.dart';

class AppInfoController {
  AppInfo load() => AppInfo(version: packageInfoRepository.version);
}
