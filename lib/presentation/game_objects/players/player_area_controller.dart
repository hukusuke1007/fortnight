import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flutter/material.dart';
import 'package:fortnight/presentation/parts/attack_button.dart';
import 'package:fortnight/presentation/parts/kentiku_button.dart';

import 'collision_area.dart';

/// PlayerAreaコントローラ
class PlayerAreaController extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent, Resizable {
  PlayerAreaController() {}

  Size screenSize;

  CollisionArea get collisionArea =>
      components.firstWhere((value) => value is CollisionArea,
          orElse: () => null) as CollisionArea;
  KentikuButton get kentikuButton =>
      components.firstWhere((value) => value is KentikuButton,
          orElse: () => null) as KentikuButton;

  AttackButton get attackButton =>
      components.firstWhere((value) => value is AttackButton,
          orElse: () => null) as AttackButton;

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

  void reset() {
    components.clear();
  }

  void _createCollisionArea() {
    final component = CollisionArea(
      x: 0,
      y: screenSize.height - 160,
      width: screenSize.width,
      height: 20,
    );
    components.add(component);
  }

  void _createKentikuButton() {
    final component = KentikuButton(
      x: 16,
      y: collisionArea.y + 48,
      width: 160,
      height: 80,
    );
    components.add(component);
  }

  void _createAttackButton() {
    const buttonWidth = 160.0;
    final component = AttackButton(
      x: screenSize.width - buttonWidth - 16,
      y: collisionArea.y + 48,
      width: buttonWidth,
      height: 80,
    );
    components.add(component);
  }
}
