part of dashboard;

class DashboardItemWidget<T extends DashboardItem> extends InheritedWidget {
  const DashboardItemWidget({required this.item, required super.child, super.key});

  final DashboardItem item;

  static DashboardItemWidget<T> of<T extends DashboardItem>(BuildContext context) {
    final DashboardItemWidget? result =
        context.dependOnInheritedWidgetOfExactType<DashboardItemWidget>();
    assert(result != null, 'No DashboardItemWidget found in context');
    return result! as DashboardItemWidget<T>;
  }

  @override
  bool updateShouldNotify(covariant DashboardItemWidget oldWidget) {
    return oldWidget.item.identifier != item.identifier;
  }
}

class _DashboardItemWidget extends StatefulWidget {
  const _DashboardItemWidget({
    required Key key,
    required this.layoutController,
    required this.child,
    required this.editModeSettings,
    required this.id,
    required this.itemCurrentLayout,
    required this.itemGlobalPosition,
    required this.offset,
    required this.style,
    required this.onCursorUpdate,
    required this.isDraggingNotifier,
  }) : super(key: key);

  final _ItemCurrentLayout itemCurrentLayout;
  final Widget child;
  final String id;
  final _DashboardLayoutController layoutController;
  final EditModeSettings editModeSettings;
  final ItemCurrentPosition itemGlobalPosition;
  final ViewportOffset offset;
  final ItemStyle style;
  final Function(MouseCursor cursor) onCursorUpdate;
  final ValueNotifier<bool> isDraggingNotifier;

  @override
  State<_DashboardItemWidget> createState() => _DashboardItemWidgetState();
}

class _DashboardItemWidgetState extends State<_DashboardItemWidget> with TickerProviderStateMixin {
  late MouseCursor cursor;
  DashboardCursorState _cursorState = DashboardCursorState.none;

  // late double leftPad, rightPad, topPad, bottomPad;

  @override
  void dispose() {
    _animationController.dispose();
    _multiplierAnimationController.dispose();
    widget.itemCurrentLayout.removeListener(_listen);
    super.dispose();
  }

  void _listen() {
    setState(() {});
  }

  late AnimationController _multiplierAnimationController;

  @override
  void initState() {
    cursor = MouseCursor.defer;
    _cursorState = DashboardCursorState.none;
    _animationController =
        AnimationController(vsync: this, duration: widget.editModeSettings.duration);
    _multiplierAnimationController =
        AnimationController(vsync: this, value: 0, duration: widget.editModeSettings.duration);
    widget.itemCurrentLayout.addListener(_listen);
    super.initState();
  }

  ItemCurrentPosition? get _resizePosition => widget.itemCurrentLayout._resizePosition?.value;

  bool onRightSide(double dX) =>
      dX >
      (widget.itemGlobalPosition.width + (_resizePosition?.width ?? 0)) -
          widget.editModeSettings.resizeCursorSide;

  bool onLeftSide(double dX) =>
      (dX + (_resizePosition?.x ?? 0)) < widget.editModeSettings.resizeCursorSide;

  bool onTopSide(double dY) =>
      (dY + (_resizePosition?.y ?? 0)) < widget.editModeSettings.resizeCursorSide;

  bool onBottomSide(double dY) =>
      dY >
      (widget.itemGlobalPosition.height + (_resizePosition?.height ?? 0)) -
          widget.editModeSettings.resizeCursorSide;

  void _hover(PointerHoverEvent hover) {
    // Get the cursor state without recreating objects to reduce GC pressure
    var newCursorState = _determineCursor(hover.localPosition);
    
    // Only update if either cursor or message changed to avoid unnecessary setState calls
    final cursorChanged = cursor != newCursorState.cursor;
    final messageChanged = _cursorState.message != newCursorState.message;
    
    if (cursorChanged || messageChanged) {
      // Update cursor state immediately
      _cursorState = newCursorState;
      cursor = newCursorState.cursor;
      
      // Update cursor message immediately without waiting for next frame
      widget.layoutController.updateCursorMessage?.call(_cursorState.message);
      
      // Only call setState if cursor changed (visual update needed)
      if (cursorChanged) {
        setState(() {
          widget.onCursorUpdate(cursor);
        });
      } else {
        // If only message changed, update cursor without setState
        widget.onCursorUpdate(cursor);
      }
    }
  }

