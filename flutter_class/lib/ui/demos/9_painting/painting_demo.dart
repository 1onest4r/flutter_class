import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class PaintingDemo extends StatefulWidget {
  const PaintingDemo({super.key});

  @override
  State<PaintingDemo> createState() => _PaintingDemoState();
}

class _PaintingDemoState extends State<PaintingDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          color: Colors.white,
          child: ProgressBar(
            barColor: Colors.blue,
            thumbColor: Colors.red,
            thumbSize: 20.0,
          ),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(70, 70)
      ..lineTo(140, 140)
      ..moveTo(140, 140)
      ..lineTo(210, 70)
      ..moveTo(210, 70)
      ..lineTo(210, 210)
      ..moveTo(210, 210)
      ..lineTo(70, 210)
      ..moveTo(70, 210)
      ..lineTo(70, 70);
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawPath(path, paint);
    final fillPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;
    canvas.drawShadow(path, fillPaint.color, 5.0, true);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}

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
      barColor: barColor,class ProgressBar extends LeafRenderObjectWidget {
  @override
  RenderProgressBar createRenderObject(...) {}
  @override
  void updateRenderObject(...) {}
  @override
  void debugFillProperties(...) {}
}
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
  })  : _barColor = barColor,
        _thumbColor = thumbColor,
        _thumbSize = thumbSize;

  Color get barColor => _barColor;
  Color _barColor;
  set barColor(Color value) {
    if (_barColor == value) 
      return;
    _barColor = value;
    markNeedsPaint();
  }

  Color get thumbColor => _thumbColor;
  Color _thumbColor;
  set thumbColor(Color value) {
    if (_thumbColor == value) 
      return;
    _thumbColor = value;
    markNeedsPaint();
  }

  double get thumbSize => _thumbSize;
  double _thumbSize;
  set thumbSize(double value) {
    if (_thumbSize == value) 
      return;
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
}
