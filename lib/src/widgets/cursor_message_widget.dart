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
    this.mobileFriendly = true,
  }) : super(key: key);

  /// The dashboard controller that provides cursor messages.
  final DashboardItemController<T> controller;
  
  /// Optional text style for the message.
  final TextStyle? style;
  
  /// Widget to display when there is no cursor message.
  final Widget? emptyWidget;
  
  /// Optional builder for custom message display.
  final Widget Function(BuildContext context, String message)? builder;
  
  /// Whether to use a mobile-friendly style for the message display.
  /// This makes the touch messages more prominent and easier to see on mobile.
  final bool mobileFriendly;

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
        
        final bool isMobile = defaultTargetPlatform == TargetPlatform.iOS || 
                            defaultTargetPlatform == TargetPlatform.android;
        
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Container(
            key: ValueKey<String>(message),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile && mobileFriendly ? 20 : 16, 
              vertical: isMobile && mobileFriendly ? 12 : 8,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: isMobile && mobileFriendly ? 20 : 0,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(isMobile && mobileFriendly ? 8 : 4),
              boxShadow: isMobile && mobileFriendly ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 1,
                )
              ] : null,
            ),
            child: Text(
              message,
              style: style ?? TextStyle(
                color: Colors.white,
                fontSize: isMobile && mobileFriendly ? 16 : 14,
                fontWeight: isMobile && mobileFriendly ? FontWeight.w600 : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
} 