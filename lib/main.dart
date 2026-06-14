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

  // Open ALL boxes first, before anything else
  await Hive.initFlutter();
  final dreamsBox = await Hive.openBox('dreams');
  await Hive.openBox('user');
  final settingsBox = await Hive.openBox('settings');

  // Now create services
  final settings = SettingsService(settingsBox);
  await settings.init();

  final tongyiService = TongyiWanxiangService(
    apiKey: settings.dashscopeApiKey,
    host: settings.dashscopeHost,
    model: settings.imageModel,
  );

  // Create providers AFTER boxes are open
  final dreamProvider = DreamProvider(dreamsBox);
  dreamProvider.loadFromHive(); // Load once, NOT in build

  runApp(DailyDreamApp(
    settings: settings,
    tongyiService: tongyiService,
    dreamProvider: dreamProvider,
  ));
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
        home: const WelcomePage(),
      ),
    );
  }
}
