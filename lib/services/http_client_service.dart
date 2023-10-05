import 'package:http/http.dart' as http;

class HttpClientService {
  final String _baseUrl = 'http://192.168.1.182:5073/api/';

  Future<ResponseData> Predict(String content, String url) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse('${_baseUrl}$url'));
    request.headers.addAll(headers);
    request.body = content;
    var response = await http.Client().send(request);
    var responseBody = await response.stream.bytesToString();
    return ResponseData(response.statusCode, responseBody);
  }
}

class ResponseData {
  int statusCode;
  String body;

  ResponseData(this.statusCode, this.body);
}
