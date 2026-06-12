import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'providers/dream_provider.dart';
import 'providers/chat_provider.dart';
import 'services/settings_service.dart';
import 'pages/welcome_page.dart';
import 'pages/home_page.dart';
import 'pages/record_choice_page.dart';
import 'pages/record_text_page.dart';
import 'pages/record_voice_page.dart';
import 'pages/ai_chat_page.dart';
import 'pages/result_page.dart';
import 'pages/image_page.dart';
import 'pages/publish_page.dart';
import 'pages/square_page.dart';
import 'pages/dream_detail_page.dart';
import 'pages/profile_page.dart';
import 'pages/settings_page.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('dreams');
  await Hive.openBox('user');

  final settings = SettingsService();
  await settings.init();

  runApp(DailyDreamApp(settings: settings));
}

class DailyDreamApp extends StatelessWidget {
  final SettingsService settings;
  const DailyDreamApp({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DreamProvider()..loadFromHive()),
        ChangeNotifierProvider(create: (_) => ChatProvider(settings)),
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
          '/image': (_) => const ImagePage(),
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
