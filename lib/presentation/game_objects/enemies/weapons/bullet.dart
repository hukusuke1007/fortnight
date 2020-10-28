import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flutter/material.dart';

abstract class Bullet extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent, Resizable {
  Offset targetLocation;
  double speed = 150;
  Rect rect;
  void onRemove();
}
