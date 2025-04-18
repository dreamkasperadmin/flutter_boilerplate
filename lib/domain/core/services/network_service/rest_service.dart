import 'dart:typed_data';

import 'package:http/http.dart' as http;

class RESTService {
  static Future<http.Response> performPOSTRequest({
    required String httpUrl,
    bool isAuth = false,
    String contentType = 'application/json',
    String? body,
    String token = '',
    Map<String, String>? header,
    Map<String, String> param = const {},
  }) async {
    if (param.isNotEmpty) {
      httpUrl += paramParser(param: param);
    }

    final request = http.Request('POST', Uri.parse(httpUrl));
    final Map<String, String> headers = {'Content-Type': contentType};
    if (isAuth && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
      if (header != null) {
        headers.addAll(header);
      }
    }
    if (body != null) {
      request.body = body;
    }
    request.followRedirects = false;
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final resultResponse = await http.Response.fromStream(response);
      return resultResponse;
    } else {
      final resultResponse = await http.Response.fromStream(response);
      throw resultResponse;
    }
   }

  // static Future<http.Response> performPUTRequest({
  //   required String httpUrl,
  //   bool isAuth = false,
  //   String contentType = 'application/json',
  //   String? body,
  //   String token = '',
  //   Uint8List? bodyBites,
  //   Map<String, String>? header,
  //   Map<String, String> param = const {},
  // }) async {
  //   if (param.isNotEmpty) {
  //     httpUrl += paramParser(param: param);
  //   }

  //   final request = http.Request('PUT', Uri.parse(httpUrl));
  //   final Map<String, String> headers = {'Content-Type': contentType};
  //   if (isAuth && token.isNotEmpty) {
  //     headers['Authorization'] = 'Bearer $token';
  //     if (header != null) {
  //       headers.addAll(header);
  //     }
  //   }
  //   if (body != null) {
  //     request.body = body;
  //   }
  //    if (bodyBites != null) {
  //     request.bodyBytes = bodyBites;
  //   }

  //   request.followRedirects = false;
  //   request.headers.addAll(headers);

  //   http.StreamedResponse response = await request.send();

  //   if (response.statusCode == 200) {
  //     final resultResponse = await http.Response.fromStream(response);
  //     return resultResponse;
  //   } else {
  //     final resultResponse = await http.Response.fromStream(response);
  //     throw resultResponse;
  //   }
  // }

    static Future<http.Response> performPUTRequest({
    required String httpUrl,
    bool isAuth = false,
    String contentType = 'application/json',
    String? body,
    Uint8List? bodyBites,
    Map<String, String>? header,
    Map<String, String> param = const {},
    String token = '',
  }) async {
    if (param.isNotEmpty) {
      httpUrl += paramParser(param: param);
    }

    final request = http.Request('PUT', Uri.parse(httpUrl));
    final Map<String, String> headers = header ??
        {
          'Content-Type': contentType,
        };
   if (isAuth && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
      if (header != null) {
        headers.addAll(header);
      }
    }
    if (body != null) {
      request.body = body;
    }

    if (bodyBites != null) {
      request.bodyBytes = bodyBites;
    }

    request.followRedirects = false;
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final resultResponse = await http.Response.fromStream(response);
      return resultResponse;
    } else {
      final resultResponse = await http.Response.fromStream(response);
      throw resultResponse;
    }
  }

  static Future<http.Response> performDELETERequest({
    required String httpUrl,
    bool isAuth = false,
    String contentType = 'application/json',
    String token = '',
    Map<String, String>? header,
    Map<String, String> param = const {},
    String? body,
  }) async {
    if (param.isNotEmpty) {
      httpUrl += paramParser(param: param);
    }

    final request = http.Request('DELETE', Uri.parse(httpUrl));
    final Map<String, String> headers = {'Content-Type': contentType};
    if (isAuth && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
      if (header != null) {
        headers.addAll(header);
      }
    }
    if (body != null) {
      request.body = body;
    }
    request.followRedirects = false;
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final resultResponse = await http.Response.fromStream(response);
      return resultResponse;
    } else {
      final resultResponse = await http.Response.fromStream(response);
      throw resultResponse;
    }
  }

  static Future<http.Response> performGETRequest({
    required String httpUrl,
    bool isAuth = false,
    String token = '',
    Map<String, String>? header,
    Map<String, String> param = const {},
  }) async {
    if (param.isNotEmpty) {
      httpUrl += paramParser(param: param);
    }

    final request = http.Request('GET', Uri.parse(httpUrl));
    final Map<String, String> headers = {'Access-Control-Allow-Origin': '*'};
    if (isAuth) {
      headers['Authorization'] = 'Bearer $token';
      if (header != null) {
        headers.addAll(header);
      }
    }

    request.followRedirects = false;
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final resultResponse = await http.Response.fromStream(response);
      return resultResponse;
    } else {
      final resultResponse = await http.Response.fromStream(response);
      throw resultResponse;
    }
  }

  static String paramParser({required Map<String, String> param}) {
    String parameter = '';
    for (String key in param.keys) {
      if (parameter.contains('?')) {
        parameter +=
            param[key] == null || param[key] == 'null' || param[key] == ''
                ? ''
                : '&$key=${param[key]}';
      } else {
        parameter +=
            param[key] == null || param[key] == 'null' || param[key] == ''
                ? ''
                : '?$key=${param[key]}';
      }
    }
    return parameter;
  }
}
