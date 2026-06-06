// ============================================================================
// EXERCISE 5: Factory Constructors & Cache
// Goal: Show how factory constructors implement caching and singleton patterns.
// ============================================================================

/// 1. Create a Settings class with a private constructor
class Settings {
  final String environment;
  final String theme;

  // Private named constructor prevents external ad-hoc allocations
  Settings._internal({
    required this.environment,
    required this.theme,
  });

  // Static cached reference to the singleton instance
  static Settings? _cache;

  // 2. Add a factory Settings() that returns the singleton instance from cache
  factory Settings({String environment = 'Production', String theme = 'Dark'}) {
    // Lazy initialization: if the cache is empty, create the instance
    _cache ??= Settings._internal(
      environment: environment,
      theme: theme,
    );
    return _cache!;
  }

  void displayInfo() {
    print('Settings Info: [Env: $environment | Theme: $theme | Hash: $hashCode]');
  }
}

/// Runner for Exercise 5
void runExercise5() {
  print('======================================================================');
  print('EXERCISE 5: Factory Constructors & Cache');
  print('======================================================================');

  print('[Factory] Allocating instances of Settings... ');

  // Creating two separate references to "new Settings"
  final s1 = Settings(environment: 'Production', theme: 'Dark');
  final s2 = Settings(environment: 'Development', theme: 'Light'); // arguments ignored because singleton exists

  s1.displayInfo();
  s2.displayInfo();

  // 3. Verify two instances refer to the same object (identical(a, b) -> true)
  final isIdentical = identical(s1, s2);
  print('\n[Factory] Verifying identical instances (s1 === s2):');
  print('  -> identical(s1, s2) = $isIdentical');

  if (isIdentical) {
    print('  [SUCCESS] Both references point to the exact same singleton instance in memory!');
  } else {
    print('  [FAIL] Different instances were created.');
  }

  print('======================================================================\n');
}
