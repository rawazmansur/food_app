// import 'package:cloud_firestore/cloud_firestore.dart';

// class StoryModel {
//   String id;
//   final String imageUrl;
//   String text;
//   Timestamp timestamp;
//   int likes;
//   int views;

//   StoryModel({
//     required this.id,
//     this.imageUrl = '',
//     required this.text,
//     required this.timestamp,
//     required this.likes,
//     required this.views,
//   });

//   factory StoryModel.fromMap(String id, Map<String, dynamic> map) {
//     return StoryModel(
//       id: id,
//       imageUrl: map['imageUrl'] ?? '',
//       text: map['text'],
//       timestamp: map['timestamp'],
//       likes: map['likes'],
//       views: map['views'],
//     );
//   }

//   Map<String, dynamic> toMap() => {
//     'text': text,
//     'imageUrl': imageUrl,
//     'timestamp': timestamp,
//     'likes': likes,
//     'views': views,
//   };
// }