  DashboardCursorState _determineCursor(Offset localPosition) {
    var x = localPosition.dx;
    var y = localPosition.dy;
    var r = onRightSide(x);
    var l = onLeftSide(x);
    var t = onTopSide(y);
    var b = onBottomSide(y);
    
    if (r) {
      if (b) {
        return DashboardCursorState.resizeTopLeft;
      } else if (t) {
        return DashboardCursorState.resizeTopRight;
      } else {
        return DashboardCursorState.resizeHorizontal;
      }
    } else if (l) {
      if (b) {
        return DashboardCursorState.resizeTopRight;
      } else if (t) {
        return DashboardCursorState.resizeTopLeft;
      } else {
        return DashboardCursorState.resizeHorizontal;
      }
    } else if (b || t) {
      return DashboardCursorState.resizeVertical;
    } else {
      return DashboardCursorState.grab;
    }
  }

  void _exit(PointerExitEvent exit) {
    if (!widget.isDraggingNotifier.value) {
      // Only update if we're actually changing state
      final cursorChanged = cursor != MouseCursor.defer;
      final messageChanged = _cursorState.message.isNotEmpty;
      
      _cursorState = DashboardCursorState.none;
      cursor = MouseCursor.defer;
      
      // Update message immediately
      if (messageChanged) {
        widget.layoutController.updateCursorMessage?.call('');
      }
      
      // Only call setState if cursor changed
      if (cursorChanged) {
        setState(() {});
      }
      
      widget.onCursorUpdate(cursor);
    }
  }

  Offset transform = Offset.zero;

  Offset? panStart;

  double scrollOffset = 0;

  double startScrollOffset = 0;

  _ItemCurrentLayout get l => widget.itemCurrentLayout;

  double get slotEdge => widget.layoutController.slotEdge;

  ItemCurrentPosition? ex;

  late AnimationController _animationController;
  Animation<ItemCurrentPosition>? _animation;

  Offset? _lastTransform;
  ItemCurrentPosition? _lastPosition;

  Future<void> _setLast(Offset? lastOffset, ItemCurrentPosition? lastPosition) async {
    _lastTransform = lastOffset;
    _lastPosition = lastPosition;
    _multiplierAnimationController.reset();
    _multiplierAnimationController.value = 1;
    await _multiplierAnimationController
        .animateTo(0,
            duration: widget.editModeSettings.duration, curve: widget.editModeSettings.curve)
        .then((value) {
      setState(() {
        _lastTransform = null;
        _lastPosition = null;
      });
    });
  }

  bool get onEditMode => widget.layoutController.isEditing;

  ItemLayout? _exLayout;

  bool equal() {
    return _exLayout!.startX == widget.itemCurrentLayout.startX &&
        _exLayout!.startY == widget.itemCurrentLayout.startY &&
        _exLayout!.width == widget.itemCurrentLayout.width &&
        _exLayout!.height == widget.itemCurrentLayout.height;
  }

  bool onAnimation = false;
  DateTime? animationStart;

