import 'dart:io';

import 'package:chewie/chewie.dart';

class SrtParser {
  static Future<List<Subtitle>> parseFile(String path) async {
    final file = File(path);

    if (!await file.exists()) {
      throw Exception('Subtitle file does not exist.');
    }

    final content = (await file.readAsString())
        .replaceAll('\r', '')
        .replaceFirst('\uFEFF', '');

    final blocks = content.split(RegExp(r'\n\s*\n'));

    final subtitles = <Subtitle>[];

    for (final block in blocks) {
      final lines = block.split('\n');

      final timeIndex = lines.indexWhere(
            (line) => line.contains('-->'),
      );

      if (timeIndex == -1) continue;

      final times = lines[timeIndex].split('-->');

      if (times.length != 2) continue;

      final start = _parseTime(times[0].trim());

      final end = _parseTime(
        times[1].trim().split(RegExp(r'\s+')).first,
      );

      if (start == null || end == null || end <= start) {
        continue;
      }

      final text = lines.skip(timeIndex + 1).join('\n').trim();

      if (text.isEmpty) continue;

      subtitles.add(
        Subtitle(
          index: subtitles.length,
          start: start,
          end: end,
          text: text,
        ),
      );
    }

    if (subtitles.isEmpty) {
      throw Exception('No valid subtitles found in the SRT file.');
    }

    return subtitles;
  }

  static Duration? _parseTime(String value) {
    final match = RegExp(
      r'^(\d{2}):(\d{2}):(\d{2})[,.](\d{3})$',
    ).firstMatch(value);

    if (match == null) return null;

    return Duration(
      hours: int.parse(match.group(1)!),
      minutes: int.parse(match.group(2)!),
      seconds: int.parse(match.group(3)!),
      milliseconds: int.parse(match.group(4)!),
    );
  }
}