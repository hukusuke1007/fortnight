import 'dart:ui';

import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/sprite.dart';
import 'package:fortnight/gen/index.dart';
import 'package:fortnight/presentation/messages/index.dart';
import 'package:fortnight/presentation/mixins/tap_mixin.dart';
import 'package:fortnight/presentation/parts/label/message_label.dart';

class EndingSceneController extends BaseGame
    with
        MultiTouchTapDetector,
        HasTapableComponents,
        MessageControllerMixin,
        TapMixin {
  EndingSceneController() {
    _sprite = Sprite(Assets.images.takeshiBlack.filename);
  }

  Sprite _sprite;
  Rect _bgRect;
  MessageLabel _messageLabel;

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
      _sprite.renderRect(c, _bgRect);
    }
  }

  Future<void> _configure(Size value) async {
    _bgRect = const Rect.fromLTWH(32, 52, 96, 96);
    _messageLabel = MessageLabel(
      screenSize: value,
      text: 'すごい！',
      left: 96,
      top: 150,
    );
    add(_messageLabel);
    Future.delayed(const Duration(milliseconds: 8000), () {
      _messageLabel.text = 'こんなげーむにまじになっちゃってどうするの';
    });
    await Future<void>.delayed(const Duration(minutes: 5));
    messageController.onScene.add(SceneState(type: SceneType.start));
  }
}
