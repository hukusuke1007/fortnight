import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:fortnight/container.dart';
import 'package:fortnight/presentation/game_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.util.setLandscapeRightOnly();

  /// DI
  await initContainer();

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
