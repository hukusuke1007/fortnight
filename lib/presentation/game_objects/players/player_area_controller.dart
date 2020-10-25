import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flutter/material.dart';
import 'package:fortnight/presentation/parts/buttons/attack_button.dart';
import 'package:fortnight/presentation/parts/buttons/kentiku_button.dart';

import 'collision_area.dart';

/// PlayerAreaコントローラ
class PlayerAreaController extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent, Resizable {
  PlayerAreaController() {}

  Size screenSize;

  CollisionArea collisionArea;
  KentikuButton _kentikuButton;
  AttackButton _attackButton;

  @override
  void update(double t) {
    super.update(t);
  }

  @override
  void resize(Size size) {
    screenSize = size;
    if (collisionArea == null) {
      _createCollisionArea();
    }
    if (_kentikuButton == null) {
      _createKentikuButton();
    }
    if (_attackButton == null) {
      _createAttackButton();
    }
    print('resize $size');
  }

  void onReset() {
    components.clear();
  }

  bool isTapKentikuButton(TapDownDetails d) =>
      _kentikuButton.toRect().contains(d.localPosition);

  bool isTapAttackButton(TapDownDetails d) =>
      _attackButton.toRect().contains(d.localPosition);

  void _createCollisionArea() {
    collisionArea = CollisionArea(
      x: 0,
      y: screenSize.height - 110,
      width: screenSize.width,
      height: 6,
    );
    components.add(collisionArea);
  }

  void _createKentikuButton() {
    _kentikuButton = KentikuButton(
      x: 32,
      y: collisionArea.y + 16,
      width: 160,
      height: 72,
    );
    components.add(_kentikuButton);
  }

  void _createAttackButton() {
    const buttonWidth = 160.0;
    _attackButton = AttackButton(
      x: screenSize.width - buttonWidth - 32,
      y: collisionArea.y + 16,
      width: buttonWidth,
      height: 72,
    );
    components.add(_attackButton);
  }
}
