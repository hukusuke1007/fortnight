import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:fortnight/gen/index.dart';
import 'package:fortnight/presentation/messages/index.dart';

/// 建築のコントローラ
class KentikuController extends PositionComponent
    with
        HasGameRef,
        Tapable,
        ComposedComponent,
        Resizable,
        MessageControllerMixin {
  KentikuController({
    @required this.playerRect,
  }) {
    _fetch();
  }
  final Rect playerRect;

  Size screenSize;
  Kentiku _kentiku;
  int get _count => components.whereType<Kentiku>().length;
  int get _maxCount => 1;

  @override
  void update(double t) {
    super.update(t);
  }

  @override
  void resize(Size size) {
    screenSize = size;
    print('resize $size');
  }

  void onCreate({double offsetX = 0}) {
    print('onCreate');
    if (_count < _maxCount) {
      final initialX = playerRect.right + 96 + offsetX;
      final initialY = playerRect.top - 32;
      const width = 24.0;
      final height = playerRect.height + 64;
      _kentiku = Kentiku(
        x: initialX,
        y: initialY,
        width: width,
        height: height,
      );
      components.add(_kentiku);
      messageController.onKentiku.add(ComponentMessageState(
        _kentiku,
        objectStateType: ObjectStateType.create,
      ));

      Flame.audio.play(Assets.audio.filename(Assets.audio.sfx.kentikuCreate));
    }
  }

  void onReset() {
    components.clear();
  }

  void _fetch() {
    messageController.fetchKentiku
        .where((event) => event.objectStateType == ObjectStateType.remove)
        .listen((event) {
      components.clear();
    });

    messageController.fetchCollision
        .where((event) => event.to is Kentiku)
        .listen((event) {
      final superMode = messageController.fetchSuperMode.value;
      Flame.audio.play(Assets.audio.filename(Assets.audio.sfx.kentikuBreak));
      if (!superMode) {
        messageController.onKentiku.add(ComponentMessageState(
          _kentiku,
          objectStateType: ObjectStateType.remove,
        ));
      }
    });
  }
}

/// 建築
class Kentiku extends PositionComponent
    with
        HasGameRef,
        Tapable,
        ComposedComponent,
        Resizable,
        MessageControllerMixin {
  Kentiku({
    @required double x,
    @required double y,
    @required double width,
    @required double height,
  }) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    rect = Rect.fromLTWH(x, y, width, height);
    final superMode = messageController.fetchSuperMode.value;
    _paint = Paint()
      ..color = superMode ? Colors.yellowAccent : Colors.brown[400];
  }

  Rect rect;
  Paint _paint;
  bool _toRemove = false;

  @override
  void update(double t) {
    super.update(t);
  }

  @override
  void render(Canvas c) {
    super.render(c);
    c.drawRect(rect, _paint);
  }

  @override
  bool destroy() {
    return _toRemove;
  }

  void onRemove() => _toRemove = true;
}
