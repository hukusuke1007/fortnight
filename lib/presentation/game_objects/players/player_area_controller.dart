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
  KentikuButton kentikuButton;
  AttackButton attackButton;

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
    if (kentikuButton == null) {
      _createKentikuButton();
    }
    if (attackButton == null) {
      _createAttackButton();
    }
    print('resize $size');
  }

  void onReset() {
    components.clear();
  }

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
    kentikuButton = KentikuButton(
      x: 32,
      y: collisionArea.y + 16,
      width: 160,
      height: 72,
    );
    components.add(kentikuButton);
  }

  void _createAttackButton() {
    const buttonWidth = 160.0;
    attackButton = AttackButton(
      x: screenSize.width - buttonWidth - 32,
      y: collisionArea.y + 16,
      width: buttonWidth,
      height: 72,
    );
    components.add(attackButton);
  }
}
