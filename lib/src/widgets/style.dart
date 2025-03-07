import 'package:flutter/material.dart';

class ItemStyle {
  const ItemStyle({
    this.color,
    this.shadowColor,
    this.shape,
    this.borderOnForeground,
    this.clipBehavior,
    this.animationDuration,
    this.type,
    this.elevation,
    this.borderRadius,
    this.textStyle,
  });

  /// The kind of material to show (e.g., card or canvas). This
  /// affects the shape of the widget, the roundness of its corners if
  /// the shape is rectangular, and the default color.
  final MaterialType? type;

  /// {@template flutter.material.material.elevation}
  /// The z-coordinate at which to place this material relative to its parent.
  ///
  /// This controls the size of the shadow below the material and the opacity
  /// of the elevation overlay color if it is applied.
  ///
  /// If this is non-zero, the contents of the material are clipped, because the
  /// widget conceptually defines an independent printed piece of material.
  ///
  /// Defaults to 0. Changing this value will cause the shadow and the elevation
  /// overlay to animate over [Material.animationDuration].
  ///
  /// The value is non-negative.
  ///
  /// See also:
  ///
  ///  * [ThemeData.applyElevationOverlayColor] which controls the whether
  ///    an overlay color will be applied to indicate elevation.
  ///  * [Material.color] which may have an elevation overlay applied.
  ///
  /// {@endtemplate}
  final double? elevation;

  /// The color to paint the material.
  ///
  /// Must be opaque. To create a transparent piece of material, use
  /// [MaterialType.transparency].
  ///
  /// To support dark themes, if the surrounding
  /// [ThemeData.applyElevationOverlayColor] is true and [ThemeData.brightness]
  /// is [Brightness.dark] then a semi-transparent overlay color will be
  /// composited on top of this color to indicate the elevation.
  ///
  /// By default, the color is derived from the [type] of material.
  final Color? color;

  /// The color to paint the shadow below the material.
  ///
  /// If null, [ThemeData.shadowColor] is used, which defaults to fully opaque black.
  ///
  /// Shadows can be difficult to see in a dark theme, so the elevation of a
  /// surface should be portrayed with an "overlay" in addition to the shadow.
  /// As the elevation of the component increases, the overlay increases in
  /// opacity.
  ///
  /// See also:
  ///
  ///  * [ThemeData.applyElevationOverlayColor], which turns elevation overlay
  /// on or off for dark themes.
  final Color? shadowColor;

  /// The typographical style to use for text within this material.
  final TextStyle? textStyle;

  /// Defines the material's shape as well its shadow.
  ///
  /// If shape is non null, the [borderRadius] is ignored and the material's
  /// clip boundary and shadow are defined by the shape.
  ///
  /// A shadow is only displayed if the [elevation] is greater than
  /// zero.
  final ShapeBorder? shape;

  /// Whether to paint the [shape] border in front of the [child].
  ///
  /// The default value is true.
  /// If false, the border will be painted behind the [child].
  final bool? borderOnForeground;

  /// {@template flutter.material.Material.clipBehavior}
  /// The content will be clipped (or not) according to this option.
  ///
  /// See the enum [Clip] for details of all possible options and their common
  /// use cases.
  /// {@endtemplate}
  ///
  /// Defaults to [Clip.none], and must not be null.
  final Clip? clipBehavior;

  /// Defines the duration of animated changes for [shape], [elevation],
  /// [shadowColor] and the elevation overlay if it is applied.
  ///
  /// The default value is [kThemeChangeDuration].
  final Duration? animationDuration;

  /// If non-null, the corners of this box are rounded by this
  /// [BorderRadiusGeometry] value.
  ///
  /// Otherwise, the corners specified for the current [type] of material are
  /// used.
  ///
  /// If [shape] is non null then the border radius is ignored.
  ///
  /// Must be null if [type] is [MaterialType.circle].
  final BorderRadiusGeometry? borderRadius;
}

// Add this class to hold cursor state and associated message
class DashboardCursorState {
  final MouseCursor cursor;
  final String message;

  const DashboardCursorState(this.cursor, this.message);

  // Common cursor states with descriptive messages
  static const DashboardCursorState grab = DashboardCursorState(
    SystemMouseCursors.grab,
    'Click and drag to move item',
  );
  
  static const DashboardCursorState grabbing = DashboardCursorState(
    SystemMouseCursors.grabbing,
    'Dragging item - release to place',
  );
  
  static const DashboardCursorState resizeHorizontal = DashboardCursorState(
    SystemMouseCursors.resizeLeftRight,
    'Drag to resize horizontally',
  );
  
  static const DashboardCursorState resizeVertical = DashboardCursorState(
    SystemMouseCursors.resizeUpDown,
    'Drag to resize vertically',
  );
  
  static const DashboardCursorState resizeTopRight = DashboardCursorState(
    SystemMouseCursors.resizeUpRightDownLeft,
    'Drag to resize diagonally',
  );
  
  static const DashboardCursorState resizeTopLeft = DashboardCursorState(
    SystemMouseCursors.resizeUpLeftDownRight,
    'Drag to resize diagonally',
  );
  
  static const DashboardCursorState none = DashboardCursorState(
    MouseCursor.defer,
    '',
  );
  
  // Additional states for more specific guidance
  static const DashboardCursorState hover = DashboardCursorState(
    SystemMouseCursors.click,
    'Click to select item',
  );
  
  static const DashboardCursorState delete = DashboardCursorState(
    SystemMouseCursors.disappearing,
    'Item will be deleted',
  );
  
  static const DashboardCursorState locked = DashboardCursorState(
    SystemMouseCursors.forbidden,
    'Item is locked and cannot be moved',
  );
  
  static const DashboardCursorState edit = DashboardCursorState(
    SystemMouseCursors.text,
    'Click to edit content',
  );
  
  // Mobile-specific touch states
  static const DashboardCursorState mobileTouch = DashboardCursorState(
    MouseCursor.defer,
    'Tap and hold to interact',
  );
  
  static const DashboardCursorState mobileDrag = DashboardCursorState(
    MouseCursor.defer,
    'Drag to move item',
  );
  
  static const DashboardCursorState mobileResize = DashboardCursorState(
    MouseCursor.defer,
    'Drag to resize',
  );
  
  // Helper method to get mobile-friendly version of a cursor state
  static DashboardCursorState getMobileVersion(DashboardCursorState desktopState) {
    if (desktopState == grab) {
      return mobileDrag;
    } else if (desktopState == resizeHorizontal || 
               desktopState == resizeVertical ||
               desktopState == resizeTopLeft ||
               desktopState == resizeTopRight) {
      return mobileResize;
    } else {
      return mobileTouch;
    }
  }
}
