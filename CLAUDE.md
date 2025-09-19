# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter package called `dashboard` that provides a dynamic dashboard widget allowing users to create their own layouts with resize, move, and auto re-layout capabilities. The package is published to pub.dev and includes an example implementation.

## Key Commands

### Development Commands
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/specific_test.dart

# Run tests with verbose output
flutter test --verbose

# Analyze code (lint checking)
flutter analyze

# Format code
dart format .

# Get dependencies
flutter pub get

# Clean build artifacts
flutter clean

# Run example app
cd example && flutter run

# Run example app on specific device
cd example && flutter run -d chrome

# Build example for web
cd example && flutter build web

# Build example for Android APK
cd example && flutter build apk

# Publish package (dry run)
flutter pub publish --dry-run

# Publish package to pub.dev
flutter pub publish
```

### Flutter Version Management
This project uses FVM (Flutter Version Manager):
```bash
# Install Flutter version specified in .fvmrc
fvm install

# Use the project's Flutter version
fvm flutter [command]
```

## Architecture Overview

### Core Components

**Main Entry Point**: `lib/dashboard.dart` - Exports the main library components
**Core Library**: `lib/src/dashboard_base.dart` - Contains all implementation using Dart's `part`/`library` system

### Key Classes Structure

1. **Dashboard Widget** (`src/widgets/dashboard.dart`)
   - Main widget that users interact with
   - Manages scrolling, layout, and rendering
   - Handles responsive slot-based grid system
   - Supports both fixed items and delegate-based storage

2. **DashboardItemController** (`src/controller/dashboard_controller.dart`)
   - Manages dashboard items and their lifecycle
   - Handles add/delete operations and layout changes
   - Supports editing mode for interactive modifications

3. **DashboardItem** (`src/models/dashboard_item.dart`)
   - Base model for dashboard items
   - Contains position (startX, startY) and dimensions (width, height)
   - Supports min/max constraints and unique identifiers

4. **Storage System** (`src/controller/dashboard_item_storage.dart`)
   - `DashboardItemStorageDelegate` interface for persistence
   - Supports both slot-specific and global layouts
   - Handles async loading and saving of layouts

5. **Edit Mode System**
   - `EditModeSettings` - Configuration for editing behavior
   - `EditModeBackgroundStyle` - Visual styling during editing
   - `EditModePainter` - Custom painting for edit overlays

### Layout System

The dashboard uses a slot-based grid system:
- **Slots**: Horizontal divisions determined by `slotCount`
- **Aspect Ratio**: Slot height controlled by `slotAspectRatio` or fixed `slotHeight`
- **Responsive**: Automatically adjusts to different screen sizes
- **Auto-layout**: Items can slide to top and shrink to fit

### Key Features Implementation

1. **Drag & Drop**: Gesture handling in `DashboardItemWidget`
2. **Resize**: Corner/edge detection and manipulation
3. **Swapping**: Items can swap positions when dragged over each other (custom addition by Raza)
4. **Persistence**: Storage delegate pattern for saving layouts
5. **Animation**: Smooth transitions during layout changes

## Example Usage Pattern

The `example/` directory demonstrates typical usage:
- **Storage Implementation**: `example/lib/storage.dart` shows custom storage delegate
- **Item Builder**: `example/lib/main.dart` shows how to build dashboard items
- **Custom Items**: `ColoredDashboardItem` extends `DashboardItem` with additional properties

## Development Notes

- Uses Flutter's `part`/`library` system - all implementation is in `dashboard_base.dart` with parts in `src/`
- Custom additions marked with comments by "raza" include:
  - Mounted checks for widget state safety
  - Item swapping feature when dragging over other items
  - Enhanced gesture handling improvements
- Supports web, mobile, and desktop through Flutter's cross-platform capabilities
- Includes extensive documentation and examples as shown in README.md
- The `example/` directory contains a complete implementation with custom storage delegate
- Main library entry point is `lib/dashboard.dart` which exports `dashboard_base.dart` and style components

## Testing

- Test files located in `test/` directory
- Example app tests in `example/test/`
- Use `flutter test` to run all tests
- Run specific tests with `flutter test test/filename_test.dart`
- Note: Current test suite is minimal (contains placeholder TODO test)

## Publishing

This is a pub.dev package. When making changes:
1. Update version in `pubspec.yaml`
2. Update `CHANGELOG.md`
3. Run `flutter pub publish --dry-run` to validate
4. Use `flutter pub publish` to publish (requires pub.dev credentials)