  @override
  Widget build(BuildContext context) {
    Widget result = widget.child;

    if (onEditMode) {
      if (widget.layoutController.absorbPointer) {
        result = AbsorbPointer(child: result);
      }

      // Use a platform-aware approach for cursor/touch interactions
      result = _buildInteractiveWrapper(result, context);
    }

    var currentEdit =
        widget.layoutController.editSession?.editing.id == widget.itemCurrentLayout.id;

    var transform = currentEdit ? widget.layoutController.editSession!.transform : false;

    var onlyDimensions = currentEdit && transform;

    if (onAnimation ||
        ((currentEdit ? transform : true) &&
            (onEditMode || widget.layoutController.animateEverytime) &&
            ex != null &&
            (widget.itemCurrentLayout._change))) {
      widget.itemCurrentLayout._change = false;

      if (onAnimation) {
        ex = _animation!.value;

        var difMicro =
            (widget.editModeSettings.duration - (DateTime.now().difference(animationStart!).abs()))
                .inMicroseconds;
        _animationController.duration = Duration(
            microseconds: difMicro.clamp(0, widget.editModeSettings.duration.inMicroseconds));
      } else {
        animationStart = DateTime.now();
        onAnimation = true;
      }
      _animationController.reset();

      _animation =
          CurvedAnimation(parent: _animationController, curve: widget.editModeSettings.curve).drive(
              _ItemCurrentPositionTween(
                  begin: onlyDimensions
                      ? ItemCurrentPosition(
                          height: ex!.height,
                          width: ex!.width,
                          y: widget.itemGlobalPosition.y,
                          x: widget.itemGlobalPosition.x)
                      : ex!,
                  end: widget.itemGlobalPosition,
                  onlyDimensions: onlyDimensions));

      _animationController.forward().then((value) {
        onAnimation = false;
        animationStart = null;
        _animationController.duration = widget.editModeSettings.duration;
        _animation = null;
        widget.itemCurrentLayout._change = false;
        ex = widget.itemGlobalPosition;
      });
    } else {
      ex = widget.itemGlobalPosition;
      widget.itemCurrentLayout._change = false;
    }
    if (!onEditMode && !widget.layoutController.animateEverytime) {
      var cp = widget.itemGlobalPosition;
      return Positioned(
        left: cp.x,
        top: cp.y - widget.offset.pixels,
        width: cp.width,
        height: cp.height,
        child: result,
      );
    }

    return AnimatedBuilder(
      animation: Listenable.merge([
        if (widget.itemCurrentLayout._resizePosition != null)
          widget.itemCurrentLayout._resizePosition,
        if (widget.itemCurrentLayout._transform != null) widget.itemCurrentLayout._transform,
        if (_animation != null) _animation,
        if (onEditMode) _multiplierAnimationController,
      ]),
      child: result,
      builder: (c, w) {
        var m = _multiplierAnimationController.value;

        var p = widget.itemCurrentLayout._resizePosition?.value;

        var cp = onAnimation
            ? (_animation?.value ?? widget.itemGlobalPosition)
            : widget.itemGlobalPosition;

        if (p != null) {
          if (_lastPosition != null) {
            p = _lastPosition! * m;
          }
          cp += p;
        }
        double left = cp.x, top = cp.y;

        var o = widget.itemCurrentLayout._transform?.value;

        if (o != null) {
          if (_lastTransform != null) {
            o = _lastTransform! * m;
          }
          left += o.dx;
          top += o.dy;
        }

        return Positioned(
          left: left,
          top: top - widget.offset.pixels,
          width: cp.width,
          height: cp.height,
          child: w!,
        );
      },
    );
  }

  // Build the appropriate interactive wrapper based on platform
  Widget _buildInteractiveWrapper(Widget child, BuildContext context) {
    final bool isMobile = _isMobileDevice();
    
    // Always add gesture detector for touch interactions
    Widget result = GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onLongPress: _handleLongPress,
      onLongPressEnd: _handleLongPressEnd,
      // Add pan gesture support for mobile dragging with a minimum drag distance threshold
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      // Change from opaque to deferToChild to allow events to reach children
      behavior: HitTestBehavior.deferToChild,
      // Add drag threshold to differentiate between normal taps and drags
      dragStartBehavior: DragStartBehavior.down,
      child: child,
    );
    
    // Add MouseRegion only on desktop platforms
    if (!isMobile) {
      result = MouseRegion(
        cursor: cursor,
        onHover: _hover,
        onExit: _exit,
        child: result,
      );
    }
    
