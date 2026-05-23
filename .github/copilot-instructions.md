# Copilot Instructions for flutter_application_1

This is a Flutter mobile application supporting iOS, Android, macOS, Windows, and Web platforms. The project follows Flutter best practices with Material Design and hot reload development.

## Project Architecture

**Entry Point:** [lib/main.dart](../lib/main.dart) contains:
- `MyApp`: Root StatelessWidget that configures MaterialApp theme and routing
- `MyHomePage`: Stateful widget demonstrating state management with `setState()`
- Counter example showing basic Flutter patterns (Scaffold, AppBar, FloatingActionButton)

**Build Outputs:** Cross-platform builds handled by platform-specific folders:
- `android/`, `ios/`, `macos/`, `windows/`, `web/` - Platform configuration and native code
- `build/` - Generated artifacts (not committed)

## Development Workflow

### Essential Commands
- **Run app:** `flutter run` (default device) or `flutter run -d <device-id>`
- **Run with VM:** `flutter run --vm-service` for debugging
- **Hot reload:** Press `r` in terminal or use IDE button (preserves app state)
- **Hot restart:** Press `R` (full app restart, resets state)
- **Run tests:** `flutter test` (executes tests in [test/](../test/))
- **Analyze code:** `flutter analyze` (checks against lint rules)
- **Format code:** `dart format lib/` or `dart format .` for entire project
- **List devices:** `flutter devices`

### Testing Patterns
Tests use `flutter_test` package with `WidgetTester` for UI testing:
- Located in [test/widget_test.dart](../test/widget_test.dart)
- Use `tester.pump()` or `tester.pumpWidget()` to render frames
- Find widgets via `find.text()`, `find.byIcon()`, `find.byType()`
- State changes trigger via `tester.tap()` and verified with `expect()`

## Code Conventions

### Dart Style (from analysis_options.yaml)
- Follows `flutter_lints` package recommendations
- Uses Material Icons by default (`uses-material-design: true`)
- Run `dart format` before committing - no manual style fixes
- Use `// ignore: lint_name` for intentional lint suppressions

### Widget Patterns
- **Stateless widgets:** For immutable, presentation-only UI
- **Stateful widgets:** For mutable state via `setState()` (current example pattern)
- **Build method:** Always called during hot reload; avoid expensive operations
- **Theme access:** Use `Theme.of(context).colorScheme` or `textTheme` for consistency

### State Management
Currently uses `setState()` for the counter example. For complex apps, consider:
- Lifting state up to parent widgets
- Provider package (if added)
- Other state solutions (BLoC, GetX, Riverpod) based on project needs

## Dependencies & Platform Support

- **SDK:** Dart ≥3.10.7
- **Flutter:** Material Design via `cupertino_icons: ^1.0.8`
- **Platforms:** Android, iOS, macOS, Windows, Web (all configured)
- **Dev deps:** `flutter_test`, `flutter_lints` for testing and linting

To add dependencies: `flutter pub add package_name` or edit [pubspec.yaml](../pubspec.yaml) and run `flutter pub get`

## Key Files Reference

- [lib/main.dart](../lib/main.dart) - App entry point and UI
- [test/widget_test.dart](../test/widget_test.dart) - Widget test example
- [pubspec.yaml](../pubspec.yaml) - Dependencies and project config
- [analysis_options.yaml](../analysis_options.yaml) - Lint rules
- [android/app/build.gradle.kts](../android/app/build.gradle.kts) - Android build config
- [ios/Runner.xcworkspace/](../ios/Runner.xcworkspace/) - iOS workspace (use .xcworkspace, not .xcodeproj)

## Common Pitfalls

1. **Hot reload limitations:** Can't reload const definitions globally; use hot restart instead
2. **iOS development:** Always use `.xcworkspace`, not `.xcodeproj` directly
3. **Build cache issues:** Run `flutter clean && flutter pub get && flutter run` if state is corrupted
4. **Widget rebuilds:** Unnecessarily rebuilding in `build()` impacts performance; extract pure widgets or use `const`
