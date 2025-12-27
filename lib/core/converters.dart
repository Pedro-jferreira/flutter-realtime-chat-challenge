import 'package:freezed_annotation/freezed_annotation.dart';

class EpochDateTimeConverter implements JsonConverter<DateTime, Object> {
  const EpochDateTimeConverter();

  @override
  DateTime fromJson(Object json) {
    if (json is int) {
      return DateTime.fromMillisecondsSinceEpoch(json);
    } else if (json is String) {
      return DateTime.tryParse(json) ?? DateTime.now();
    }
    return DateTime.now();
  }

  @override
  Object toJson(DateTime object) {
    return object.millisecondsSinceEpoch;
  }
}
