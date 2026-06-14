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
    await Hive.openBox('dreams');
    await Hive.openBox('user');
    await Hive.openBox('settings');
  } catch (e) {
    debugPrint('Hive init error: $e');
  }

  final settings = SettingsService();
  await settings.init();

  final tongyiService = TongyiWanxiangService(
    apiKey: settings.dashscopeApiKey,
    host: settings.dashscopeHost,
    model: settings.imageModel,
  );

  runApp(DailyDreamApp(settings: settings, tongyiService: tongyiService));
}

class DailyDreamApp extends StatelessWidget {
  final SettingsService settings;
  final TongyiWanxiangService tongyiService;
  const DailyDreamApp({super.key, required this.settings, required this.tongyiService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DreamProvider()..loadFromHive()),
        ChangeNotifierProvider(create: (_) => ChatProvider(settings)),
        ChangeNotifierProvider(create: (_) => ImageVideoProvider(tongyiService)),
        Provider.value(value: settings),
      ],
      child: MaterialApp(
        title: '每日梦境',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        builder: (context, child) {
          ErrorWidget.builder = (error) => Material(
            color: const Color(0xFF0A1020),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  '加载中...\n$error',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
          return child ?? const SizedBox.shrink();
        },
        home: const WelcomePage(),
      ),
    );
  }
}
