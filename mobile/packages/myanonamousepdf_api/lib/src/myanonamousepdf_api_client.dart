import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:myanonamousepdf_api/myanonamousepdf_api.dart';
import 'package:myanonamousepdf_api/src/models/book.dart';
import 'package:myanonamousepdf_api/src/models/book_upload.dart';
import 'package:myanonamousepdf_api/src/models/tokens.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http_interceptor/http_interceptor.dart';

typedef DownloadProgress = void Function(
    int toal, int downloaded, double progress);

class MyanonamousepdfApiClient {
  MyanonamousepdfApiClient({http.Client? httpClient})
      : _httpClientt = httpClient ?? http.Client();

  final _httpClient = InterceptedClient.build(
    interceptors: [AuthorizationInterceptor()],
    retryPolicy: ExpiredTokenRetryPolicy(),
  );
  final box = GetStorage();

  //static String _baseUrlApi = "http://localhost:8080/";
  //static String _baseUrlApi = "http://10.0.2.2:8080/";
  static String _baseUrlApi = "http://192.168.0.159:8080/";

  final http.Client _httpClientt;

  String getToken() {
    JwtUserResponse user =
        JwtUserResponse.fromJson(jsonDecode(box.read("CurrentUser")));
    return user.token;
  }

  String getRefreshToken() {
    JwtUserResponse user =
        JwtUserResponse.fromJson(jsonDecode(box.read("CurrentUser")));
    return user.refreshToken;
  }

  Future<Tokens> refreshToken() async {
    JwtUserResponse user =
        JwtUserResponse.fromJson(jsonDecode(box.read("CurrentUser")));

    dynamic response = await http.Client().post(
      Uri.parse(_baseUrlApi + 'refreshtoken'),
      body: jsonEncode({"refreshToken": user.refreshToken}),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
    );

    if (response.statusCode == 403) {
      throw AuthenticationException("Your session has expired");
    }
    Tokens tokens = Tokens.fromJson(jsonDecode(_response(response)));

    JwtUserResponse newUser = JwtUserResponse(
        token: tokens.token,
        refreshToken: tokens.refreshToken,
        id: user.id,
        userName: user.userName,
        fullName: user.fullName,
        avatar: user.avatar,
        createdAt: user.createdAt);

    box.write('CurrentUser', jsonEncode(newUser.toJson()));

    return tokens;
  }

  Future<dynamic> post(String url, dynamic body) async {
    print(_baseUrlApi + url);
    final uri = Uri.parse(_baseUrlApi + url);

    final postResponse = await http.post(uri,
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

    final postResponse = await http.get(
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
    try {
      final getResponse = await _httpClient.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer " + token,
        },
      );

      print('getAuth status code: ' + getResponse.statusCode.toString());
      return getResponse.statusCode == 404 ? [] : _response(getResponse);
    } on AuthenticationException {
      rethrow;
    }
  }

