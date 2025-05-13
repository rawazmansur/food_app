class topicModel {
  final int id;
  final int discussionId;
  final String topic;
  final String content;

  topicModel({
    required this.id,
    required this.discussionId,
    required this.topic,
    required this.content,
  });

  factory topicModel.fromJson(Map<String, dynamic> json) {
    return topicModel(
      // Ensure the 'id' and 'discussion_id' are properly cast to 'int'
      id: json['id'] is int ? json['id'] : int.parse(json['id'] as String),
      discussionId: json['discussion_id'] is int
          ? json['discussion_id']
          : int.parse(json['discussion_id'] as String),
      topic: json['topic'] as String,
      content: json['content'] as String,
    );
  }
}
