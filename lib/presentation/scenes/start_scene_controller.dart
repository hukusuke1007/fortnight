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
import 'package:fortnight/presentation/parts/buttons/complaint_button.dart';
import 'package:fortnight/presentation/parts/buttons/index.dart';
import 'package:fortnight/presentation/parts/index.dart';
import 'package:fortnight/presentation/parts/label/high_score_label.dart';
import 'package:fortnight/presentation/parts/label/message_label.dart';
import 'package:fortnight/presentation/parts/label/version_label.dart';

class StartSceneController extends BaseGame
    with
        MultiTouchTapDetector,
        HasTapableComponents,
        MessageControllerMixin,
        TapMixin {
  StartSceneController();

  TitleLabel _titleLabel;
  StartButton _startButton;
  InAppPurchaseButton _inAppPurchaseButton;
  ComplaintButton _complaintButton;
  VersionLabel _versionLabel;
  HighScoreLabel _highScoreLabel;

  final AppInfoController _appInfoController = AppInfoController();
  final PlayerDataController _playerDataController = PlayerDataController();

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

    if (_startButton.isTapButton(d)) {
      _isTapped = false;
      Flame.audio.play(Assets.audio.filename(Assets.audio.sfx.decision9));
      Future.delayed(const Duration(milliseconds: 1000), () {
        messageController.onScene.add(SceneState(type: SceneType.stage1));
      });
    }
    if (_inAppPurchaseButton.isTapButton(d)) {
      _isTapped = false;
      Flame.audio.play(Assets.audio.filename(Assets.audio.sfx.decision9));
      Future.delayed(const Duration(milliseconds: 1000), () {
        messageController.onScene
            .add(SceneState(type: SceneType.inAppPurchase));
      });
    }

    if (_complaintButton.isTapButton(d)) {
      _isTapped = false;
      Flame.audio.play(Assets.audio.filename(Assets.audio.sfx.decision9));
      _funeral();
    }
  }

  @override
  void resize(Size size) {
    super.resize(size);
    _screenSize = size;
  }

  Future<void> _configure(Size value) async {
    if (_titleLabel == null) {
      _titleLabel = TitleLabel(screenSize: value);
      add(_titleLabel);
    }
    if (_startButton == null &&
        _inAppPurchaseButton == null &&
        _complaintButton == null) {
      const buttonWidth = 300.0;
      const buttonHeight = 64.0;
      final rect = Rect.fromLTWH(0, 0, value.width, value.height);
      _startButton = StartButton(
        x: rect.center.dx - buttonWidth / 2,
        y: value.height - buttonHeight * 2 - 16 * 7,
        width: buttonWidth,
        height: buttonHeight,
      );
      add(_startButton);

      _inAppPurchaseButton = InAppPurchaseButton(
        x: rect.center.dx - buttonWidth / 2,
        y: value.height - buttonHeight - 16 * 6,
        width: buttonWidth,
        height: buttonHeight,
      );
      add(_inAppPurchaseButton);

      _complaintButton = ComplaintButton(
        x: rect.center.dx - buttonWidth / 2,
        y: value.height - buttonHeight - 16,
        width: buttonWidth,
        height: buttonHeight,
      );
      add(_complaintButton);
    }
    if (_versionLabel == null) {
      final version = _appInfoController.load().version;
      print('version $version');
      final rect = Rect.fromLTWH(0, 0, value.width, value.height);
      _versionLabel = VersionLabel(rect: rect, version: version);
      add(_versionLabel);
    }
    if (_highScoreLabel == null) {
      final playerData = await _playerDataController.load();
      final rect = Rect.fromLTWH(0, 0, value.width, value.height);
      final highScore = playerData.gameClearTime != null ? 'TODO' : null;
      _highScoreLabel = HighScoreLabel(rect: rect, value: highScore);
      add(_highScoreLabel);
    }
  }

  Future<void> _funeral() async {
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    components.removeWhere((element) => element is TitleLabel);
    add(MessageLabel(screenSize: size, text: 'は？？うるせえ！しね！', fontSize: 50));
    await Future<void>.delayed(const Duration(milliseconds: 2000));
    for (var i = 0; i < 4; i++) {
      await Flame.audio
          .play(Assets.audio.filename(Assets.audio.sfx.collision1));
      await Future<void>.delayed(Duration(milliseconds: i != 3 ? 500 : 100));
    }
    await Flame.audio.play(Assets.audio.filename(Assets.audio.sfx.death1));
    await Future<void>.delayed(const Duration(milliseconds: 2000));
    messageController.onScene.add(SceneState(type: SceneType.funeral));
  }
}
