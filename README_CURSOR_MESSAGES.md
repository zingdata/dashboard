# Dashboard Cursor Messages

This feature provides contextual guidance messages based on user interactions with dashboard items, delivering a unified experience across both web and mobile platforms.

## How It Works

When users interact with dashboard items (hover, touch, drag, etc.), the system automatically:

1. Detects the type of interaction (move, resize, etc.)
2. Identifies the specific edge or region being interacted with
3. Determines the platform (web/mobile) to provide appropriate terminology
4. Delivers real-time guidance through a high-performance ValueNotifier

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

The system provides precision guidance with location-specific messages:

### Edge-Specific Messages
- **Left Edge**: "Drag left edge to resize horizontally"
- **Right Edge**: "Drag right edge to resize horizontally"
- **Top Edge**: "Drag top edge to resize vertically"
- **Bottom Edge**: "Drag bottom edge to resize vertically"
- **Corners**: "Drag corner to resize diagonally"

### Operation Status Messages
- **Selection**: "Item selected"
- **Moving**: "Moving item - release to place" / "Moving item - lift finger to place"
- **Resizing**: "Resizing to 3x4" (with live dimensions)
- **Completion**: "Resize complete" / "Item placed in new position"

### Platform-Specific Terminology
Web/Desktop:
- "Click and drag to move item"
- "Click and drag to resize horizontally"

Mobile/Touch:
- "Tap and hold to move item"
- "Touch edge and drag to resize"

## Unified Web & Mobile Experience

The system automatically adapts to provide consistent guidance across platforms:

### Web/Desktop Interactions
- Hover feedback shows available actions
- Single-click selection and dragging
- Live resizing with dimension feedback
- Precise edge detection for resize operations

### Mobile/Touch Interactions
- Tap feedback shows available actions
- Long-press and tap-and-drag support
- Edge detection for touch-based resizing
- Mobile-friendly terminology

## Platform Detection

The system automatically detects the platform and adapts all messages with appropriate terminology:

```dart
// Example of platform-aware message adaptation
final message = _isMobilePlatform(context)
  ? "Tap and hold to move this item" 
  : "Click and drag to move this item";
```

## Performance Optimizations

1. Uses ValueNotifier for synchronous, immediate updates
2. Minimizes UI rebuilds by separating cursor visuals from messages
3. Employs efficient gesture detection for both mouse and touch
4. Provides progressive disclosure - more detail as operations continue

## Custom Messages

The `DashboardCursorState` class now includes a comprehensive set of edge-specific states and messages. You can extend this functionality by adding your own custom states. 