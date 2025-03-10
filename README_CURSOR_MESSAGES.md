# Dashboard Cursor Messages and State Tracking

This feature allows you to display helpful guidance messages to users based on their current interaction with dashboard items and track the dragging state of items.

## How It Works

When users hover over or interact with dashboard items, the system automatically detects what type of interaction is possible (move, resize, etc.) and provides a relevant message through a high-performance ValueNotifier. The system is platform-aware and provides different messages for desktop and mobile interactions.

Additionally, the system tracks whether any item is currently being dragged, allowing you to adjust UI elements accordingly.

## Usage Example

```dart
import 'package:flutter/material.dart';
import 'package:dashboard/dashboard.dart';

class DashboardExample extends StatelessWidget {
  final DashboardItemController controller = DashboardItemController(items: [
    // Your dashboard items here
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Your dashboard widget
          Dashboard(
            dashboardItemController: controller,
            // Other dashboard properties
          ),
          
          // Position your cursor message widget where you want the messages to appear
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: DashboardCursorMessageWidget(
                controller: controller,
                // Optional custom styling
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                // Optional custom builder
                builder: (context, message) {
                  return Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(message, style: TextStyle(color: Colors.white)),
                  );
                },
              ),
            ),
          ),
          
          // Show a "saving layout" indicator when dragging ends
          ValueListenableBuilder<bool>(
            valueListenable: controller.isDraggingNotifier,
            builder: (context, isDragging, child) {
              // When dragging stops, show a brief "saving layout" indicator
              if (!isDragging) {
                return FutureBuilder(
                  future: Future.delayed(Duration(milliseconds: 800)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Positioned(
                        top: 20,
                        right: 20,
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('Saving layout...', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
```

## Available Tracking Functionality

### Cursor Messages

The system automatically provides context-appropriate messages for different interactions:

#### Desktop Messages
- **Moving items**: "Click and drag to move item"
- **While dragging**: "Dragging item - release to place"
- **Resizing horizontally**: "Drag to resize horizontally"
- **Resizing vertically**: "Drag to resize vertically"
- **Resizing diagonally**: "Drag to resize diagonally"

#### Mobile Messages
- **Moving items**: "Touch and hold to move item"
- **While dragging**: "Moving item - lift finger to place"
- **Resizing edges**: "Touch edge and drag to resize"
- **Resizing corners**: "Drag corner to resize in both directions"
- **Selecting**: "Tap to select, double-tap to edit"

The system automatically detects the platform (mobile or desktop) and provides the appropriate cursor states and messages.

### Dragging State Tracking

The dashboard controller provides a `isDraggingNotifier` that lets you track whether any item is currently being dragged:

```dart
ValueListenableBuilder<bool>(
  valueListenable: controller.isDraggingNotifier,
  builder: (context, isDragging, child) {
    return isDragging 
      ? Text('Item is being dragged') 
      : Text('No drag in progress');
  },
)
```

This is useful for:
- Showing loading/saving indicators when repositioning completes
- Disabling certain UI elements during dragging
- Providing visual feedback during drag operations
- Synchronizing animations with dragging operations

## Advanced Usage

You can also access both notifiers directly from the controller if you want to build your own custom UI or logic:

```dart
// For cursor messages
ValueListenableBuilder<String>(
  valueListenable: controller.cursorMessageNotifier,
  builder: (context, message, _) {
    // Build your custom UI with the message
    return YourCustomWidget(message: message);
  },
)

// For dragging state
ValueListenableBuilder<bool>(
  valueListenable: controller.isDraggingNotifier,
  builder: (context, isDragging, _) {
    // React to dragging state changes
    return YourCustomWidget(isDragging: isDragging);
  },
)
```

## Performance Optimizations

The system is optimized for performance:

1. Uses ValueNotifier instead of streams for direct, synchronous updates
2. Avoids unnecessary widget rebuilds by only updating when values actually change
3. Separates cursor visual updates from message/state updates to minimize UI redraws
4. Implements efficient hover detection to reduce garbage collection pressure
5. Platform-specific messages that adapt to the user's device (mobile or desktop)

## Custom Messages and State Handling

The system uses the `DashboardCursorState` class to determine which messages to display. You can extend this functionality by implementing additional cursor states or customizing the existing ones. 