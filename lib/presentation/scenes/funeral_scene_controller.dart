import 'dart:ui';

import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/sprite.dart';
import 'package:fortnight/gen/index.dart';
import 'package:fortnight/presentation/messages/index.dart';
import 'package:fortnight/presentation/mixins/tap_mixin.dart';

class FuneralSceneController extends BaseGame
    with
        MultiTouchTapDetector,
        HasTapableComponents,
        MessageControllerMixin,
        TapMixin {
  FuneralSceneController() {
    _bgSprite = Sprite(Assets.images.gameOver.filename);
  }

  Sprite _bgSprite;
  Rect _bgRect;

  // ignore: avoid_setters_without_getters
  set _screenSize(Size value) {
    _configure(value);
  }

  @override
  void resize(Size size) {
    super.resize(size);
    _screenSize = size;
  }

  @override
  void render(Canvas c) {
    super.render(c);
    if (_bgRect != null) {
      _bgSprite.renderRect(c, _bgRect);
    }
  }

  Future<void> _configure(Size value) async {
    await Flame.audio.play(Assets.audio.filename(Assets.audio.sfx.gameOver));
    _bgRect = Rect.fromLTWH(
      0,
      0,
      value.width,
      value.height,
    );
    await Future<void>.delayed(const Duration(milliseconds: 5000));
    messageController.onScene.add(SceneState(type: SceneType.start));
  }
}
