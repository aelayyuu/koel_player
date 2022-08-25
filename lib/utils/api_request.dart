import 'dart:convert';
import 'dart:io';

import 'package:koel_player/exceptions/http_response_exception.dart';
import 'package:koel_player/utils/preferences.dart' as preferences;
import 'package:http/http.dart' as http;

enum HttpMethod { get, post, patch, put, delete }

Future<dynamic> request(
  HttpMethod method,
  String path, {
  Object data = const {},
}) async {
  late http.Response response;

  Uri uri = Uri.parse('${preferences.apiBaseUrl}/$path');

  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
    HttpHeaders.acceptHeader: ContentType.json.mimeType,
    if (preferences.apiToken != null)
      HttpHeaders.authorizationHeader: 'Bearer ${preferences.apiToken}',
  };

  switch (method) {
    case HttpMethod.get:
      response = await http.get(uri, headers: headers);
      break;
    case HttpMethod.post:
      response = await http.post(
        uri,
        headers: headers,
        body: json.encode(data),
      );
      break;
    case HttpMethod.patch:
      response = await http.patch(
        uri,
        headers: headers,
        body: json.encode(data),
      );
      break;
    case HttpMethod.put:
      response = await http.put(
        uri,
        headers: headers,
        body: json.encode(data),
      );
      break;
    case HttpMethod.delete:
      response =
          await http.delete(uri, headers: headers, body: json.encode(data));
      break;
    default:
      throw ArgumentError.value(method);
  }

  switch (response.statusCode) {
    case 200:
      return json.decode(response.body);
    case 204:
      return;
    default:
      throw HttpResponseException.fromResponse(response);
  }
}

Future<dynamic> get(String path) async => request(HttpMethod.get, path);

Future<dynamic> post(String path, {Object data = const {}}) async =>
    request(HttpMethod.post, path, data: data);

Future<dynamic> patch(String path, {Object data = const {}}) async =>
    request(HttpMethod.patch, path, data: data);

Future<dynamic> put(String path, {Object data = const {}}) async =>
    request(HttpMethod.put, path, data: data);

Future<dynamic> delete(String path, {Object data = const {}}) async =>
    request(HttpMethod.delete, path, data: data);
