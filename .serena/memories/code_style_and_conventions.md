# Code Style and Conventions

## Linting
- Uses `package:flutter_lints/flutter.yaml` as the base ruleset
- Configured in `analysis_options.yaml`
- Standard Flutter/Dart linting practices apply

## Language Features
- **Dart SDK**: >=3.0.0 <4.0.0
- Modern Dart features available (null safety, late variables, etc.)

## Naming Conventions

### Classes
- **PascalCase**: `DashboardItem`, `DashboardItemController`, `EditModeSettings`
- Private classes prefixed with underscore: `_DashboardLayoutController`, `_EditSession`, `_OverflowPossibility`

### Variables and Fields
- **camelCase**: `slotCount`, `itemController`, `layoutData`, `identifier`
- Private fields prefixed with underscore: `_items`, `_layoutController`, `_isEditing`
- Late initialization used where appropriate: `late var itemController`

### Methods
- **camelCase**: `add()`, `delete()`, `getAllItems()`, `onItemsUpdated()`
- Getters/setters follow property naming

### Constants
- **camelCase** for configuration values
- No SCREAMING_SNAKE_CASE observed in the codebase

## Documentation Style

### Class Documentation
- Uses triple-slash doc comments: `///`
- Includes description of purpose and usage
- References related classes with square brackets: `[DashboardItem]`, `[ItemLayout]`

Example:
```dart
/// A dashboard consists of [DashboardItem]s.
/// [DashboardItem] holds item identifier([identifier]) and [layoutData].
///
/// Look [ItemLayout] for more information about layout data.
class DashboardItem {
```

### Method Documentation
- Concise descriptions using `///`
- Parameters referenced in square brackets
- Not all methods are documented (especially private ones)

## Code Organization

### File Structure
- Uses Dart's `part of` directive for code organization
- All implementation files in `src/` are parts of `dashboard_base.dart`
- Main entry point exports from `dashboard_base.dart`

### Import Style
- Flutter imports: `import 'package:flutter/material.dart';`
- Package imports: `import 'package:dashboard/dashboard.dart';`
- Dart core: `import 'dart:async';`, `import 'dart:convert';`
- Relative imports for parts: `part of '../dashboard_base.dart';`

## Type Usage
- **Explicit types** used for fields and parameters
- **Type inference** (`var`) used for local variables when type is obvious
- **Generic types** used appropriately: `DashboardItemController<ColoredDashboardItem>`
- **Nullable types** with `?` operator: `int?`, `Color?`, `String?`

## Flutter Patterns

### Widget Structure
- StatefulWidget/State pattern for stateful components
- Proper lifecycle methods: `initState()`, `dispose()`, `build()`
- Keys used where needed: `Key? key`, `GlobalKey`, etc.

### State Management
- Controllers passed via constructor parameters
- ValueNotifier/ChangeNotifier for reactive state
- Example: `_cursorMessageNotifier`, `_isDraggingNotifier`

### Named Parameters
- Extensive use of named parameters with `required` keyword
- Optional parameters with default values
- Example: `minWidth = 1`, `minHeight = 1`

## Comments
- Inline comments used sparingly for complex logic
- Custom additions marked with author: `// by raza` or `// raza:`
- TODO comments in placeholder code
- Mounted checks commented: `// Check if widget is still mounted`

## Formatting
- Standard Dart formatting (use `dart format .`)
- No unusual spacing or alignment patterns
- Consistent indentation (2 spaces)
