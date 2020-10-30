import 'dart:async';
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

import 'kentiku.dart';

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

  StreamSubscription<ComponentMessageState> _kentikuDisposer;
  StreamSubscription<CollisionMessageState> _collisionDisposer;

  @override
  void resize(Size size) {
    screenSize = size;
  }

  Future<void> dispose() async {
    await _kentikuDisposer?.cancel();
    await _collisionDisposer?.cancel();
  }

  void onCreate({double offsetX = 0}) {
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

  void _fetch() {
    _kentikuDisposer ??= messageController.fetchKentiku
        .where((event) => event.objectStateType == ObjectStateType.remove)
        .listen((event) {
      components.clear();
    });

    _collisionDisposer ??= messageController.fetchCollision
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
