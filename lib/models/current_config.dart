import 'package:flutter/material.dart';

@immutable
class CurrentConfig {
  final String termPath;
  final String privacyPath;
  final double version;

  const CurrentConfig({
    required this.termPath,
    required this.privacyPath,
    required this.version,
  });

  static CurrentConfig get init => CurrentConfig(
        termPath: '',
        privacyPath: '',
        version: 0,
      );

  // copyWith
  CurrentConfig copyWith({
    String? termPath,
    String? privacyPath,
    double? version,
  }) {
    return CurrentConfig(
      termPath: termPath ?? this.termPath,
      privacyPath: privacyPath ?? this.privacyPath,
      version: version ?? this.version,
    );
  }

  // hashCode
  @override
  int get hashCode =>
      termPath.hashCode ^ privacyPath.hashCode ^ version.hashCode;

  // ==
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentConfig &&
          runtimeType == other.runtimeType &&
          termPath == other.termPath &&
          privacyPath == other.privacyPath &&
          version == other.version;
}
