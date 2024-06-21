import 'dart:convert';

import 'package:http/http.dart' as http;


class Request {
  final String url;
  final dynamic body;
  final dynamic header;

  Request({required this.url, this.body, this.header});

  Future<http.Response> get() {
    return http
        .get(Uri.parse(url), headers: header)
        .timeout(const Duration(minutes: 2), onTimeout: () {
          return http.Response('Error', 500);
    });
  }

  Future<http.Response> post() {
    return http
        .post(Uri.parse(url),  headers: header, body: jsonEncode(body),)
        .timeout(const Duration(minutes: 2), onTimeout: () {
      return http.Response('Error', 500);
    });
  }

  http.MultipartRequest postMultipart() {
    return http.MultipartRequest('POST', Uri.parse(url));
  }
}