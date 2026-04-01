class Channel {
  final String id;
  final String name;
  final String? description;
  final String type;

  const Channel({
    required this.id,
    required this.name,
    this.description,
    required this.type,
  });
}
