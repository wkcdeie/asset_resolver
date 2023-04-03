# asset_resolver

[![Pub Version](https://img.shields.io/pub/v/asset_resolver)](https://pub.dev/packages/asset_resolver)

The `asset_resolver` package helps you to generate a .dart file that contains all assets according to `pubspec.yaml`.

## Getting started

### Install

```yaml
dev_dependencies:
  asset_resolver: any # Replace 'any' with version number.
  build_runner: any # Optional.
```

### Usage

```shell
flutter pub run build_runner build
```

More info about [build_runner](https://pub.dev/packages/build_runner).

### Options

```yaml
flutter:
  assets:
    - assets/images/

asset_resolver:
  output_class: Assets
  output_path: lib/assets.dart
  ## Optional
  # strip_field_prefix: assets
  # ignore_dpr: true
  # output_field_suffix: true
  # field_style: camelCase
  # package_name: example
```

- `output_class`: The output class name, default `Assets`
- `output_path`: Output file path, default `lib/assets.dart`
- `ignore_dpr`: Whether to ignore dpr folders, such as `1.5x`, `2.0x`, `3.0x`
- `output_field_suffix`: Whether the field name contains a suffix name, such as `PNG`, `JSON`
- `strip_field_prefix`: Intercept the prefix of the field name. for example: `assets/images/a.png`, intercept to `assets`; the final generated name is `images_a_png`
- `field_style`: The style of field naming; Support `camelCase`, `underScoreCase`; Default `camelCase`
- `package_name`: If it is a package, the resulting path is: `packages/{package_name}/{asset_path}`
