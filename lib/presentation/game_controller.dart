import 'package:flutter/material.dart';
import 'package:fortnight/presentation/scenes/stage1_scene_controller.dart';

import 'messages/message_controller.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key key}) : super(key: key);

  @override
  GameController createState() => GameController();
}

class GameController extends State<GamePage> {
  GameController() : _messageController = MessageController() {
    stage1sceneController = Stage1SceneController();
    _fetch();
  }

  final MessageController _messageController;
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

  void _fetch() {
    _messageController.fetchGameClear
        .where((event) => event == true)
        .listen((event) {
      // TODO
    });

    _messageController.fetchGameOver
        .where((event) => event == true)
        .listen((event) {
      // TODO
    });
  }
}
