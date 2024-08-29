part of '../dashboard_base.dart';

class _EditModeBackgroundPainter extends CustomPainter {
  _EditModeBackgroundPainter(
      {required this.offset,
      required this.slotEdge,
      required this.verticalSlotEdge,
      required this.slotCount,
      required this.viewportDelegate,
      this.fillPosition,
      required this.lines,
      this.style = const EditModeBackgroundStyle()});

  _ViewportDelegate viewportDelegate;

  final bool lines;

  Rect? fillPosition;

  double offset;

  double slotEdge, verticalSlotEdge;

  int slotCount;

  BoxConstraints get constraints => viewportDelegate.resolvedConstrains;

  double get mainAxisSpace => viewportDelegate.mainAxisSpace;

  double get crossAxisSpace => viewportDelegate.crossAxisSpace;

  EditModeBackgroundStyle style;

  void drawVerticalLines(Canvas canvas) {
    if (!lines) {
      return;
    }

    var horizontalLinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = style.lineColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = style.lineWidth;
    var sY = -0.0 - (offset.clamp(0, 100)) - (style.dualLineHorizontal ? mainAxisSpace / 2 : 0);
    var eY = constraints.maxHeight + 100;
    for (var i in List.generate(slotCount + 1, (index) => index)) {
      if (i == 0) {
        canvas.drawLine(Offset(0, sY), Offset(0, eY), horizontalLinePaint);
      } else if (i == slotCount) {
        var x = slotEdge * slotCount;
        canvas.drawLine(Offset(x, sY), Offset(x, eY), horizontalLinePaint);
      } else {
        if (style.dualLineVertical) {
          var l = (slotEdge * i) - crossAxisSpace / 2;
          var r = (slotEdge * i) + crossAxisSpace / 2;
          canvas.drawLine(Offset(l, sY), Offset(l, eY), horizontalLinePaint);
          canvas.drawLine(Offset(r, sY), Offset(r, eY), horizontalLinePaint);
        } else {
          var x = (slotEdge * i);
          canvas.drawLine(Offset(x, sY), Offset(x, eY), horizontalLinePaint);
        }
      }
    }
  }

  void drawHorizontals(Canvas canvas) {
    if (!lines) {
      return;
    }

    var horizontalLinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = style.lineColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = style.lineWidth;
    var max = constraints.maxHeight;
    var i = 0;
    var s = offset % verticalSlotEdge;
    while (true) {
      var y = (i * verticalSlotEdge) - s;
      if (y > max) {
        break;
      }

      if (style.dualLineHorizontal) {
        var t = y - mainAxisSpace / 2;
        var b = y + mainAxisSpace / 2;
        canvas.drawLine(Offset(0, t), Offset(constraints.maxWidth, t), horizontalLinePaint);
        canvas.drawLine(Offset(0, b), Offset(constraints.maxWidth, b), horizontalLinePaint);
      } else {
        canvas.drawLine(Offset(0, y), Offset(constraints.maxWidth, y), horizontalLinePaint);
      }

      i++;
    }
  }

  void drawBlocks(Canvas canvas, Size size) {
    // Define the padding between blocks
    double padding = style.blockPadding;

    // Define the radius for each block
    const Radius blockRadius = Radius.circular(8);

    // Get the current scroll offset
    double scrollOffset = offset;

    // Calculate the starting point for blocks considering the scroll offset
    int startRow = (scrollOffset / verticalSlotEdge).floor();

    // Draw the filled blocks with padding and a border radius
    for (int i = 0; i < slotCount; i++) {
      for (int j = startRow; j <= startRow + (size.height / verticalSlotEdge).ceil(); j++) {
        // Calculate the position of the block with padding
        double left = i * slotEdge + padding / 2;
        double top = j * verticalSlotEdge - scrollOffset + padding / 2;
        double blockWidth = slotEdge - padding;
        double blockHeight = verticalSlotEdge - padding;

        // Create the Rect for the block
        Rect blockRect = Rect.fromLTWH(left, top, blockWidth, blockHeight);

        // Create an RRect with the specified border radius
        RRect roundedBlock = RRect.fromRectAndRadius(blockRect, blockRadius);

        // Draw the filled block with the rounded corners and padding
        Paint blockPaint = Paint()..color = style.emptyItemBgColor;
        canvas.drawRRect(roundedBlock, blockPaint);
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (style.showBlocks) drawBlocks(canvas, size);
    if (style.showVerticleLine) drawVerticalLines(canvas);
    if (style.showHorizontalLine) drawHorizontals(canvas);
    if (fillPosition != null) {
      var path = Path()
        ..moveTo(fillPosition!.left + style.outherRadius, fillPosition!.top)
        ..lineTo(fillPosition!.right - style.outherRadius, fillPosition!.top)
        ..arcToPoint(
            Offset(fillPosition!.right, fillPosition!.top + style.outherRadius),
            radius: Radius.circular(style.outherRadius))
        ..lineTo(fillPosition!.right, fillPosition!.bottom - style.outherRadius)
        ..arcToPoint(
            Offset(
                fillPosition!.right - style.outherRadius, fillPosition!.bottom),
            radius: Radius.circular(style.outherRadius))
        ..lineTo(fillPosition!.left + style.outherRadius, fillPosition!.bottom)
        ..arcToPoint(
            Offset(
                fillPosition!.left, fillPosition!.bottom - style.outherRadius),
            radius: Radius.circular(style.outherRadius))
        ..lineTo(fillPosition!.left, fillPosition!.top + style.outherRadius)
        ..arcToPoint(
            Offset(fillPosition!.left + style.outherRadius, fillPosition!.top),
            radius: Radius.circular(style.outherRadius))
        ..close();

      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.fill
          ..color = style.fillColor,
      );
    }
  }

  @override
  bool shouldRepaint(_EditModeBackgroundPainter oldDelegate) {
    return true;
  }

  @override
  bool shouldRebuildSemantics(_EditModeBackgroundPainter oldDelegate) {
    return true;
  }
}
