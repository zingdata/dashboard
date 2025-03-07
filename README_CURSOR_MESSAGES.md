# Dashboard Cursor Messages

This feature allows you to display helpful guidance messages to users based on their current interaction with dashboard items, working on both desktop (mouse/hover) and mobile (touch) platforms.

## How It Works

When users hover over or interact with dashboard items, the system automatically detects what type of interaction is possible (move, resize, etc.) and provides a relevant message through a high-performance ValueNotifier.

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
        ],
      ),
    );
  }
}
```

## Available Messages

The system automatically provides context-appropriate messages for different interactions:

### Mouse/Desktop Interactions
- **Moving items**: "Click and drag to move item"
- **While dragging**: "Dragging item - release to place"
- **Resizing horizontally**: "Drag to resize horizontally"
- **Resizing vertically**: "Drag to resize vertically"
- **Resizing diagonally**: "Drag to resize diagonally"

### Touch/Mobile Interactions
- **Selecting items**: "Tap to select, double-tap to edit"
- **Moving items**: "Touch and hold to move item"
- **While moving**: "Moving item - lift finger to place"
- **Resizing from edges**: "Touch edge and drag to resize"
- **Resizing from corners**: "Drag corner to resize in both directions"
- **After resizing**: "Resize complete"

## Platform-Aware Messages

The system automatically adapts messages based on the interaction method:

- On desktop, messages are triggered by hover and mouse events
- On mobile, messages are triggered by touch gestures
- The content is adapted to make sense for the interaction method (e.g., "click" vs "tap")

## Advanced Usage

You can also access the cursor message notifier directly from the controller if you want to build your own custom UI:

```dart
ValueListenableBuilder<String>(
  valueListenable: controller.cursorMessageNotifier,
  builder: (context, message, _) {
    // Build your custom UI with the message
    return YourCustomWidget(message: message);
  },
)
```

## Performance Optimizations

The cursor message system is optimized for performance:

1. Uses ValueNotifier instead of streams for direct, synchronous updates
2. Avoids unnecessary widget rebuilds by only updating when messages actually change
3. Separates cursor visual updates from message updates to minimize UI redraws
4. Implements efficient gesture detection to reduce overhead

## Custom Messages

The system uses the `DashboardCursorState` class to determine which messages to display. You can extend this functionality by implementing additional cursor states or customizing the existing ones. 