import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:which/models/current_config.dart';

class CurrentConfigService {
  // バージョン情報(上位2桁)
  Future<CurrentConfig> _getVersion(CurrentConfig currentConfig) async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final List<String> versionParts = packageInfo.version.split('.');
    final String majorMinor = '${versionParts[0]}.${versionParts[1]}';
    return currentConfig.copyWith(version: double.parse(majorMinor));
  }

  Future<CurrentConfig> _getTerms(CurrentConfig currentConfig) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? termPath = prefs.getString('termPath');
    final String? privacyPath = prefs.getString('privacyPath');
    return currentConfig.copyWith(termPath: termPath, privacyPath: privacyPath);
  }

  Future<CurrentConfig> get() async {
    CurrentConfig currentConfig = CurrentConfig.init;
    currentConfig = await _getVersion(currentConfig);
    currentConfig = await _getTerms(currentConfig);
    return currentConfig;
  }

  Future<void> setTerms({
    String? termPath,
    String? privacyPath,
  }) async {
    if (termPath == null && privacyPath == null) return;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (termPath != null) await prefs.setString('termPath', termPath);
    if (privacyPath != null) await prefs.setString('privacyPath', privacyPath);
  }
}
