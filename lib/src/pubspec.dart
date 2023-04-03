import 'dart:io';

import 'package:yaml/yaml.dart';
import 'options.dart';

class Pubspec {
  final String path;
  YamlMap? _yaml;

  Pubspec(this.path);

  List<String> getAssets() {
    if (_yaml == null) {
      _readYaml();
    }
    final resources = _yaml?['flutter'];
    if (resources == null) {
      return [];
    }
    final assets = resources['assets'];
    if (assets == null) {
      return [];
    }
    return List<String>.from(assets);
  }

  Options getOptions() {
    if (_yaml == null) {
      _readYaml();
    }
    final options = _yaml?['asset_resolver'];
    return Options.fromJson(Map<String, dynamic>.from(options ?? {}));
  }

  void _readYaml() {
    assert(path.isNotEmpty);
    final file = File(path);
    _yaml = loadYaml(file.readAsStringSync());
  }
}
