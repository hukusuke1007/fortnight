import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flutter/material.dart';
import 'package:fortnight/presentation/parts/buttons/attack_button.dart';
import 'package:fortnight/presentation/parts/buttons/kentiku_button.dart';

import 'player_line.dart';

class PlayerAreaController extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent, Resizable {
  Size _screenSize;
  PlayerLine _playerLine;
  KentikuButton _kentikuButton;
  AttackButton _attackButton;

  @override
  void update(double t) {
    super.update(t);
  }

  @override
  void resize(Size size) {
    _screenSize = size;
    if (_playerLine == null) {
      _createPlayerLine();
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

  bool isTapKentikuButton(TapDownDetails d) => _kentikuButton.isTapButton(d);

  bool isTapAttackButton(TapDownDetails d) => _attackButton.isTapButton(d);

  void _createPlayerLine() {
    _playerLine = PlayerLine(
      x: 0,
      y: _screenSize.height - 110,
      width: _screenSize.width,
      height: 6,
    );
    components.add(_playerLine);
  }

  void _createKentikuButton() {
    _kentikuButton = KentikuButton(
      x: 32,
      y: _playerLine.y + 16,
      width: 160,
      height: 72,
    );
    components.add(_kentikuButton);
  }

  void _createAttackButton() {
    const buttonWidth = 160.0;
    _attackButton = AttackButton(
      x: _screenSize.width - buttonWidth - 32,
      y: _playerLine.y + 16,
      width: buttonWidth,
      height: 72,
    );
    components.add(_attackButton);
  }
}
