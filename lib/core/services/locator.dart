/// Dependancy injection in Flutter
///
/// Easyly accessible services provider

import 'package:get_it/get_it.dart';
import 'package:treasurer/core/services/storage.service.dart';

/// Global services provider
GetIt locator = GetIt.instance;

/// Sets up the services provider by registering every services
setupServiceLocator() {
  locator.registerLazySingleton<StorageService>(() => FakeStorageService());
}
