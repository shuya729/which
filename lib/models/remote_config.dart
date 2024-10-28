import 'package:flutter/material.dart';
import 'package:which/models/current_config.dart';

@immutable
class RemoteConfig extends CurrentConfig {
  final bool mantainance;

  const RemoteConfig({
    required super.termPath,
    required super.privacyPath,
    required super.version,
    required this.mantainance,
  });

  static RemoteConfig get init => RemoteConfig(
        termPath: 'term_0001.json',
        privacyPath: 'privacy_0001.json',
        version: 0,
        mantainance: false,
      );

  factory RemoteConfig.fromFirestore(Map<String, dynamic> data) {
    double version = init.version;
    if (data['leastVersion'] is double) {
      version = data['leastVersion'] as double;
    } else if (data['leastVersion'] is int) {
      version = (data['leastVersion'] as int).toDouble();
    }

    return RemoteConfig(
      termPath: data['termPath'] as String? ?? init.termPath,
      privacyPath: data['privacyPath'] as String? ?? init.privacyPath,
      version: version,
      mantainance: data['mantainance'] as bool? ?? init.mantainance,
    );
  }

  bool isMentainance() => mantainance;
  bool needUpdate(double version) => this.version > version;
  bool needCheckTerm(String termPath) => this.termPath != termPath;
  bool needCheckPrivacy(String privacyPath) => this.privacyPath != privacyPath;

  // copyWith
  @override
  RemoteConfig copyWith({
    String? termPath,
    String? privacyPath,
    double? version,
    bool? mantainance,
  }) {
    return RemoteConfig(
      termPath: termPath ?? this.termPath,
      privacyPath: privacyPath ?? this.privacyPath,
      version: version ?? this.version,
      mantainance: mantainance ?? this.mantainance,
    );
  }

  // hashCode
  @override
  int get hashCode =>
      termPath.hashCode ^
      privacyPath.hashCode ^
      version.hashCode ^
      mantainance.hashCode;

  // ==
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RemoteConfig &&
          runtimeType == other.runtimeType &&
          termPath == other.termPath &&
          privacyPath == other.privacyPath &&
          version == other.version &&
          mantainance == other.mantainance;
}
