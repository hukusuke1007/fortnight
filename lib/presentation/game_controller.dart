import 'package:flutter/material.dart';
import 'package:fortnight/presentation/scenes/stage1_scene_controller.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key key}) : super(key: key);

  @override
  GameController createState() => GameController();
}

class GameController extends State<GamePage> {
  GameController() {
    stage1sceneController = Stage1SceneController();
  }

  Stage1SceneController stage1sceneController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fortnight'),
        centerTitle: true,
      ),
      body: Container(
        child: stage1sceneController.widget,
      ),
    );
  }
}
