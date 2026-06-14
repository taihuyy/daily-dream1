import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';
import '../models/dream.dart';
import '../data/mock_data.dart';

class DreamProvider extends ChangeNotifier {
  final Box _box;
  List<Dream> _dreams = [];

  List<Dream> get dreams => _dreams;
  List<Dream> get publishedDreams => _dreams.where((d) => d.isPublished).toList();
  Dream? get latestDream => _dreams.isNotEmpty ? _dreams.first : null;

  int get totalDreams => _dreams.length;
  int get totalShares => _dreams.where((d) => d.isPublished).length;

  DreamProvider(this._box);

  void loadFromHive() {
    try {
      final raw = _box.get('dreams');
      if (raw != null && raw is List) {
        _dreams = raw.map((e) {
          try {
            return Dream.fromMap(Map<String, dynamic>.from(e));
          } catch (_) {
            return null;
          }
        }).whereType<Dream>().toList();
      }
      if (_dreams.isEmpty) {
        _dreams = MockData.dreams;
        _saveToHive();
      }
    } catch (e) {
      debugPrint('loadFromHive error: $e');
      _dreams = MockData.dreams;
    }
    notifyListeners();
  }

  void _saveToHive() {
    try {
      _box.put('dreams', _dreams.map((d) => d.toMap()).toList());
    } catch (e) {
      debugPrint('_saveToHive error: $e');
    }
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

  void publishDream(Dream dream, {String? feeling, String? feelingSource, bool anonymous = true}) {
    dream.isPublished = true;
    dream.isAnonymous = anonymous;
    if (feeling != null && feeling.isNotEmpty) {
      dream.feeling = feeling;
      dream.feelingSource = feelingSource ?? 'user';
    }
    _saveToHive();
    notifyListeners();
  }

  void updateFeeling(Dream dream, String feeling) {
    dream.feeling = feeling;
    dream.feelingSource = 'user';
    _saveToHive();
    notifyListeners();
  }

  Dream createNewDream({String? rawText}) {
    final dream = Dream(rawText: rawText ?? '');
    addDream(dream);
    return dream;
  }
}
