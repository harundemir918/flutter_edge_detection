import 'package:flutter/material.dart';

class DocumentOverlay extends StatelessWidget {
  final List<Offset> corners;
  final void Function(int index, Offset newPosition) onCornerMoved;

  const DocumentOverlay({
    super.key,
    required this.corners,
    required this.onCornerMoved,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(painter: DocumentPainter(corners)),
        ...List.generate(
          4,
          (i) => Positioned(
            left: corners[i].dx - 12,
            top: corners[i].dy - 12,
            child: GestureDetector(
              onPanUpdate: (details) {
                onCornerMoved(i, corners[i] + details.delta);
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DocumentPainter extends CustomPainter {
  final List<Offset> corners;
  DocumentPainter(this.corners);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.blueAccent
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;
    final path =
        Path()
          ..moveTo(corners[0].dx, corners[0].dy)
          ..lineTo(corners[1].dx, corners[1].dy)
          ..lineTo(corners[2].dx, corners[2].dy)
          ..lineTo(corners[3].dx, corners[3].dy)
          ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
