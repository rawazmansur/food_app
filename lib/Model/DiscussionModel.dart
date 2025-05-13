class DiscussionModel {
  final int id;
  final String title;
  final String? content;

  DiscussionModel({required this.id, required this.title, this.content});

  // Adjust the fromJson method to handle type conversions if needed
  factory DiscussionModel.fromJson(Map<String, dynamic> json) {
    return DiscussionModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'] as String),  // Ensure id is an integer
      title: json['title'] as String,
      content: json['content'] as String?,
    );
  }
}
