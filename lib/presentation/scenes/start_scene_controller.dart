import 'dart:ui';

import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/gestures.dart';
import 'package:fortnight/gen/index.dart';
import 'package:fortnight/models/app_info/app_info_controller.dart';
import 'package:fortnight/models/player_data/player_data_controller.dart';
import 'package:fortnight/presentation/messages/index.dart';
import 'package:fortnight/presentation/mixins/tap_mixin.dart';
import 'package:fortnight/presentation/parts/buttons/index.dart';
import 'package:fortnight/presentation/parts/index.dart';

class StartSceneController extends BaseGame
    with
        MultiTouchTapDetector,
        HasTapableComponents,
        MessageControllerMixin,
        TapMixin {
  StartSceneController() {
    _configure();
  }

  TitleLabel _titleLabel;
  StartButton _startButton;
  InAppPurchaseButton _inAppPurchaseButton;

  final AppInfoController _appInfoController = AppInfoController();
  final PlayerDataController _playerDataController = PlayerDataController();

  // ignore: avoid_setters_without_getters
  set _screenSize(Size value) {
    if (_titleLabel == null) {
      _titleLabel = TitleLabel(screenSize: value);
      add(_titleLabel);
    }
    if (_startButton == null && _inAppPurchaseButton == null) {
      const buttonWidth = 240.0;
      const buttonHeight = 72.0;
      final rect = Rect.fromLTWH(0, 0, value.width, value.height);
      _startButton = StartButton(
        x: rect.center.dx - buttonWidth / 2,
        y: value.height - buttonHeight * 2 - 48,
        width: buttonWidth,
        height: buttonHeight,
      );
      add(_startButton);

      _inAppPurchaseButton = InAppPurchaseButton(
        x: rect.center.dx - buttonWidth / 2,
        y: value.height - buttonHeight - 24,
        width: buttonWidth,
        height: buttonHeight,
      );
      add(_inAppPurchaseButton);
    }
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

    if (_startButton.isTapButton(d)) {
      _isTapped = false;
      Flame.audio.play(Assets.audio.filename(Assets.audio.sfx.decision9));
      Future.delayed(const Duration(milliseconds: 1000), () {
        messageController.onScene.add(SceneState(type: SceneType.stage1));
      });
    }
    if (_inAppPurchaseButton.isTapButton(d)) {
      Flame.audio.play(Assets.audio.filename(Assets.audio.sfx.decision9));
    }
  }

  @override
  void resize(Size size) {
    super.resize(size);
    _screenSize = size;
  }

  Future<void> _configure() async {
    final version = _appInfoController.load().version;
    print('version $version');

    final playerData = await _playerDataController.load();
    print(
        'gameClearTime: ${playerData.gameClearTime}, superMode: ${playerData.superMode}');
    _fetch();
  }

  void _fetch() {}
}