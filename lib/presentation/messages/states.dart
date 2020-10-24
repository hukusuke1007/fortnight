import 'package:flame/components/component.dart';
import 'package:flutter/foundation.dart';

enum ObjectStateType { create, remove }

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

class ComponentMessageState {
  ComponentMessageState(
    this.component, {
    @required this.objectStateType,
  });
  final PositionComponent component;
  final ObjectStateType objectStateType;
}
