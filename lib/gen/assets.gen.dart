/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  AssetGenImage get gameOver =>
      const AssetGenImage('assets/images/game_over.jpg');
  AssetGenImage get takeshi => const AssetGenImage('assets/images/takeshi.jpg');
}

class $AssetsSoundsGen {
  const $AssetsSoundsGen();

  String get bgm1 => 'assets/sounds/bgm1.mp3';
  String get bgm2 => 'assets/sounds/bgm2.mp3';
  String get bomb1 => 'assets/sounds/bomb1.mp3';
  String get bomb2 => 'assets/sounds/bomb2.mp3';
  String get decision9 => 'assets/sounds/decision9.mp3';
  String get gameOver => 'assets/sounds/game_over.mp3';
  String get kentikuBreak => 'assets/sounds/kentiku_break.mp3';
  String get kentikuCreate => 'assets/sounds/kentiku_create.mp3';
  String get ko1 => 'assets/sounds/ko1.mp3';
  String get lineGirl1Arigatougozaimasu1 =>
      'assets/sounds/line_girl1_arigatougozaimasu1.mp3';
  String get punch0 => 'assets/sounds/punch0.mp3';
  String get punch1 => 'assets/sounds/punch1.mp3';
  String get punch2 => 'assets/sounds/punch2.mp3';
  String get punchSwing1 => 'assets/sounds/punch_swing1.mp3';
  String get shoot2 => 'assets/sounds/shoot2.mp3';
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsSoundsGen sounds = $AssetsSoundsGen();
}

class AssetGenImage extends AssetImage {
  const AssetGenImage(String assetName)
      : _assetName = assetName,
        super(assetName);
  final String _assetName;

  Image image({
    ImageFrameBuilder frameBuilder,
    ImageLoadingBuilder loadingBuilder,
    ImageErrorWidgetBuilder errorBuilder,
    String semanticLabel,
    bool excludeFromSemantics = false,
    double width,
    double height,
    Color color,
    BlendMode colorBlendMode,
    BoxFit fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return Image(
      image: this,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
    );
  }

  String get path => _assetName;
}
