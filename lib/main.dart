// main.dart
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:media_kit/media_kit.dart';
import 'screens/video_player_screen.dart';
import 'providers/video_state_provider.dart';

void main() {
  MediaKit.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => VideoStateProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Video Player App',
      theme: FluentThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.blue,
      ),
      home: const VideoPlayerScreen(),
    );
  }
}