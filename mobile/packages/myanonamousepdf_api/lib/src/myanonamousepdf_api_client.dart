import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:myanonamousepdf_api/src/models/book.dart';
import 'package:myanonamousepdf_api/src/models/bookCategory.dart';
import 'package:myanonamousepdf_api/src/models/book_upload.dart';
import 'package:path_provider/path_provider.dart';

typedef DownloadProgress = void Function(
    int toal, int downloaded, double progress);

class MyanonamousepdfApiClient {
  MyanonamousepdfApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  //static String _baseUrlApi = "http://localhost:8080/";
  //static String _baseUrlApi = "http://10.0.2.2:8080/";
  static String _baseUrlApi = "http://192.168.0.159:8080/";

  final http.Client _httpClient;

  Future<dynamic> post(String url, dynamic body) async {
    print(_baseUrlApi + url);
    final uri = Uri.parse(_baseUrlApi + url);

    final postResponse = await _httpClient.post(uri,
        body: jsonEncode(body),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        });

    return _response(postResponse);
  }

  Future<dynamic> get(String url) async {
    print(_baseUrlApi + url);
    final uri = Uri.parse(_baseUrlApi + url);

    final postResponse = await _httpClient.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
    );

    return _response(postResponse);
  }

  Future<dynamic> getAuth(String url, String token, String refreshToken) async {
    print(_baseUrlApi + url);
    final uri = Uri.parse(_baseUrlApi + url);

    final postResponse = await _httpClient.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "bearer " + token,
      },
    );

    return postResponse;
  }

  Future<void> downloadFile(
      String url, String token, String refreshToken, String bookName) async {
    final response = await http.get(
      Uri.parse(_baseUrlApi + url),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "bearer $token",
      },
    );
    final bytes = response.bodyBytes;
    final String downloadPath;
    if (Platform.isIOS) {
      downloadPath = await getApplicationDocumentsDirectory().toString();
    } else {
      downloadPath = '/storage/emulated/0/Download';
    }

    final file = File('$downloadPath/$bookName');
    await file.writeAsBytes(bytes);
  }

  static Future<Uint8List> download(
      String url, token, DownloadProgress downloadProgress) async {
    final completer = Completer<Uint8List>();
    final client = http.Client();
    final request = http.Request('GET', Uri.parse(url));
    request.headers.addAll({
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "bearer " + token,
    });
    final response = client.send(request);

    int downloadedBytes = 0;
    List<List<int>> chunkList = [];

    response.asStream().listen((http.StreamedResponse streamedResponse) {
      streamedResponse.stream.listen(
        (chunk) {
          final contentLength = streamedResponse.contentLength ?? 0;
          final progress = (downloadedBytes / contentLength) * 100;
          downloadProgress(contentLength, downloadedBytes, progress);

          chunkList.add(chunk);
          downloadedBytes += chunk.length;
        },
        onDone: () {
          final contentLength = streamedResponse.contentLength ?? 0;
          final progress = (downloadedBytes / contentLength) * 100;
          downloadProgress(contentLength, downloadedBytes, progress);

          int start = 0;
          final bytes = Uint8List(contentLength);

          for (var chunk in chunkList) {
            bytes.setRange(start, start + chunk.length, chunk);
          }

          completer.complete(bytes);
        },
        onError: (error) => completer.completeError(error),
      );
    });

    return completer.future;
  }

  Future<Book> upload(
      BookUpload book, File file, String token, String refreshToken) async {
    print(file.path);

    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${token}'
    };

    Uri uri = Uri.parse(_baseUrlApi + 'book/upload/json');

    final postResponse =
        await _httpClient.post(uri, body: jsonEncode(book.toJson()), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + token,
    });
    final responseBody = postResponse.body;

    if (postResponse.statusCode == 201) {
      String body = responseBody.toString().replaceAll('"', '');
      uri = Uri.parse('${_baseUrlApi}book/upload/file/${body}');
      var request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('file', file.path,
          contentType: MediaType('application', 'pdf')));

      var response = await request.send();

      final responseData =
          json.decode((await http.Response.fromStream(response)).body);

      return Book.fromJson(responseData);
    }
    throw UploadException("There was an error uploading the book");
  }

  dynamic _response(http.Response response) {
    //TODO comprobar donde se podruce la excepción cuando no hay internet
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        var responseJson = utf8.decode(response.bodyBytes);
        return responseJson /*as Map<String, dynamic>*/;
      case 201:
        var responseJson = utf8.decode(response.bodyBytes);
        return responseJson /*as Map<String, dynamic>*/;
      case 204:
        return;
      case 400:
        throw BadRequestException(utf8.decode(response.bodyBytes));
      case 401:
        throw AuthenticationException(utf8.decode(response.bodyBytes));
      case 403:
        throw UnauthorizedException(utf8.decode(response.bodyBytes));
      case 404:
        throw NotFoundException(utf8.decode(response.bodyBytes));
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  /*Future<JwtUserResponse> login(String auth) async {
    final loginRequest = Uri.http(
      _baseUrlApi,
      'auth/login',
      {},
    );

    final loginResponse = await _httpClient.post(loginRequest, body: auth);

    if (loginResponse.statusCode != 200) {
      throw LoginRequestFailure();
    }

    final jwtUserResponse = jsonDecode(loginResponse.body) as Map;

    return JwtUserResponse.fromJson(loginResponse as Map<String, dynamic>);
  }

  Future<JwtUserResponse> register(String auth) async {
    final registerRequest = Uri.http(
      _baseUrlApi,
      'auth/register',
      {},
    );

    final loginResponse = await _httpClient.post(registerRequest, body: auth);

    if (loginResponse.statusCode != 200) {
      throw RegisterRequestFailure();
    }

    final jwtUserResponse = jsonDecode(loginResponse.body) as Map;

    return JwtUserResponse.fromJson(loginResponse as Map<String, dynamic>);
  }*/
}

class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([String? message]) : super(message, "");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "");
}

class AuthenticationException extends CustomException {
  AuthenticationException([message]) : super(message, "");
}

class UnauthorizedException extends CustomException {
  UnauthorizedException([message]) : super(message, "");
}

class NotFoundException extends CustomException {
  NotFoundException([message]) : super(message, "");
}

class UploadException extends CustomException {
  UploadException([message]) : super(message, "");
}
