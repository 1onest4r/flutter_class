import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PaintingDemo extends StatefulWidget {
  const PaintingDemo({super.key});

  @override
  State<PaintingDemo> createState() => _PaintingDemoState();
}

class _PaintingDemoState extends State<PaintingDemo> {
  // 1. Define our interactive points
  Offset p0 = const Offset(0, 0); // Start point
  Offset c1 = const Offset(50, 200); // Control point 1
  Offset p1 = const Offset(100, 100); // Middle point
  Offset c2 = const Offset(150, 50); // Control point 2
  Offset p2 = const Offset(200, 200); // End point

  int? _draggedPointIndex; // Keep track of which point is being dragged
  double _drawProgress = 1.0; // Controls the curve animation (0.0 to 1.0)

  void _onPanStart(DragStartDetails details) {
    final touchPosition = details.localPosition;
    final points = [p0, c1, p1, c2, p2];

    // Find the closest point to the touch location (within a 40 pixel radius)
    for (int i = 0; i < points.length; i++) {
      if ((points[i] - touchPosition).distance < 40.0) {
        setState(() {
          _draggedPointIndex = i;
        });
        break;
      }
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_draggedPointIndex != null) {
      setState(() {
        // Clamp the coordinates to keep them inside our 300x300 box
        final dx = details.localPosition.dx.clamp(0.0, 300.0);
        final dy = details.localPosition.dy.clamp(0.0, 300.0);
        final newPos = Offset(dx, dy);

        switch (_draggedPointIndex) {
          case 0:
            p0 = newPos;
            break;
          case 1:
            c1 = newPos;
            break;
          case 2:
            p1 = newPos;
            break;
          case 3:
            c2 = newPos;
            break;
          case 4:
            p2 = newPos;
            break;
        }
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    _draggedPointIndex = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Interactive Bezier Points')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              // 2. Wrap in GestureDetector to capture dragging
              child: GestureDetector(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: CustomPaint(
                    size: const Size(300, 300),
                    painter: MyPainter(
                      p0: p0,
                      c1: c1,
                      p1: p1,
                      c2: c2,
                      p2: p2,
                      progress: _drawProgress,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 3. Single slider to animate the bezier drawing
          Container(
            padding: const EdgeInsets.all(24.0),
            color: Colors.grey[100],
            child: Row(
              children: [
                const Text(
                  'Draw Animation:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Slider(
                    value: _drawProgress,
                    min: 0.0,
                    max: 1.0,
                    onChanged: (val) {
                      setState(() {
                        _drawProgress = val;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final Offset p0, c1, p1, c2, p2;
  final double progress;

  MyPainter({
    required this.p0,
    required this.c1,
    required this.p1,
    required this.c2,
    required this.p2,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Optional: Draw thin guiding lines connecting points to control points
    final guidePaint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 1;
    canvas.drawLine(p0, c1, guidePaint);
    canvas.drawLine(c1, p1, guidePaint);
    canvas.drawLine(p1, c2, guidePaint);
    canvas.drawLine(c2, p2, guidePaint);

    // Build the full path
    final fullPath = Path()
      ..moveTo(p0.dx, p0.dy)
      ..quadraticBezierTo(c1.dx, c1.dy, p1.dx, p1.dy)
      ..quadraticBezierTo(c2.dx, c2.dy, p2.dx, p2.dy);

    final pathPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    // 4. Animate drawing the path based on the slider progress
    if (progress >= 1.0) {
      canvas.drawPath(fullPath, pathPaint);
    } else if (progress > 0.0) {
      final metrics = fullPath.computeMetrics();
      final drawPath = Path();
      for (final metric in metrics) {
        // Extract a subpath representing a percentage of the total length
        drawPath.addPath(
          metric.extractPath(0.0, metric.length * progress),
          Offset.zero,
        );
      }
      canvas.drawPath(drawPath, pathPaint);
    }

    // 5. Draw the points
    final pointMode = ui.PointMode.points;

    // Main anchor points in Yellow
    final anchorPoints = [p0, p1, p2];
    final paintAnchors = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(pointMode, anchorPoints, paintAnchors);

    // Control points in Red
    final controlPoints = [c1, c2];
    final paintControls = Paint()
      ..color = Colors.red
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(pointMode, controlPoints, paintControls);
  }

  @override
  bool shouldRepaint(covariant MyPainter old) {
    return old.p0 != p0 ||
        old.c1 != c1 ||
        old.p1 != p1 ||
        old.c2 != c2 ||
        old.p2 != p2 ||
        old.progress != progress;
  }
}

// --------------------------------------------------------
// Custom Render Objects below are kept unchanged
// --------------------------------------------------------

class ProgressBar extends LeafRenderObjectWidget {
  const ProgressBar({
    super.key,
    required this.barColor,
    required this.thumbColor,
    this.thumbSize = 20.0,
  });

  final Color barColor;
  final Color thumbColor;
  final double thumbSize;

  @override
  RenderProgressBar createRenderObject(BuildContext context) {
    return RenderProgressBar(
      barColor: barColor,
      thumbColor: thumbColor,
      thumbSize: thumbSize,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderProgressBar renderObject,
  ) {
    renderObject
      ..barColor = barColor
      ..thumbColor = thumbColor
      ..thumbSize = thumbSize;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('barColor', barColor));
    properties.add(ColorProperty('thumbColor', thumbColor));
    properties.add(DoubleProperty('thumbSize', thumbSize));
  }
}

class RenderProgressBar extends RenderBox {
  RenderProgressBar({
    required Color barColor,
    required Color thumbColor,
    required double thumbSize,
  }) : _barColor = barColor,
       _thumbColor = thumbColor,
       _thumbSize = thumbSize {
    // initialize the gesture recognizer
    _drag = HorizontalDragGestureRecognizer()
      ..onStart = (DragStartDetails details) {
        _updateThumbPosition(details.localPosition);
      }
      ..onUpdate = (DragUpdateDetails details) {
        _updateThumbPosition(details.localPosition);
      };
  }

  void _updateThumbPosition(Offset localPosition) {
    var dx = localPosition.dx.clamp(0, size.width);
    _currentThumbValue = dx / size.width;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  Color get barColor => _barColor;
  Color _barColor;
  set barColor(Color value) {
    if (_barColor == value) return;
    _barColor = value;
    markNeedsPaint();
  }

  Color get thumbColor => _thumbColor;
  Color _thumbColor;
  set thumbColor(Color value) {
    if (_thumbColor == value) return;
    _thumbColor = value;
    markNeedsPaint();
  }

  double get thumbSize => _thumbSize;
  double _thumbSize;
  set thumbSize(double value) {
    if (_thumbSize == value) return;
    _thumbSize = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final desiredWidth = constraints.maxWidth;
    final desiredHeight = thumbSize;
    final desiredSize = Size(desiredWidth, desiredHeight);
    return constraints.constrain(desiredSize);
  }

  static const _minDesiredWidth = 100.0;

  @override
  double computeMinIntrinsicWidth(double height) => _minDesiredWidth;

  @override
  double computeMaxIntrinsicWidth(double height) => _minDesiredWidth;

  @override
  double computeMinIntrinsicHeight(double width) => thumbSize;

  @override
  double computeMaxIntrinsicHeight(double width) => thumbSize;

  double _currentThumbValue = 0.5;

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    // paint bar
    final barPaint = Paint()
      ..color = barColor
      ..strokeWidth = 5;
    final point1 = Offset(0, size.height / 2);
    final point2 = Offset(size.width, size.height / 2);
    canvas.drawLine(point1, point2, barPaint);

    // paint thumb
    final thumbPaint = Paint()..color = thumbColor;
    final thumbDx = _currentThumbValue * size.width;
    final center = Offset(thumbDx, size.height / 2);
    canvas.drawCircle(center, thumbSize / 2, thumbPaint);
    canvas.restore();
  }

  late HorizontalDragGestureRecognizer _drag;

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent) {
      _drag.addPointer(event);
    }
  }
}
