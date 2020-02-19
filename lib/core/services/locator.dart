import 'package:get_it/get_it.dart';
import 'package:treasurer/core/services/storage.service.dart';

GetIt locator = GetIt.instance;

setupServiceLocator() {
  locator.registerLazySingleton<StorageService>(() => FakeStorageService());
}
