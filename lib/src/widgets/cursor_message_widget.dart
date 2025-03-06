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
  }) : super(key: key);

  /// The dashboard controller that provides cursor messages.
  final DashboardItemController<T> controller;
  
  /// Optional text style for the message.
  final TextStyle? style;
  
  /// Widget to display when there is no cursor message.
  final Widget? emptyWidget;
  
  /// Optional builder for custom message display.
  final Widget Function(BuildContext context, String message)? builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: controller.cursorMessageNotifier,
      builder: (context, message, _) {
        if (message.isEmpty) {
          return emptyWidget ?? const SizedBox.shrink();
        }
        
        if (builder != null) {
          return builder!(context, message);
        }
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            message,
            style: style ?? const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }
} 