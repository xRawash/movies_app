class SubdlSubtitle {
  final String name;
  final String releaseName;
  final String language;
  final String downloadUrl;
  final String format;
  final bool hearingImpaired;

  const SubdlSubtitle({
    required this.name,
    required this.releaseName,
    required this.language,
    required this.downloadUrl,
    required this.format,
    required this.hearingImpaired,
  });

  factory SubdlSubtitle.fromJson(Map<String, dynamic> json) {
    return SubdlSubtitle(
      name: json['name']?.toString() ?? 'Subtitle',
      releaseName: json['release_name']?.toString() ?? '',
      language: json['language']?.toString() ?? '',
      downloadUrl: json['url']?.toString() ?? '',
      format: json['format']?.toString() ?? 'srt',
      hearingImpaired: json['hi'] == true,
    );
  }
}