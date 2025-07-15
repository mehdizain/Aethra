import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ApiService
{
  static const String baseUrl="https://api.stability.ai/v2beta/stable-image/generate/core";
  static const String apiKey="sk-byOmZBSd3lOFCME4cAVQAzI1ajUSfuNgLkTjkTJEjumDHTr2";
  
  Future<Map<String, dynamic>> generateImage(
  {
    required String prompt,
    String mode="text-to-image",
    String aspectRatio="1:1"
  })async
  {
    try {
      final uri=Uri.parse(baseUrl);
      var request=http.MultipartRequest('POST',uri);
      request.headers.addAll({
        'Authorization':"Bearer ${apiKey}",
        'Accept':'application/json'
      });
      request.fields['prompt']=prompt;
      request.fields['mode']=mode;
      request.fields['aspect_ratio']=aspectRatio;
      
      print('Making API request with:');
      print('Prompt: $prompt');
      print('Mode: $mode');
      print('Aspect Ratio: $aspectRatio');
      
      final response=await request.send();
      final resString=await response.stream.bytesToString();
      
      print('API Response Status: ${response.statusCode}');
      
      if(response.statusCode==200) {
        try {
          final data=json.decode(resString);
          if (data['image'] != null) {
            final imageBytes= base64Decode(data['image']);
            return {
              'success': true,
              'data': imageBytes,
              'message': 'Image generated successfully'
            };
          } else {
            return {
              'success': false,
              'data': null,
              'message': 'No image data in response'
            };
          }
        } catch (e) {
          return {
            'success': false,
            'data': null,
            'message': 'Failed to parse response: $e'
          };
        }
      } else if (response.statusCode == 400) {
        return {
          'success': false,
          'data': null,
          'message': 'Bad request - Invalid parameters. Please check your input.'
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'data': null,
          'message': 'Unauthorized - Invalid API key'
        };
      } else if (response.statusCode == 429) {
        return {
          'success': false,
          'data': null,
          'message': 'Rate limit exceeded - Please wait before trying again'
        };
      } else if (response.statusCode == 500) {
        return {
          'success': false,
          'data': null,
          'message': 'Server error - Please try again later'
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': 'API Error (${response.statusCode}): $resString'
        };
      }
    } catch(err) {
      print('API Exception: $err');
      if (err.toString().contains('SocketException')) {
        return {
          'success': false,
          'data': null,
          'message': 'Network error - Please check your internet connection'
        };
      } else if (err.toString().contains('TimeoutException')) {
        return {
          'success': false,
          'data': null,
          'message': 'Request timeout - Please try again'
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': 'Unexpected error: $err'
        };
      }
    }
  }
  
}
