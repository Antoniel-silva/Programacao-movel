import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Cria marcadores personalizados desenhados em tempo de execução.
abstract class MarkerHelper {
  MarkerHelper._();

  /// Escala usada para gerar imagens nítidas em telas de alta densidade.
  static const double _pixelScale = 3;

  /// Cria um marcador circular com [color] e o ícone [icon] ao centro.
  static Future<BitmapDescriptor> circleMarker({
    required IconData icon,
    required Color color,
    double size = 110,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.scale(_pixelScale);

    final center = Offset(size / 2, size / 2);
    final radius = size / 2 - 8;

    // Sombra suave atrás do círculo.
    final shadow = Paint()
      ..color = Colors.black.withValues(alpha: 0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawCircle(center.translate(0, 4), radius, shadow);

    // Círculo com borda branca.
    canvas.drawCircle(center, radius, Paint()..color = color);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6,
    );

    _paintGlyph(canvas, icon, center, size * 0.42, Colors.white);

    return _toDescriptor(recorder.endRecording(), size, size);
  }

  /// Cria um marcador em formato de rótulo (retângulo arredondado com o
  /// nome do local e um badge com o ícone da categoria), como no layout
  /// da tela de exploração.
  static Future<BitmapDescriptor> labelMarker({
    required String label,
    required IconData badgeIcon,
    required Color badgeColor,
    required Color backgroundColor,
    required Color borderColor,
    required Color textColor,
    double fontSize = 15,
    double maxWidth = 170,
    double badgeSize = 34,
  }) async {
    final textPainter = TextPainter(
      text: TextSpan(
        text: label.toUpperCase(),
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: textColor,
          height: 1.15,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    const sidePadding = 14.0;
    const topPadding = 12.0;
    const bottomPadding = 12.0;
    const badgeGap = 6.0;

    final width = math.max(textPainter.width + sidePadding * 2, 100.0);
    final height =
        topPadding + badgeSize + badgeGap + textPainter.height + bottomPadding;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.scale(_pixelScale);

    final rect = Rect.fromLTWH(0, 0, width, height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(18));

    // Sombra do rótulo.
    final shadow = Paint()
      ..color = Colors.black.withValues(alpha: 0.22)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawRRect(rrect, shadow);

    // Fundo e borda.
    canvas.drawRRect(rrect, Paint()..color = backgroundColor);
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Nome do local abaixo do badge.
    textPainter.paint(
      canvas,
      Offset(sidePadding, topPadding + badgeSize + badgeGap),
    );

    // Badge circular no canto superior direito.
    final badgeCenter = Offset(
      width - sidePadding - badgeSize / 2,
      topPadding + badgeSize / 2,
    );
    canvas.drawCircle(badgeCenter, badgeSize / 2, Paint()..color = badgeColor);
    canvas.drawCircle(
      badgeCenter,
      badgeSize / 2,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    _paintGlyph(canvas, badgeIcon, badgeCenter, badgeSize * 0.52, Colors.white);

    return _toDescriptor(recorder.endRecording(), width, height);
  }

  /// Desenha o glifo do [icon] centralizado em [center].
  static void _paintGlyph(
    Canvas canvas,
    IconData icon,
    Offset center,
    double fontSize,
    Color color,
  ) {
    final glyph = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    glyph.paint(canvas, center - Offset(glyph.width / 2, glyph.height / 2));
  }

  /// Converte o desenho em um [BitmapDescriptor] nítido.
  static Future<BitmapDescriptor> _toDescriptor(
    ui.Picture picture,
    double width,
    double height,
  ) async {
    final image = await picture.toImage(
      (width * _pixelScale).round(),
      (height * _pixelScale).round(),
    );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();

    if (byteData == null) return BitmapDescriptor.defaultMarker;

    return BitmapDescriptor.bytes(
      byteData.buffer.asUint8List(),
      imagePixelRatio: _pixelScale,
    );
  }
}
