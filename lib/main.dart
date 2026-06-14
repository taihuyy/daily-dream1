import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'providers/dream_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/image_video_provider.dart';
import 'services/settings_service.dart';
import 'services/tongyi_wanxiang_service.dart';
import 'pages/welcome_page.dart';
import 'pages/home_page.dart';
import 'pages/record_choice_page.dart';
import 'pages/record_text_page.dart';
import 'pages/record_voice_page.dart';
import 'pages/ai_chat_page.dart';
import 'pages/result_page.dart';
import 'pages/image_video_page.dart';
import 'pages/publish_page.dart';
import 'pages/square_page.dart';
import 'pages/dream_detail_page.dart';
import 'pages/profile_page.dart';
import 'pages/settings_page.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  try {
    await Hive.initFlutter();
    final dreamsBox = await Hive.openBox('dreams');
    await Hive.openBox('user');
    final settingsBox = await Hive.openBox('settings');

    final settings = SettingsService(settingsBox);
    await settings.init();

    final tongyiService = TongyiWanxiangService(
      apiKey: settings.dashscopeApiKey,
      host: settings.dashscopeHost,
      model: settings.imageModel,
    );

    final dreamProvider = DreamProvider(dreamsBox);
    dreamProvider.loadFromHive();

    runApp(DailyDreamApp(
      settings: settings,
      tongyiService: tongyiService,
      dreamProvider: dreamProvider,
    ));
  } catch (e, stack) {
    debugPrint('=== APP STARTUP ERROR ===');
    debugPrint('$e');
    debugPrint('$stack');
    runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF0A1020),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                const SizedBox(height: 16),
                const Text('启动出错', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Text('$e', style: const TextStyle(color: Colors.white70, fontSize: 13), textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class DailyDreamApp extends StatelessWidget {
  final SettingsService settings;
  final TongyiWanxiangService tongyiService;
  final DreamProvider dreamProvider;
  const DailyDreamApp({
    super.key,
    required this.settings,
    required this.tongyiService,
    required this.dreamProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: dreamProvider),
        ChangeNotifierProvider(create: (_) => ChatProvider(settings)),
        ChangeNotifierProvider(create: (_) => ImageVideoProvider(tongyiService)),
        Provider.value(value: settings),
      ],
      child: MaterialApp(
        title: '每日梦境',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        initialRoute: '/welcome',
        routes: {
          '/welcome': (_) => const WelcomePage(),
          '/home': (_) => const HomePage(),
          '/record-choice': (_) => const RecordChoicePage(),
          '/record-text': (_) => const RecordTextPage(),
          '/record-voice': (_) => const RecordVoicePage(),
          '/ai-chat': (_) => const AiChatPage(),
          '/result': (_) => const ResultPage(),
          '/image-video': (_) => const ImageVideoPage(),
          '/publish': (_) => const PublishPage(),
          '/square': (_) => const SquarePage(),
          '/dream-detail': (_) => const DreamDetailPage(),
          '/profile': (_) => const ProfilePage(),
          '/settings': (_) => SettingsPage(settings: settings),
        },
      ),
    );
  }
}
