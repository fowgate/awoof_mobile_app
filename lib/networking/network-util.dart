import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// A network helper class to do all the back end request
class NetworkHelper{

  /// next three lines makes this class a Singleton
  static NetworkHelper _instance = new NetworkHelper.internal();
  NetworkHelper.internal();
  factory NetworkHelper() => _instance;

  /// An object for decoding json values
  final JsonDecoder _decoder = JsonDecoder();

  /// A function to do the login request with the url and headers
  /// then sends back a json decoded result
  Future<dynamic> postLogin (String url, {Map<String, String>? headers, body, encoding}) async {
    try {
      return http
          .post(Uri.parse(url), body: json.encode(body), headers: headers, encoding: encoding)
          .then((http.Response response) {
        final String res = response.body;
        final int statusCode = response.statusCode;
        var result = _decoder.convert(res);
        if (statusCode < 200 || statusCode > 400) {
          throw ("${result['message']}");
        }
        return _decoder.convert(res);
      });
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  /// A function to do any get request with the url and headers
  /// then sends back a json decoded result
  Future<dynamic> get(String url, {Map<String, String>? headers, body}) async {
    try {
      return
        http
            .get(Uri.parse(url), headers: headers)
            .then((http.Response response) {
          final String res = response.body;
          final int statusCode = response.statusCode;
          if (statusCode < 200 || statusCode > 400) {
            throw ("Error occurred, Please try again");
          }
          return _decoder.convert(res);
        });
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  /// A function to do any post request with the url and headers
  /// then sends back a json decoded result
  Future<dynamic> post(String url, {Map<String, String>? headers, body, encoding}) {
    try {
      return http
          .post(Uri.parse(url), body: json.encode(body), headers: headers, encoding: encoding)
          .then((http.Response response) {
        final String res = response.body;
        final int statusCode = response.statusCode;
        var result = _decoder.convert(res);
        if (statusCode < 200 || statusCode > 400) {
          throw ("${result['message']}");
        }
        return _decoder.convert(res);
      });
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  /// A function to do any post request of form data with the url and headers
  /// then sends back a json decoded result
  Future<dynamic> postForm(Uri url, List<http.MultipartFile>? files, {Map<String, String>? header, body, encoding}) async {
    try {
      var request = http.MultipartRequest('POST', url);
      if(header != null){
        request.headers.addAll(header);
      }
      if(body != null){
        request.fields.addAll(body);
      }
      if(files != null){
        request.files.addAll(files);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final int statusCode = response.statusCode;
      final dynamic res = json.decode(response.body);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw ("${res["message"]}");
      }
      return res;
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  /// A function to do any put request with the url and headers
  /// then sends back a json decoded result
  Future<dynamic> put(String url, {Map<String, String>? headers, body, encoding}) {
    try {
      return http
          .put(Uri.parse(url), body: json.encode(body), headers: headers, encoding: encoding)
          .then((http.Response response) {
        final String res = response.body;
        final int statusCode = response.statusCode;
        if (statusCode < 200 || statusCode > 400) {
          throw ("${_decoder.convert(res)["message"]}");
        }
        return _decoder.convert(res);
      });
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  /// A function to do any delete request with the url and headers
  /// then sends back a json decoded result
  Future<dynamic> delete(String url, {Map<String, String>? headers}) {
    try {
      return http
          .delete(Uri.parse(url), headers: headers)
          .then((http.Response response) {
        final String res = response.body;
        final int statusCode = response.statusCode;

        if (statusCode < 200 || statusCode > 400) {
          throw ("${_decoder.convert(res)["message"]}");
        }
        return _decoder.convert(res);
      });
    } catch (e) {
      print(e);
      throw (e);
    }
  }

}



