import 'dart:ui';

import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/gestures.dart';
import 'package:fortnight/gen/index.dart';
import 'package:fortnight/presentation/messages/index.dart';
import 'package:fortnight/presentation/mixins/tap_mixin.dart';
import 'package:fortnight/presentation/parts/buttons/index.dart';
import 'package:fortnight/presentation/parts/label/in_app_purchase_item_label.dart';

class InAppPurchaseSceneController extends BaseGame
    with
        MultiTouchTapDetector,
        HasTapableComponents,
        MessageControllerMixin,
        TapMixin {
  InAppPurchaseSceneController();

  InAppPurchaseButton _inAppPurchaseButton;

  // ignore: avoid_setters_without_getters
  set _screenSize(Size value) {
    _configure(value);
  }

  bool _isTapped = true;

  @override
  void onTapDown(int pointerId, TapDownDetails d) {
    // TODO(shohei): 1回タップで2回発火してしまうので制御
    if (isChattering) {
      return;
    }

    if (!_isTapped) {
      return;
    }

    if (_inAppPurchaseButton.isTapButton(d)) {
      _isTapped = false;
      Flame.audio.play(
          Assets.audio.filename(Assets.audio.sfx.lineGirl1Arigatougozaimasu1));
      Future<void>.delayed(const Duration(milliseconds: 2500), () {
        messageController.onSuperMode.add(true);
        messageController.onScene.add(SceneState(type: SceneType.start));
      });
    }
  }

  @override
  void resize(Size size) {
    super.resize(size);
    _screenSize = size;
  }

  Future<void> _configure(Size value) async {
    add(InAppPurchaseItemLabel(screenSize: value));
    if (_inAppPurchaseButton == null) {
      const buttonWidth = 300.0;
      const buttonHeight = 64.0;
      final rect = Rect.fromLTWH(0, 0, value.width, value.height);
      _inAppPurchaseButton = InAppPurchaseButton(
        x: rect.center.dx - buttonWidth / 2,
        y: value.height - buttonHeight - 32,
        width: buttonWidth,
        height: buttonHeight,
        text: '課金する',
      );
      add(_inAppPurchaseButton);
    }
  }
}
