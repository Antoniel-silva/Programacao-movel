/// Ponto de encontro cadastrado pelo usuário no Petto.
class MeetingPoint {
  const MeetingPoint({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
  });

  /// Identificador único do ponto de encontro.
  final String id;

  /// Nome do ponto de encontro.
  final String name;

  /// Descrição do ponto de encontro.
  final String description;

  /// Endereço do ponto de encontro.
  final String address;

  /// Latitude do ponto de encontro.
  final double latitude;

  /// Longitude do ponto de encontro.
  final double longitude;

  /// Data de cadastro.
  final DateTime createdAt;

  /// Converte o ponto de encontro para JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Cria um ponto de encontro a partir de JSON.
  factory MeetingPoint.fromJson(Map<String, dynamic> json) {
    return MeetingPoint(
      id: json['id'] is String ? json['id'] as String : '',
      name: json['name'] is String ? json['name'] as String : '',
      description: json['description'] is String
          ? json['description'] as String
          : '',
      address: json['address'] is String ? json['address'] as String : '',
      latitude: json['latitude'] is num
          ? (json['latitude'] as num).toDouble()
          : 0,
      longitude: json['longitude'] is num
          ? (json['longitude'] as num).toDouble()
          : 0,
      createdAt: json['createdAt'] is String
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
