import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/current_config.dart';
import 'package:which/models/remote_config.dart';
import 'package:which/services/current_config_service.dart';
import 'package:which/services/remote_config_service.dart';

final currentConfigProvider =
    FutureProvider<CurrentConfig>((_) => CurrentConfigService().get());

final remoteConfigProvider =
    FutureProvider<RemoteConfig>((_) => RemoteConfigService().get());
