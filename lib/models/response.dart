import 'package:cloud_firestore/cloud_firestore.dart';

class Response {
  String uniqueId;
  String comment;
  bool value;

  Response(this.uniqueId, this.value, this.comment);

  factory Response.fromSnapshot(DocumentSnapshot snapshot) {
    Response val = Response.fromJson(snapshot.data);
    return val;
  }
  factory Response.fromJson(Map<String, dynamic> json) => _responseFromJson(json);
  Map<String, dynamic> toJson() => _petToJson(this);
  @override
  String toString() => "Response<$uniqueId,$value,$comment>";
}

Response _responseFromJson(Map<String, dynamic> json) => Response(
      json['uniqueId'] as String,
      json['value'] as bool,
      json['comment'] as String,
    );

Map<String, dynamic> _petToJson(Response instance) => <String, dynamic>{
      'uniqueId': instance.uniqueId,
      'value': instance.value,
      'comment': instance.comment,
    };
