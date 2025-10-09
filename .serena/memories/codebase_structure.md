# Codebase Structure

## Directory Layout
```
dashboard/
├── lib/
│   ├── dashboard.dart              # Main package entry point
│   └── src/
│       ├── dashboard_base.dart     # Core implementation (library file)
│       ├── controller/             # State management
│       │   ├── dashboard_controller.dart
│       │   └── dashboard_item_storage.dart
│       ├── models/                 # Data models
│       │   ├── dashboard_item.dart
│       │   ├── item_layout_data.dart
│       │   ├── item_current_layout.dart
│       │   └── viewport_settings.dart
│       ├── widgets/                # UI components
│       │   ├── dashboard.dart
│       │   ├── dashboard_item_widget.dart
│       │   ├── dashboard_stack.dart
│       │   ├── animated_background_painter.dart
│       │   ├── cursor_message_widget.dart
│       │   └── style.dart
│       ├── edit_mode/              # Edit mode functionality
│       │   ├── edit_mode_settings.dart
│       │   ├── edit_mode_painter.dart
│       │   └── edit_mode_background_style.dart
│       └── exceptions/
│           └── unbounded.dart
├── example/                        # Example app demonstrating usage
│   ├── lib/
│   │   ├── main.dart              # Example dashboard implementation
│   │   ├── storage.dart           # Custom storage delegate
│   │   ├── add_dialog.dart        # UI for adding items
│   │   └── data_widget.dart       # Custom widget implementations
│   └── test/
├── test/
│   └── todo_test.dart             # Placeholder test file
├── documentation/                  # Images and docs
├── CLAUDE.md                      # Claude Code instructions
├── README.md                      # Package documentation
├── CHANGELOG.md                   # Version history
├── pubspec.yaml                   # Package configuration
└── analysis_options.yaml          # Linting rules
```

## Architecture Pattern

### Part/Library System
The codebase uses Dart's `part`/`library` directive system:
- **lib/dashboard.dart**: Main export file
- **lib/src/dashboard_base.dart**: Core library containing all implementation
- All files in src/ use `part of '../dashboard_base.dart'`

This approach keeps implementation modular while providing a single cohesive library.

## Key Components

### Models (`lib/src/models/`)
- **DashboardItem**: Base model containing identifier and layout data
- **ItemLayout**: Position (startX, startY) and dimensions (width, height)
- **ItemCurrentPosition**: Actual pixel dimensions during rendering

### Controllers (`lib/src/controller/`)
- **DashboardItemController**: Manages dashboard items, edit mode, add/delete operations
- **DashboardItemStorageDelegate**: Interface for persistent storage
- **_DashboardLayoutController**: Internal layout management (private)

### Widgets (`lib/src/widgets/`)
- **Dashboard**: Main widget users interact with
- **DashboardItemWidget**: Individual item rendering with gesture handling
- **Style**: Material styling configuration (ItemStyle)

### Edit Mode (`lib/src/edit_mode/`)
- **EditModeSettings**: Configuration for edit behavior
- **EditModePainter**: Custom painting for visual feedback
- **EditModeBackgroundStyle**: Styling for edit mode overlay

## Custom Additions
Comments marked with "raza" or "// by raza" indicate custom additions to the original package:
- Mounted checks for widget state safety
- Item swapping feature during drag operations
- Enhanced cursor message handling for mobile
- isDragging notifier for tracking drag state
