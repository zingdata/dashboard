# Implementation Notes and Gotchas

## Custom Additions by Raza

The codebase contains several custom additions marked with comments like "// by raza" or "// raza:". These modifications include:

### 1. Mounted Checks
- Safety checks to prevent updates on unmounted widgets
- Example: `if (mounted) { setState(...) }`
- Prevents errors when widgets are disposed during async operations

### 2. Item Swapping Feature
- Items can swap positions when dragged over each other
- Controlled by `allowSwapping` parameter in Dashboard widget
- Custom logic in gesture handling and layout controller

### 3. Cursor Message Handling
- Enhanced feedback for mobile users during drag/resize
- `cursorMessageNotifier` in DashboardItemController
- `updateCursorMessage` callback for custom messages
- Related widget: `CursorMessageWidget`

### 4. Dragging State Tracking
- `isDraggingNotifier` ValueNotifier in DashboardItemController
- `updateDraggingState` callback
- Allows external widgets to react to drag state
- Useful for UI feedback and conditional rendering

## Important Implementation Details

### Part/Library System
- **Critical**: All files in `src/` use `part of '../dashboard_base.dart'`
- Cannot use regular imports between src files
- All implementation shares same namespace
- Private members (prefixed with `_`) are accessible across parts

### Async Loading Pattern
- Controller can be initialized with delegate: `DashboardItemController.withDelegate(...)`
- Items loaded asynchronously: `_asyncSnap` holds `AsyncSnapshot`
- Placeholders shown during loading:
  - `loadingPlaceholder` - During data fetch
  - `emptyPlaceholder` - When no items
  - `errorPlaceholder` - On error

### Layout Coordinates
- **startX, startY**: Position in slot grid (0-indexed)
- **width, height**: Size in slot units (not pixels)
- **Constraints**: minWidth, minHeight, maxWidth, maxHeight
- **Auto-positioning**: If startX/startY null, item positioned automatically

### Edit Mode States
- Controlled via `DashboardItemController.isEditing` property
- Edit session tracks changes: `_EditSession`
- Can be committed: `saveEditSession()`
- Can be cancelled: `cancelEditSession()`
- Animations during transitions controlled by `EditModeSettings`

### Gesture Detection
- Long-press and pan gestures used for editing
- Corner/edge detection for resize vs move:
  - `resizeCursorSide` parameter defines edge width
  - Corners trigger resize in both dimensions
  - Edges trigger resize in one dimension
  - Center triggers move
- Mobile-specific cursor messages provide feedback

## Common Gotchas

### 1. Slot Count Changes
- When `slotCount` changes, entire layout may need recalculation
- Items may need to shrink to fit new slot count
- With storage delegate: Different layouts per slot count possible
- Without delegate: Same items adjusted to new slot count

### 2. Storage Delegate Implementation
- **layoutsBySlotCount**: Return true if you store different layouts per slot count
- **cacheItems**: Return true if you cache items in memory
- Must handle all lifecycle callbacks: `getAllItems`, `onItemsUpdated`, `onItemsAdded`, `onItemsDeleted`
- Return type must match controller generic type

### 3. Widget Key Management
- Dashboard manages internal keys for items
- Don't manually set keys on built item widgets
- Item identity tracked by `identifier` string

### 4. Slider and ScrollController
- Dashboard is scrollable (vertical by default)
- Can provide custom `scrollController`
- Physics can be customized via `physics` parameter
- `cacheExtend` controls off-screen rendering

### 5. ItemStyle and Material
- Each item wrapped in Material widget
- `ItemStyle` maps to Material properties
- Default type is `MaterialType.card`
- Transparency requires `MaterialType.transparency`

### 6. Animation Control
- `animateEverytime`: Animate all layout changes (default true)
- `EditModeSettings.duration` and `curve`: Control animation timing
- Can impact performance with many items

### 7. Spacing
- `horizontalSpace` and `verticalSpace`: Gaps between items in pixels
- `padding`: Overall dashboard padding
- These affect actual item pixel dimensions

## Testing Considerations

- Current test suite is minimal (placeholder test in `test/todo_test.dart`)
- Example app serves as primary testing vehicle
- Manual testing required for:
  - Gesture interactions
  - Cross-platform behavior (web, mobile, desktop)
  - Storage persistence
  - Layout algorithm edge cases

## Performance Tips

### For Many Items
- Use `cacheExtend` conservatively
- Consider `animateEverytime: false` for large dashboards
- Optimize `itemBuilder` - avoid expensive operations
- Use `const` constructors where possible

### For Complex Items
- Use `itemBuilderWithSize` to respond to actual pixel dimensions
- Implement efficient item widgets (avoid rebuilds)
- Consider widget caching in custom items

### For Storage
- Implement `cacheItems: true` in delegate
- Batch updates when possible
- Use efficient serialization (JSON is used in example)

## Current Branch Context
- **Working branch**: improve-cursor-message-for-mobile
- **Main branch**: master
- **Recent work**: Cursor message handling and mobile tap feedback
- Modified file: `lib/src/controller/dashboard_controller.dart`

## File Being Viewed
The user has `example/lib/storage.dart` open, which demonstrates:
- Custom `DashboardItem` subclass (`ColoredDashboardItem`)
- `DashboardItemStorageDelegate` implementation using SharedPreferences
- Slot-specific layout storage
- Default layouts for different slot counts (4, 6, 8)
- Proper serialization/deserialization with `toMap()`/`fromMap()`
