/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

import 'package:flutter/widgets.dart';

class $AssetsAudioGen {
  const $AssetsAudioGen();

  $AssetsAudioBgmGen get bgm => const $AssetsAudioBgmGen();
  $AssetsAudioSfxGen get sfx => const $AssetsAudioSfxGen();
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  AssetGenImage get gameOver =>
      const AssetGenImage('assets/images/game_over.jpg');
  AssetGenImage get hgWhite =>
      const AssetGenImage('assets/images/hg_white.png');
  AssetGenImage get icon => const AssetGenImage('assets/images/icon.jpg');
  AssetGenImage get takeshiBlack =>
      const AssetGenImage('assets/images/takeshi_black.jpg');
}

class $AssetsAudioBgmGen {
  const $AssetsAudioBgmGen();

  String get bgm1 => 'assets/audio/bgm/bgm1.mp3';
  String get bgm2 => 'assets/audio/bgm/bgm2.mp3';
}

class $AssetsAudioSfxGen {
  const $AssetsAudioSfxGen();

  String get bomb1 => 'assets/audio/sfx/bomb1.mp3';
  String get bomb2 => 'assets/audio/sfx/bomb2.mp3';
  String get collision1 => 'assets/audio/sfx/collision1.mp3';
  String get death1 => 'assets/audio/sfx/death1.mp3';
  String get decision9 => 'assets/audio/sfx/decision9.mp3';
  String get gameClear => 'assets/audio/sfx/game_clear.mp3';
  String get gameOver => 'assets/audio/sfx/game_over.mp3';
  String get kentikuBreak => 'assets/audio/sfx/kentiku_break.mp3';
  String get kentikuCreate => 'assets/audio/sfx/kentiku_create.mp3';
  String get ko1 => 'assets/audio/sfx/ko1.mp3';
  String get lineGirl1Arigatougozaimasu1 =>
      'assets/audio/sfx/line_girl1_arigatougozaimasu1.mp3';
  String get punch0 => 'assets/audio/sfx/punch0.mp3';
  String get punch1 => 'assets/audio/sfx/punch1.mp3';
  String get punch2 => 'assets/audio/sfx/punch2.mp3';
  String get punchSwing1 => 'assets/audio/sfx/punch_swing1.mp3';
  String get shoot2 => 'assets/audio/sfx/shoot2.mp3';
}

class Assets {
  Assets._();

  static const $AssetsAudioGen audio = $AssetsAudioGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
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
