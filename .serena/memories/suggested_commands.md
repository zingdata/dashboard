# Suggested Commands

## Essential Development Commands

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/specific_test.dart

# Run tests with verbose output
flutter test --verbose
```

### Code Quality
```bash
# Analyze code (lint checking)
flutter analyze

# Format code
dart format .

# Format specific file or directory
dart format lib/
```

### Dependencies
```bash
# Get dependencies
flutter pub get

# Update dependencies
flutter pub upgrade

# Clean build artifacts
flutter clean
```

### Running Example App
```bash
# Navigate to example directory first
cd example

# Run example app (auto-detect device)
flutter run

# Run on specific device (Chrome)
flutter run -d chrome

# Run on specific device (macOS)
flutter run -d macos

# List available devices
flutter devices
```

### Building Example
```bash
# Build for web
cd example && flutter build web

# Build Android APK
cd example && flutter build apk

# Build iOS (requires macOS)
cd example && flutter build ios
```

### Package Publishing
```bash
# Dry run publish (check package validity)
flutter pub publish --dry-run

# Publish to pub.dev (requires credentials)
flutter pub publish
```

### Flutter Version Management (FVM)
```bash
# Install Flutter version from .fvmrc
fvm install

# Use project's Flutter version for commands
fvm flutter [command]

# Example: Run tests with FVM
fvm flutter test
```

## macOS-Specific Notes
- System is Darwin (macOS)
- Standard Unix commands available: `ls`, `cd`, `grep`, `find`, `git`
- No special command adaptations needed for macOS

## Git Commands
```bash
# Check status
git status

# View changes
git diff

# View commit history
git log --oneline

# Current branch
git branch --show-current
```

## Common Workflows

### Before Committing
```bash
dart format .
flutter analyze
flutter test
```

### Testing a Change
```bash
# Make code changes
flutter analyze
cd example && flutter run -d chrome
# Test manually in example app
```

### Publishing New Version
```bash
# Update version in pubspec.yaml
# Update CHANGELOG.md
dart format .
flutter analyze
flutter test
flutter pub publish --dry-run
flutter pub publish
```
