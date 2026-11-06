import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/api/subdl_api/api_key/api_key.dart';
import 'package:movies_app/api/subdl_response/subdl_subtitle.dart';
import 'package:path_provider/path_provider.dart';
class SubdlApiService {
  SubdlApiService({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  static const String _baseUrl =
      'https://api.subdl.com/api/v1';

  static const String _downloadBaseUrl =
      'https://dl.subdl.com';

  static final String _apiKey = ApiKey.subDlApiKey;

  Future<List<SubdlSubtitle>> searchSubtitles({
    required String title,
    required int year,
    String? imdbId,
    required String language,
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception('SubDL API key is missing.');
    }

    if ((imdbId == null || imdbId.isEmpty) && title.trim().isEmpty) {
      throw Exception('Movie title or IMDb ID is required.');
    }

    final queryParameters = <String, String>{
      'api_key': _apiKey,
      'type': 'movie',
      'languages': language,
      'subs_per_page': '30',
    };

    if (imdbId != null && imdbId.isNotEmpty) {
      queryParameters['imdb_id'] = imdbId;
    } else {
      queryParameters['film_name'] = title;

      if (year > 0) {
        queryParameters['year'] = year.toString();
      }
    }

    final uri = Uri.parse('$_baseUrl/subtitles').replace(
      queryParameters: queryParameters,
    );

    final response = await _client.get(uri).timeout(
      const Duration(seconds: 20),
    );

    if (response.statusCode != 200) {
      throw HttpException(
        'Subtitle search failed: ${response.statusCode}',
      );
    }

    final Map<String, dynamic> json;

    try {
      json = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw Exception('Invalid response received from SubDL.');
    }

    if (json['status'] != true) {
      throw Exception(
        json['error']?.toString() ?? 'Subtitle search failed.',
      );
    }

    final subtitles = json['subtitles'] as List<dynamic>? ?? [];

    return subtitles
        .whereType<Map<String, dynamic>>()
        .map(SubdlSubtitle.fromJson)
        .where((subtitle) => subtitle.downloadUrl.isNotEmpty)
        .toList();
  }

  Future<String> downloadSubtitle(
      SubdlSubtitle subtitle,
      ) async {
    final uri = Uri.parse(_downloadBaseUrl).resolve(
      subtitle.downloadUrl,
    );

    final response = await _client.get(uri).timeout(
      const Duration(seconds: 30),
    );

    if (response.statusCode != 200) {
      throw HttpException(
        'Subtitle download failed: ${response.statusCode}',
      );
    }

    final directory = await getApplicationSupportDirectory();

    final subtitleDirectory = Directory(
      '${directory.path}/subtitles',
    );

    await subtitleDirectory.create(recursive: true);

    final bytes = response.bodyBytes;

    final isZip = bytes.length >= 2 &&
        bytes[0] == 0x50 &&
        bytes[1] == 0x4B;

    if (!isZip) {
      final outputFile = File(
        '${subtitleDirectory.path}/subtitle_'
            '${DateTime.now().microsecondsSinceEpoch}.srt',
      );

      await outputFile.writeAsBytes(bytes, flush: true);

      return outputFile.path;
    }

    final decodedArchive = ZipDecoder().decodeBytes(bytes);

    final subtitleFiles = decodedArchive.files.where((file) {
      return file.isFile &&
          file.name.toLowerCase().endsWith('.srt');
    }).toList();

    if (subtitleFiles.isEmpty) {
      throw Exception('No SRT file found in the downloaded archive.');
    }

    final selectedFile = subtitleFiles.first;

    final outputFile = File(
      '${subtitleDirectory.path}/subtitle_'
          '${DateTime.now().microsecondsSinceEpoch}.srt',
    );

    await outputFile.writeAsBytes(
      selectedFile.content as List<int>,
      flush: true,
    );

    return outputFile.path;
  }

  void dispose() {
    _client.close();
  }
}