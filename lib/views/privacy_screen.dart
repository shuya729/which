import 'package:which/models/remote_config.dart';
import 'package:which/models/terms.dart';
import 'package:which/services/storage_service.dart';
import 'package:which/views/term_screen.dart';

class PrivacyScreen extends TermScreen {
  const PrivacyScreen({super.key});

  @override
  String get title => 'プライバシーポリシー';
  static const String absolutePath = '/privacy';
  static const String relativePath = 'privacy';
  @override
  bool get initLoading => true;

  @override
  Future<List<Terms?>> getTerms(RemoteConfig remoteConfig) async {
    final StorageService storageService = StorageService();
    final String privacyPath = remoteConfig.privacyPath;
    return await storageService.getPrivacy(privacyPath);
  }
}
