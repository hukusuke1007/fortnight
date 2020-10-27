import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:fortnight/presentation/messages/index.dart';
import 'package:fortnight/presentation/scenes/ending_scene_controller.dart';
import 'package:fortnight/presentation/scenes/funeral_scene_controller.dart';
import 'package:fortnight/presentation/scenes/in_app_purchase_scene_controller.dart';
import 'package:fortnight/presentation/scenes/stage1_scene_controller.dart';
import 'package:fortnight/presentation/scenes/start_scene_controller.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key key}) : super(key: key);

  @override
  GameController createState() => GameController();
}

class GameController extends State<GamePage> with MessageControllerMixin {
  GameController() : _baseGame = StartSceneController() {
    _fetch();
  }

  BaseGame _baseGame;
  bool _isVisibleAppBar = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isVisibleAppBar
          ? AppBar(
              title: const Text('Fortnight'),
              centerTitle: true,
            )
          : const PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: SizedBox.shrink(),
            ),
      body: Container(
        child: _baseGame != null
            ? _baseGame.widget
            : const Center(
                child: Text('loading...'),
              ),
      ),
    );
  }

  void _fetch() {
    messageController.fetchScene.listen((event) {
      setState(() {
        switch (event.type) {
          case SceneType.start:
            _isVisibleAppBar = false;
            _baseGame = StartSceneController();
            break;
          case SceneType.inAppPurchase:
            _isVisibleAppBar = false;
            _baseGame = InAppPurchaseSceneController();
            break;
          case SceneType.stage1:
            _isVisibleAppBar = true;
            _baseGame = Stage1SceneController();
            break;
          case SceneType.ending:
            _isVisibleAppBar = false;
            _baseGame = EndingSceneController();
            break;
          case SceneType.funeral:
            _isVisibleAppBar = false;
            _baseGame = FuneralSceneController();
            break;
        }
      });
    });
  }
}
