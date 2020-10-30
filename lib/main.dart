import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:fortnight/container.dart';
import 'package:fortnight/gen/index.dart';
import 'package:fortnight/presentation/game_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.util.setLandscapeRightOnly();

  /// DI
  await initContainer();

  await Flame.images.loadAll(<String>[
    Assets.images.takeshiBlack.filename,
    Assets.images.hgWhite.filename,
    Assets.images.gameOver.filename,
  ]);

  /// 音取り入れ
  // Flame.audio.disableLog();
  await Flame.audio.loadAll(<String>[
    Assets.audio.filename(Assets.audio.bgm.bgm1),
    Assets.audio.filename(Assets.audio.bgm.bgm2),
    Assets.audio.filename(Assets.audio.sfx.gameOver),
    Assets.audio.filename(Assets.audio.sfx.gameClear),
    Assets.audio.filename(Assets.audio.sfx.collision1),
    Assets.audio.filename(Assets.audio.sfx.bomb1),
    Assets.audio.filename(Assets.audio.sfx.bomb2),
    Assets.audio.filename(Assets.audio.sfx.decision9),
    Assets.audio.filename(Assets.audio.sfx.kentikuBreak),
    Assets.audio.filename(Assets.audio.sfx.kentikuCreate),
    Assets.audio.filename(Assets.audio.sfx.ko1),
    Assets.audio.filename(Assets.audio.sfx.lineGirl1Arigatougozaimasu1),
    Assets.audio.filename(Assets.audio.sfx.punch0),
    Assets.audio.filename(Assets.audio.sfx.punch1),
    Assets.audio.filename(Assets.audio.sfx.punch2),
    Assets.audio.filename(Assets.audio.sfx.punchSwing1),
    Assets.audio.filename(Assets.audio.sfx.shoot2),
  ]);

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fortnight',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const GamePage(),
    );
  }
}
