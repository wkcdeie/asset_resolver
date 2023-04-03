import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:path/path.dart' as p;
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'pubspec.dart';
import 'options.dart';

class AssetsBuilder extends Builder {
  static const separator = '_';
  final _regExp = RegExp('[.-]');
  final _dprRegExp = RegExp(r'^\d.\dx$');
  Pubspec? _pubspec;
  Options? _options;

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    if (_pubspec == null) {
      _pubspec = Pubspec('pubspec.yaml');
      _options = _pubspec?.getOptions();
    }
    final assets = _pubspec!.getAssets();
    if (assets.isEmpty) {
      return null;
    }
    final package = buildStep.inputId.package;
    Map<String, String> fields = {};
    for (var path in assets) {
      final assetId = AssetId(package, path);
      final entries = _scanAssets(assetId.path);
      fields.addEntries(entries);
    }
    final assetsCls = Class((cls) {
      cls.name = _options?.outputClass;
      cls.docs.add("// GENERATED CODE - DO NOT MODIFY BY HAND\n");
      cls.docs.add(
          "// **************************************************************************");
      cls.docs.add("// AssetsBuilder");
      cls.docs.add(
          "// **************************************************************************\n");
      cls.docs.add("// ignore_for_file: constant_identifier_names");
      for (var field in fields.entries) {
        final fb = FieldBuilder();
        fb.name = field.key;
        fb.type = refer('String');
        fb.static = true;
        fb.assignment = Code("'${field.value}'");
        fb.modifier = FieldModifier.constant;
        fb.docs.add("/// ${field.value}");
        cls.fields.add(fb.build());
      }
    });
    final emitter = DartEmitter();
    final formatter = DartFormatter();
    final saveAsset = AssetId(buildStep.inputId.package, _options!.outputPath);
    await buildStep.writeAsString(
        saveAsset, formatter.format('${assetsCls.accept(emitter)}'));
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        r'$lib$': ['assets.dart']
      };

  List<MapEntry<String, String>> _scanAssets(String path) {
    if (FileSystemEntity.isDirectorySync(path)) {
      final directory = Directory(path);
      final files = directory
          .listSync(recursive: true, followLinks: false)
          .map((e) => e.path);
      return files
          .map((e) => _scanAssets(e))
          .expand((element) => element)
          .toList();
    }
    String filePath = path;
    if (false == _options?.outputFieldSuffix) {
      final extName = p.extension(filePath);
      filePath = filePath.replaceAll(extName, '');
    }
    if (_options?.stripFieldPrefix != null) {
      filePath = filePath.replaceAll(_options!.stripFieldPrefix!, '');
    }
    final segments = p.split(filePath).where((element) {
      if (true == _options?.ignoreDpr && _dprRegExp.hasMatch(element)) {
        return false;
      }
      return element.trim().isNotEmpty && element != p.separator;
    });
    String fileName = segments.join(separator).replaceAll(_regExp, separator);
    if (_options?.fieldStyle == Options.camelCase) {
      StringBuffer sb = StringBuffer();
      final values = fileName.split(separator);
      sb.write(values[0]);
      for (int i = 1; i < values.length; i++) {
        sb.write(values[i].substring(0, 1).toUpperCase());
        if (values[i].length > 1) {
          sb.write(values[i].substring(1));
        }
      }
      fileName = sb.toString();
    }
    String assetPath = path;
    if (_options?.packageName != null) {
      assetPath = 'packages/${_options?.packageName}/$assetPath';
    }
    return [MapEntry(fileName, assetPath)];
  }
}
