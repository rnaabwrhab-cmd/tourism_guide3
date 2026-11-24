class Attraction {
  final String title;
  final String location;
  final String description;
  final String image;

  Attraction({
    required this.title,
    required this.location,
    required this.description,
    required this.image,
  });

  Map<String, dynamic> toMap() => {
        'title': title,
        'location': location,
        'description': description,
        'image': image,
      };

  factory Attraction.fromMap(Map<String, dynamic> map) => Attraction(
        title: map['title'] as String? ?? '',
        location: map['location'] as String? ?? '',
        description: map['description'] as String? ?? '',
        image: map['image'] as String? ?? '',
      );
}
