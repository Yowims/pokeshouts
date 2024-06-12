class PokepediaImageDTO {
  final String source;
  final int height;
  final int width;

  PokepediaImageDTO({required this.source, required this.height, required this.width});

  factory PokepediaImageDTO.fromJson(Map<String, dynamic> json) {
    return PokepediaImageDTO(source: json['source'], height: json['height'], width: json['width']);
  }
}
