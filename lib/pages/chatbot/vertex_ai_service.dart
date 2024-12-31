// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class VertexAIService {
//   final String apiKey;

//   VertexAIService(this.apiKey);

//   Future<void> initializeGenerativeModel() async {
//     final url = 'https://vertexai.googleapis.com/v1/projects/proplanner-4c98b/locations/us-central1/models/gemini-1.5-flash-001';
//     final response = await http.post(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $apiKey',
//       },
//       body: json.encode({
//         'instances': [
//           {'input': 'Initialize model'}
//         ],
//       }),
//     );

//     if (response.statusCode != 200) {
//       throw Exception('Failed to initialize generative model');
//     }
//   }

//   Future<String> getPrediction(String inputText) async {
//     final url = 'https://vertexai.googleapis.com/v1/projects/proplanner-4c98b/locations/us-central1/models/gemini-1.5-flash-001';
//     final response = await http.post(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $apiKey',
//       },
//       body: json.encode({
//         'instances': [
//           {'input': inputText}
//         ],
//       }),
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       return data['predictions'][0]['output'];
//     } else {
//       throw Exception('Failed to get prediction');
//     }
//   }
// }