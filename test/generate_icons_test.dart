import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koins_savings_app/widgets/common/app_logo.dart';

void main() {
  test('Render and verify master launcher icons from OrigamiKPainter', () async {
    const size = 1024.0;

    // 1. Generate full square icon with crisp white background
    {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, size, size));

      // Draw pure white background
      final bgPaint = Paint()..color = Colors.white;
      canvas.drawRect(const Rect.fromLTWH(0, 0, size, size), bgPaint);

      // Draw Origami K centered
      const emblemSize = 720.0;
      const offset = (size - emblemSize) / 2;

      canvas.save();
      canvas.translate(offset, offset);
      const painter = OrigamiKPainter();
      painter.paint(canvas, const Size(emblemSize, emblemSize));
      canvas.restore();

      final picture = recorder.endRecording();
      final img = await picture.toImage(size.toInt(), size.toInt());
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      final buffer = byteData!.buffer.asUint8List();

      final file = File('assets/images/app_launcher_icon.png');
      await file.create(recursive: true);
      await file.writeAsBytes(buffer);
      expect(file.existsSync(), isTrue);
      expect(buffer.isNotEmpty, isTrue);
    }

    // 2. Generate transparent adaptive foreground icon (sized inside safe zone)
    {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, size, size));

      // Centered inside Android adaptive safe zone (~580px)
      const emblemSize = 580.0;
      const offset = (size - emblemSize) / 2;

      canvas.save();
      canvas.translate(offset, offset);
      const painter = OrigamiKPainter();
      painter.paint(canvas, const Size(emblemSize, emblemSize));
      canvas.restore();

      final picture = recorder.endRecording();
      final img = await picture.toImage(size.toInt(), size.toInt());
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      final buffer = byteData!.buffer.asUint8List();

      final file = File('assets/images/app_launcher_foreground.png');
      await file.create(recursive: true);
      await file.writeAsBytes(buffer);
      expect(file.existsSync(), isTrue);
      expect(buffer.isNotEmpty, isTrue);
    }

    // 3. Generate squircle app logo with smooth rounded corners for README and web
    {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, size, size));

      // Draw rounded rectangle background (Apple standard 22.5% radius = 230px)
      final rrect = RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, 0, size, size),
        const Radius.circular(225.0),
      );
      final bgPaint = Paint()..color = Colors.white;
      canvas.drawRRect(rrect, bgPaint);

      // Subtle hairline border
      final borderPaint = Paint()
        ..color = const Color(0xFFE5E7EB)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6.0;
      canvas.drawRRect(rrect, borderPaint);

      // Draw Origami K centered
      const emblemSize = 720.0;
      const offset = (size - emblemSize) / 2;

      canvas.save();
      canvas.translate(offset, offset);
      const painter = OrigamiKPainter();
      painter.paint(canvas, const Size(emblemSize, emblemSize));
      canvas.restore();

      final picture = recorder.endRecording();
      final img = await picture.toImage(size.toInt(), size.toInt());
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      final buffer = byteData!.buffer.asUint8List();

      final file = File('assets/images/app_logo.png');
      await file.create(recursive: true);
      await file.writeAsBytes(buffer);
      expect(file.existsSync(), isTrue);
      expect(buffer.isNotEmpty, isTrue);
    }
  });
}
