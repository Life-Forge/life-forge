import 'dart:convert';

String mapListToJsonString(List<Map<String, dynamic>> data) {
  return jsonEncode(data);
}

// Convert JSON string back to List<Map> when retrieving from DB
List<Map<String, dynamic>> jsonStringToMapList(String jsonString) {
  if (jsonString.isEmpty) return [];
  return List<Map<String, dynamic>>.from(jsonDecode(jsonString));
}