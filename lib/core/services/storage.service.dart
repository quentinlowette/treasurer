abstract class StorageService {
  Future<int> getValue();
  Future<void> setValue(int value);
}

class FakeStorageService extends StorageService {
  @override
  Future<int> getValue() async {
    return Future.delayed(Duration(seconds: 2), () => 5);
  }

  @override
  Future<void> setValue(int value) async {
    // do nothing
  }
}