  Future<dynamic> postAuth(
      String url, dynamic body, String token, String refreshToken) async {
    print(_baseUrlApi + url);
    final uri = Uri.parse(_baseUrlApi + url);
    print(body);

    try {
      final postResponse =
          await _httpClient.post(uri, body: jsonEncode(body), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer " + token,
      });

      return _response(postResponse);
    } on AuthenticationException {
      rethrow;
    }
  }

  Future<dynamic> putAuth(String url, String token, String refreshToken) async {
    print(_baseUrlApi + url);
    final uri = Uri.parse(_baseUrlApi + url);

    try {
      final postResponse = await _httpClient.put(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer " + token,
        },
      );

      print(postResponse.statusCode);
      return postResponse;
    } on AuthenticationException {
      rethrow;
    }
  }

  Future<void> downloadFile(
      String url, String token, String refreshToken, String bookName) async {
    try {
      final response = await _httpClient.get(
        Uri.parse(_baseUrlApi + url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
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
    } on AuthenticationException {
      rethrow;
    }
  }

  Future<Book> upload(
      BookUpload book, File file, String token, String refreshTokens) async {
    print(file.path);

    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${token}'
    };

    Uri uri = Uri.parse(_baseUrlApi + 'book/upload/json');

    try {
      final postResponse = await _httpClient
          .post(uri, body: jsonEncode(book.toJson()), headers: {
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
        request.headers["Authorization"] = "Bearer " + token;

        var response = await request.send();
        print(response.statusCode);

        if (response.statusCode == 401 || response.statusCode == 403) {
          await refreshToken();

          String newToken = getToken();

          String body = responseBody.toString().replaceAll('"', '');
          uri = Uri.parse('${_baseUrlApi}book/upload/file/${body}');
          var request = http.MultipartRequest('POST', uri);
          request.files.add(await http.MultipartFile.fromPath('file', file.path,
              contentType: MediaType('application', 'pdf')));
          request.headers["Authorization"] = "Bearer " + newToken;

          var response = await request.send();
          print(response.statusCode);
        }

        if (response.statusCode == 401 || response.statusCode == 403) {
          throw AuthenticationException("Your session has expired");
        }

        final responseData =
            json.decode((await http.Response.fromStream(response)).body);

        return Book.fromJson(responseData);
      }
      if (postResponse.statusCode == 401 || postResponse.statusCode == 403) {
        throw AuthenticationException("Your session has expired");
      }
      throw UploadException("There was an error uploading the book");
    } on AuthenticationException {
      rethrow;
    }
  }

  Future<dynamic> uploadImage(
      String url, File file, String token, String refreshTokens) async {
    print(file.path);
    print('MediaType: ' +
        MediaType.parse(
                lookupMimeType(file.path.split('.').last.toLowerCase())!)
            .toString());

    try {
      Uri uri = Uri.parse(_baseUrlApi + url);
      var request = http.MultipartRequest('PUT', uri);
      request.files.add(await http.MultipartFile.fromPath('file', file.path,
          contentType: MediaType.parse(
              lookupMimeType(file.path.split('.').last.toLowerCase())!)));
      request.headers["Authorization"] = "Bearer " + token;

      var response = await request.send();
      print(response.statusCode);

      dynamic responseData =
          json.decode((await http.Response.fromStream(response)).body);

      if (response.statusCode == 401 || response.statusCode == 403) {
        await refreshToken();

        String newToken = getToken();

        uri = Uri.parse(_baseUrlApi + url);
        var request = http.MultipartRequest('POST', uri);
        request.files.add(await http.MultipartFile.fromPath('file', file.path,
            contentType: MediaType.parse(
                lookupMimeType(file.path.split('.').last.toLowerCase())!)));
        request.headers["Authorization"] = "Bearer " + newToken;

        var response = await request.send();
        print(response.statusCode);

        responseData =
            json.decode((await http.Response.fromStream(response)).body);
      }

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw AuthenticationException("Your session has expired");
      }

      return responseData;
    } on AuthenticationException {
      rethrow;
    }
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

// 1 Interceptor class
class AuthorizationInterceptor implements InterceptorContract {
  // We need to intercept request
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      final box = GetStorage();
      // Fetching token from your locacl data
      var token = JwtUserResponse.fromJson(jsonDecode(box.read("CurrentUser")));

      // Clear previous header and update it with updated token
      if (data.headers.containsKey('Authorization')) {
        data.headers.remove('Authorization');

        data.headers['Authorization'] = 'Bearer ' + token.token!;
      }
    } catch (e) {
      print(e);
    }

    return data;
  }

  // Currently we do not have any need to intercept response
  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }
}

//2 Retry Policy
//This is where request retry
class ExpiredTokenRetryPolicy extends RetryPolicy {
  //Number of retry
  @override
  int maxRetryAttempts = 2;

  @override
  Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
    //This is where we need to update our token on 401 response
    if (response.statusCode == 401 || response.statusCode == 403) {
      //Refresh your token here. Make refresh token method where you get new token from
      //API and set it to your local data
      await MyanonamousepdfApiClient()
          .refreshToken(); //Find bellow the code of this function
      return true;
    }
    return false;
  }
}

//3 API Class where we have request methods
class ApiBaseHelper {
  //Setting up your client with interceptors
  static final client = InterceptedClient.build(
    interceptors: [AuthorizationInterceptor()],
  );
}
