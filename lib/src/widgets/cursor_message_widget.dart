part of dashboard;

/// A widget that displays cursor interaction messages from a DashboardItemController.
/// 
/// Place this widget in your layout to provide contextual help messages based on
/// what the user is currently doing with the dashboard items.
class DashboardCursorMessageWidget<T extends DashboardItem> extends StatelessWidget {
  /// Creates a dashboard cursor message widget.
  ///
  /// The [controller] is required to get the cursor message stream.
  /// The [style] is optional and can be used to customize the appearance.
  const DashboardCursorMessageWidget({
    Key? key,
    required this.controller,
    this.style,
    this.emptyWidget,
    this.builder,
    this.adaptForMobile = true,
  }) : super(key: key);

  /// The dashboard controller that provides cursor messages.
  final DashboardItemController<T> controller;
  
  /// Optional text style for the message.
  final TextStyle? style;
  
  /// Widget to display when there is no cursor message.
  final Widget? emptyWidget;
  
  /// Optional builder for custom message display.
  final Widget Function(BuildContext context, String message)? builder;
  
  /// Whether to automatically adapt messages for mobile platforms.
  /// If true, certain desktop-specific terms will be changed to mobile-friendly ones.
  /// For example, "Click" changes to "Tap", "Drag" remains the same, etc.
  final bool adaptForMobile;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: controller.cursorMessageNotifier,
      builder: (context, message, _) {
        if (message.isEmpty) {
          return emptyWidget ?? const SizedBox.shrink();
        }
        
        // Adapt message for mobile if needed
        final adaptedMessage = adaptForMobile 
            ? _adaptMessageForPlatform(context, message)
            : message;
        
        if (builder != null) {
          return builder!(context, adaptedMessage);
        }
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            adaptedMessage,
            style: style ?? const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }
  
  /// Adapts desktop-oriented messages to be more mobile-friendly
  String _adaptMessageForPlatform(BuildContext context, String message) {
    // Check if we're on a mobile platform
    final isMobile = Theme.of(context).platform == TargetPlatform.iOS || 
                   Theme.of(context).platform == TargetPlatform.android;
    
    if (!isMobile) return message;
    
    // Replace desktop-specific terms with mobile-friendly alternatives
    return message
      .replaceAll('Click', 'Tap')
      .replaceAll('click', 'tap')
      .replaceAll('Cursor', 'Finger')
      .replaceAll('cursor', 'finger')
      .replaceAll('Mouse', 'Touch')
      .replaceAll('mouse', 'touch')
      .replaceAll('release', 'lift finger');
  }
} 