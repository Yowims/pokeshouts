class PokepediaImageDTO {
  final String source;
  final double height;
  final double width;

  PokepediaImageDTO({required this.source, required this.height, required this.width});

  factory PokepediaImageDTO.fromJson(Map<String, dynamic> json) {
    return PokepediaImageDTO(
      source: json['source'],
      height: (json['height'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
    );
  }
}
