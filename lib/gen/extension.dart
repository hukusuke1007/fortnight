import 'assets.gen.dart';

extension AssetGenImageExtension on AssetGenImage {
  String get filename => assetName.replaceAll('assets/images/', '');
}

extension $AssetsAudioGenExtension on $AssetsAudioGen {
  String filename(String value) => value.replaceAll('assets/audio/', '');
}
