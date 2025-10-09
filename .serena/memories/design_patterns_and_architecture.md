# Design Patterns and Architecture

## Core Design Patterns

### 1. Controller Pattern
**DashboardItemController** manages dashboard state and items:
- Central state management for all dashboard items
- Provides methods for CRUD operations: `add()`, `delete()`, `clear()`
- Supports two initialization modes:
  - Fixed items: `DashboardItemController(items: [...])`
  - Delegate-based: `DashboardItemController.withDelegate(itemStorageDelegate: ...)`
- Manages edit mode state via `isEditing` property
- Uses ValueNotifiers for reactive updates: `cursorMessageNotifier`, `isDraggingNotifier`

### 2. Delegate Pattern
**DashboardItemStorageDelegate** provides persistence abstraction:
- Interface for storage operations (load, save, update, delete)
- Allows custom storage implementations (SharedPreferences, database, etc.)
- Lifecycle callbacks:
  - `getAllItems(int slotCount)` - Load items for a slot count
  - `onItemsUpdated(...)` - Save layout changes
  - `onItemsAdded(...)` - Handle new items
  - `onItemsDeleted(...)` - Handle item removal
- Supports slot-specific or global layouts via `layoutsBySlotCount` flag
- Example implementation in `example/lib/storage.dart`

### 3. Builder Pattern
**DashboardItemBuilder** for custom item rendering:
- Two builder variants:
  - `itemBuilder: (item) => Widget` - Simple builder
  - `itemBuilderWithSize: (item, width, height) => Widget` - With size info
- Separation of data (DashboardItem) from presentation (Widget)
- Allows flexible item visualization

### 4. Widget Composition
**Dashboard Widget** uses composition:
- Scrollable viewport with custom scroll physics
- Stack-based layout for overlapping edit mode UI
- Gesture handling layer (DashboardItemWidget)
- Background painter for grid lines (EditModePainter)
- Animated transitions between layout states

### 5. Edit Session Pattern
**_EditSession** tracks editing state:
- Captures original state before editing
- Tracks direct and indirect changes
- Supports commit/rollback of changes
- Enables animated transitions during editing

## Architectural Layers

### 1. Presentation Layer
- **Widgets** (`lib/src/widgets/`)
- Handles rendering and user interaction
- Dashboard, DashboardItemWidget, style components
- Gesture detection and animation

### 2. Business Logic Layer
- **Controllers** (`lib/src/controller/`)
- State management and layout algorithms
- Item lifecycle management
- Edit mode coordination
- Internal: `_DashboardLayoutController` for complex layout logic

### 3. Data Layer
- **Models** (`lib/src/models/`)
- Pure data structures: DashboardItem, ItemLayout
- Serialization support: `toMap()`, `fromMap()`
- No business logic in models

### 4. Storage Layer
- **Delegate Interface** (`DashboardItemStorageDelegate`)
- Abstraction over persistence mechanism
- Implemented by package consumers

## Key Architectural Decisions

### Slot-Based Grid System
- Dashboard divided into horizontal slots (configurable count)
- Items positioned by slot coordinates (startX, startY)
- Items span multiple slots (width, height)
- Responsive: Slot count can change, triggering re-layout

### Layout Algorithm
- Auto-layout: Items slide to top when `slideToTop: true`
- Shrink-to-fit: Items shrink during editing if `shrinkToPlace: true`
- Collision detection and resolution
- Swapping: Items can swap positions during drag (custom addition)

### State Management
- Controller holds authoritative state
- Widgets rebuild on state changes
- ValueNotifiers for specific reactive needs
- AsyncSnapshot for async loading state

### Gesture Handling
- Long-press to enter edit mode (mobile)
- Drag to move or resize items
- Edge/corner detection for resize vs move
- Cursor message feedback for mobile users
- absorbPointer control during animations

## Extension Points

### 1. Custom DashboardItem
Extend `DashboardItem` to add custom properties:
```dart
class ColoredDashboardItem extends DashboardItem {
  Color? color;
  String? data;
  // Custom properties...
}
```

### 2. Custom Storage
Implement `DashboardItemStorageDelegate`:
- Database persistence
- Cloud sync
- Local file storage
- Any custom backend

### 3. Custom Styling
Use `ItemStyle` and `EditModeBackgroundStyle`:
- Material properties customization
- Edit mode visual feedback
- Grid line styling

### 4. Custom Item Widgets
Via `itemBuilder` or `itemBuilderWithSize`:
- Fully custom rendering
- Access to item data and dimensions
- Integration with any widget tree

## Performance Considerations

- **Viewport caching**: `cacheExtend` parameter for off-screen rendering
- **Lazy loading**: Items loaded asynchronously via delegate
- **Animation control**: `animateEverytime` flag
- **Rebuild optimization**: Internal `_building` flag prevents redundant rebuilds
- **Tree structures**: Internal RBTree usage for efficient layout queries
  - `_startsTree`, `_endsTree`, `_indexesTree` for O(log n) lookups

## Part/Library Pattern

Uses Dart's library directive system:
- Single cohesive API surface
- Internal implementation split across multiple files
- All src/ files are `part of` the main library
- Enables access to private members across files
- Main exports via `lib/dashboard.dart`
