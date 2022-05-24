import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../configs/config.dart';

class BaseProvider {
  final client = http.Client();
  late http.Response response;
  final _timeOutDuration = 30;
  String bearer = '';

  late Map<String, String> queryParma;

  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: 'application/json;charset=utf-8'
  };

// headers
  Future<bool> setHeaders({Map<String, String>? header}) async {
    headers.addAll(header ?? {});
    return true;
  }

// query parameters

  Map<String, String> setQueryParameters({Map<String, String>? query}) {
    queryParma = {};
    queryParma.addAll(query ?? {});
    return queryParma;
  }

// response
  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response;

      case 400:
        throw BadRequestException(jsonDecode(jsonEncode(response.body)));
      // return response;

      case 401:
      case 403:
      case 404:
      case 409:
        // throw UnauthorizedException(jsonDecode(jsonEncode(response.body)));
        return response;

      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communicating with Server with StatusCode: ${response.statusCode}\nRESPONSE:${decodeResponse(response)}');
      // return response;
    }
  }

  Future<http.Response> request({
    required Requests method,
    required String path,
    Map<String, dynamic>? body,
    Map<String, String>? queryParameter,
    Map<String, String>? header,
  }) async {
    switch (method) {
      case Requests.get:
        response = await client
            .get(
              Uri.parse(path),
              headers: header ?? headers,
            )
            .timeout(Duration(seconds: _timeOutDuration));
        break;
      case Requests.post:
        response = await client
            .post(
              Uri.parse(path),
              headers: header ?? headers,
              body: jsonEncode(body ?? {}),
            )
            .timeout(Duration(seconds: _timeOutDuration));
        break;
      case Requests.delete:
        response = await client
            .delete(
              Uri.parse(path),
              headers: header ?? headers,
              body: jsonEncode(body ?? {}),
            )
            .timeout(Duration(seconds: _timeOutDuration));
        break;

      default:
        break;
    }

    return returnResponse(response);
  }

  //decodes response from string to json object
  dynamic decodeResponse(http.Response response) {
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
}
