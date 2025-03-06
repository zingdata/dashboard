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
    var newCursorState = _determineCursor(hover.localPosition);
    if (cursor != newCursorState.cursor) {
      setState(() {
        _cursorState = newCursorState;
        cursor = newCursorState.cursor;
        widget.onCursorUpdate(cursor);
        // Notify about cursor state change if needed
        widget.layoutController.updateCursorMessage?.call(_cursorState.message);
      });
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
      setState(() {
        _cursorState = DashboardCursorState.none;
        cursor = MouseCursor.defer;
        widget.layoutController.updateCursorMessage?.call('');
      });
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
      result = MouseRegion(
        cursor: cursor,
        onHover: _hover,
        onExit: _exit,
        child: result,
      );
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
}