    return result;
  }

  // Helper method to detect if we're on a mobile device
  bool _isMobileDevice() {
    try {
      // In web or when dart:io is available
      return defaultTargetPlatform == TargetPlatform.iOS || 
             defaultTargetPlatform == TargetPlatform.android;
    } catch (e) {
      // Fall back to a simpler check if TargetPlatform isn't available
      return false;
    }
  }

  // Mobile touch handlers
  void _handleTapDown(TapDownDetails details) {
    // Only process in edit mode
    if (!widget.layoutController.isEditing) return;
    
    final tapPosition = details.localPosition;
    var desktopCursorState = _determineCursor(tapPosition);
    
    // Get the mobile-friendly version of the cursor state
    var mobileCursorState = DashboardCursorState.getMobileVersion(desktopCursorState);
    
    // Update cursor state and message for this interaction
    _cursorState = mobileCursorState;
    widget.layoutController.updateCursorMessage?.call(mobileCursorState.message);
  }

  void _handleTapUp(TapUpDetails details) {
    // Only process in edit mode
    if (!widget.layoutController.isEditing) return;
    
    // Clear message when tap is released without long press
    widget.layoutController.updateCursorMessage?.call('');
  }

  void _handleLongPress() {
    // Only process in edit mode
    if (!widget.layoutController.isEditing) return;
    
    // Provide haptic feedback when long pressing on mobile
    if (_isMobileDevice()) {
      HapticFeedback.mediumImpact();
    }
    
    // While holding, show active message
    if (_cursorState == DashboardCursorState.mobileDrag) {
      widget.layoutController.updateCursorMessage?.call("Drag to move item");
    } else if (_cursorState == DashboardCursorState.mobileResize) {
      widget.layoutController.updateCursorMessage?.call("Drag to resize");
    } else {
      widget.layoutController.updateCursorMessage?.call("Tap and hold to interact");
    }
  }

  void _handleLongPressEnd(LongPressEndDetails details) {
    // Only process in edit mode
    if (!widget.layoutController.isEditing) return;
    
    // Clear message when long press ends
    widget.layoutController.updateCursorMessage?.call('');
  }

  // Mobile pan gesture handlers for drag/resize operations
  DashboardCursorState? _activeTouchState;
  Offset? _touchStartPosition;

  void _handlePanStart(DragStartDetails details) {
    // Only process in edit mode
    if (!widget.layoutController.isEditing) return;
    
    final touchPosition = details.localPosition;
    // First get the desktop cursor state that would apply at this position
    var desktopCursorState = _determineCursor(touchPosition);
    // Convert to the appropriate mobile cursor state
    _activeTouchState = DashboardCursorState.getMobileVersion(desktopCursorState);
    _touchStartPosition = touchPosition;
    
    // Provide haptic feedback when starting a drag on mobile
    if (_isMobileDevice()) {
      HapticFeedback.lightImpact();
    }
    
    // Show active dragging message
    widget.layoutController.updateCursorMessage?.call(_activeTouchState!.message);
    
    // Start drag or resize operation based on where the user touched
    if (_activeTouchState == DashboardCursorState.mobileDrag) {
      // Handle drag start for moving items
      widget.isDraggingNotifier.value = true;
      
      // Start the edit session for this item
      widget.layoutController.startEdit(widget.id, true);
      
      // Initialize transform for dragging
      transform = Offset.zero;
      panStart = details.localPosition;
      scrollOffset = widget.offset.pixels;
      startScrollOffset = scrollOffset;
    } else if (_activeTouchState == DashboardCursorState.mobileResize) {
      // Handle resize start
      widget.isDraggingNotifier.value = true;
      
      // Start the edit session for this item
      widget.layoutController.startEdit(widget.id, false);
      
      // Initialize for resizing
      panStart = details.localPosition;
    }
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    // Only process in edit mode
    if (!widget.layoutController.isEditing) return;
    
    // Only process if we have active touch state and panStart
    if (_activeTouchState != null && panStart != null) {
      // Calculate the drag distance
      final dragDistance = (details.localPosition - panStart!).distance;
      
      // Only consider it a drag if moved more than 5 pixels
      if (dragDistance > 5.0) {
        // For dragging operations, show a more specific message during the active drag
        if (_activeTouchState == DashboardCursorState.mobileDrag) {
          widget.layoutController.updateCursorMessage?.call("Dragging item - release to place");
        } else if (_activeTouchState == DashboardCursorState.mobileResize) {
          widget.layoutController.updateCursorMessage?.call("Resizing - release when done");
        }
      }
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    // Only process in edit mode
    if (!widget.layoutController.isEditing) return;
    
    // Provide haptic feedback when ending a drag on mobile
    if (_isMobileDevice()) {
      HapticFeedback.lightImpact();
    }
    
    // Reset touch state
    _activeTouchState = null;
    _touchStartPosition = null;
    panStart = null;
    transform = Offset.zero;
    
    // Clear message when drag ends
    widget.layoutController.updateCursorMessage?.call('');
    
    // End the drag/resize operation
    widget.isDraggingNotifier.value = false;
  }
}
