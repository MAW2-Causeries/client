class Guild {
  final String id;
  final String name;
  final String? description;

  const Guild({required this.id, required this.name, this.description});

  Guild copyWith({String? id, String? name, String? description}) {
    return Guild(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}
