import 'dart:ui';

import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
// ignore: implementation_imports
import 'package:flutter/src/gestures/tap.dart';
import 'package:fortnight/presentation/game_objects/enemies/index.dart';
import 'package:fortnight/presentation/game_objects/players/index.dart';

class Stage1SceneController extends BaseGame
    with MultiTouchTapDetector, HasTapableComponents {
  Stage1SceneController() {
    this..add(Enemy1Controller())..add(PlayerAreaController());
  }

  @override
  void onTapDown(int pointerId, TapDownDetails details) {}

  @override
  void update(double t) {
    super.update(t);
    // print('update $t');
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // print('render $canvas');
  }
}
