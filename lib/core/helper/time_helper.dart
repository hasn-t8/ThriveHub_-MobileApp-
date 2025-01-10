// lib/helpers/time_helper.dart
String calculateTimeAgo(String? createdAt) {
  if (createdAt == null || createdAt.isEmpty) {
    return 'Some time ago';
  }
  DateTime parsedDate = DateTime.parse(createdAt);
  DateTime now = DateTime.now();
  Duration difference = now.difference(parsedDate);

  if (difference.inDays > 0) {
    return '${difference.inDays} day${difference.inDays != 1 ? 's' : ''}';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hour${difference.inHours != 1 ? 's' : ''}';
  } else {
    return '${difference.inMinutes} minute${difference.inMinutes != 1 ? 's' : ''}';
  }
}
