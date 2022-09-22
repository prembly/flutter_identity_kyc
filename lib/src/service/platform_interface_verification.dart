class VerificationPlatform {
  String? _key;
  String? _name;
  String? _publicKey;

  String get name => _name!;
  String get publicKey => _publicKey!;

  set name(String value) => _name = value;


  set publicKey(String value) => _publicKey = value;

  // static VerificationPlatform get instance {
  //   VerificationPlatform _appInstance = VerificationPlatform();
  //   return _appInstance;
  // }

  String? get key {
    // TODO: implement key
    throw UnimplementedError();
  }

  static VerificationPlatform get instance {
    return VerificationPlatform._();
  }

  // static set instance(VerificationPlatform instance) {
  //   _instance = instance;
  // }

  List<VerificationPlatform> get apps {
    throw UnimplementedError('apps has not been implemented.');
  }

  /// Initializes a new [VerificationPlatform] with [name] and merchant [publicKey].
  Future<VerificationPlatform> initializeInterface({
    String? name,
    String? publicKey
  }) async {
    _publicKey = publicKey;
    _name = name;
    return VerificationPlatform._();

    // return VerificationPlatform._();
    // throw UnimplementedError('initializeInterface() has not been implemented.');
  }

  VerificationPlatform._();

}