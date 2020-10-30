import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:fortnight/gen/index.dart';
import 'package:fortnight/presentation/config.dart';
import 'package:fortnight/presentation/messages/index.dart';
import 'package:fortnight/presentation/parts/index.dart';

/// プレイヤー
class Player extends PositionComponent
    with
        HasGameRef,
        Tapable,
        ComposedComponent,
        Resizable,
        MessageControllerMixin {
  Player({
    @required double x,
    @required double y,
    @required double width,
    @required double height,
  }) : _lifePointLabel = LifePointLabel(
          rect: Rect.fromLTWH(x, y, width, height),
        ) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    _playerSprite = Sprite(Assets.images.hgWhite.filename);
    final color = messageController.fetchSuperMode.value
        ? Colors.yellowAccent
        : Colors.white;
    _playerSprite.paint = Paint()
      ..colorFilter = ColorFilter.mode(color, BlendMode.srcIn);
    _rect = Rect.fromLTWH(x, y, width, height);

    hp = PlayerConfig.hp;
    add(_lifePointLabel);
  }
  final LifePointLabel _lifePointLabel;

  int _hp = 1;
  int get hp => _hp;
  set hp(int value) {
    _hp = value;
    _lifePointLabel.value = _hp;
  }

  Sprite _playerSprite;
  Rect _rect;

  @override
  void update(double t) {
    super.update(t);
  }

  @override
  void render(Canvas c) {
    super.render(c);
    _playerSprite.renderRect(c, _rect);
  }

  @override
  bool destroy() {
    return hp <= 0;
  }
}
