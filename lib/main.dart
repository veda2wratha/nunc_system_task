import 'package:flutter/material.dart';
import 'package:nunc_system_task/database/database.dart';
import 'package:nunc_system_task/provider/video_downloader.dart';
import 'package:nunc_system_task/provider/videos_provider.dart';
import 'package:nunc_system_task/screens/video_player_page.dart';
import 'package:nunc_system_task/screens/videos_page.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppDatabase>(
          create: (context) => AppDatabase(),
          dispose: (context, db) => db.close(),
        ),
        ChangeNotifierProvider(create: (_) => VideosProvider()),
        ChangeNotifierProvider(create: (_) => VideoDownloaderProvider()),
      ],
      child: MaterialApp(
        routes: {
          '/': (context) => const VideosPage(),
          '/video_player_page': (context) => const VideoPlayerPage(),
        },
        title: 'Video',
        theme: ThemeData(
          //primarySwatch: Colors.pinkAccent,
          primaryColor: Colors.pinkAccent,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.pinkAccent,
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white,
          ),
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
        ),
      ),
    );
  }
}
