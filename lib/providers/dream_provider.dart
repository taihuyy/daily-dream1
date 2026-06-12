import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';
import '../models/dream.dart';
import '../data/mock_data.dart';

class DreamProvider extends ChangeNotifier {
  final Box _box = Hive.box('dreams');
  List<Dream> _dreams = [];

  List<Dream> get dreams => _dreams;
  List<Dream> get publishedDreams => _dreams.where((d) => d.isPublished).toList();
  Dream? get latestDream => _dreams.isNotEmpty ? _dreams.first : null;

  int get totalDreams => _dreams.length;
  int get totalShares => _dreams.where((d) => d.isPublished).length;

  void loadFromHive() {
    final raw = _box.get('dreams');
    if (raw != null) {
      _dreams = (raw as List).map((e) => Dream.fromMap(Map<String, dynamic>.from(e))).toList();
    } else {
      _dreams = MockData.dreams;
      _saveToHive();
    }
    notifyListeners();
  }

  void _saveToHive() {
    _box.put('dreams', _dreams.map((d) => d.toMap()).toList());
  }

  void addDream(Dream dream) {
    _dreams.insert(0, dream);
    _saveToHive();
    notifyListeners();
  }

  void updateDream(Dream dream) {
    final idx = _dreams.indexWhere((d) => d.id == dream.id);
    if (idx >= 0) {
      _dreams[idx] = dream;
      _saveToHive();
      notifyListeners();
    }
  }

  void publishDream(Dream dream, {String? feeling, bool anonymous = true}) {
    dream.isPublished = true;
    dream.isAnonymous = anonymous;
    dream.feeling = feeling;
    _saveToHive();
    notifyListeners();
  }

  Dream createNewDream({String? rawText}) {
    final dream = Dream(rawText: rawText ?? '');
    addDream(dream);
    return dream;
  }
}
