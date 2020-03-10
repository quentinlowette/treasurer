/// Dependancy injection in Flutter
///
/// Easyly accessible services provider

import 'package:get_it/get_it.dart';
import 'package:treasurer/core/services/databaseStorage.service.dart';
import 'package:treasurer/core/services/storage.service.dart';
import 'package:treasurer/core/services/textRecognition.service.dart';
import 'package:treasurer/core/viewmodels/account.vm.dart';

/// Global services provider
GetIt locator = GetIt.instance;

/// Sets up the services provider by registering every services
/// and the viewmodels needed at multiple places in the application
setupServiceLocator() {
  // Services
  locator.registerLazySingleton<StorageService>(() => DatabaseStorageService());
  locator.registerLazySingleton<TextRecognitionService>(() => FMLVTextRecognitionService());

  // ViewModels
  locator.registerLazySingleton<AccountViewModel>(() => AccountViewModel());
}
