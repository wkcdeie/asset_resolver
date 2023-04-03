class Options {
  static const String camelCase = 'camelCase';
  static const String underScoreCase = 'underScoreCase';

  final String outputClass;
  final String outputPath;
  final String? stripFieldPrefix;
  final bool outputFieldSuffix;
  final String? fieldStyle;
  final bool ignoreDpr;
  final String? packageName;

  const Options(
      {required this.outputClass,
      required this.outputPath,
      this.stripFieldPrefix,
      this.outputFieldSuffix = false,
      this.fieldStyle,
      this.ignoreDpr = true,
      this.packageName});

  factory Options.fromJson(Map<String, dynamic> json) {
    return Options(
      outputClass: json['output_class'] ?? 'Assets',
      outputPath: json['output_path'] ?? 'lib/assets.dart',
      fieldStyle: json['fieldStyle'],
      stripFieldPrefix: json['strip_field_prefix'],
      outputFieldSuffix: json['output_field_suffix'] ?? false,
      ignoreDpr: json['ignore_dpr'] ?? true,
      packageName: json['package_name'],
    );
  }
}
