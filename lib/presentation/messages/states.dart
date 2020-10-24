import 'package:flame/components/component.dart';
import 'package:flutter/foundation.dart';

class CollisionMessageState {
  CollisionMessageState({
    @required this.from,
    @required this.to,
    @required this.damagePoint,
  });
  final PositionComponent from;
  final PositionComponent to;
  final int damagePoint;
}
