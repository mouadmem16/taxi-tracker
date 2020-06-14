import 'dart:io';
import 'dart:convert';

class ApiClient {
  static String endpoint = 'customers.tripsfinders.com';

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'X-localization': 'en',
  };

  ApiClient([String lang]) {
    if (lang != null) {
      headers['X-localization'] = lang;
    }
  }

  get(String path, [Map<String, String> queryParameters]) async {
  //  _authorization();
    var httpClient = new HttpClient();
    var uri = new Uri.https(endpoint, path, queryParameters);
    var request = await httpClient.getUrl(uri);
    headers.forEach((name, value) {
      request.headers.set(name, value);
    });
    return await request.close();
  }

  post(String path, [Map<String, String> queryParameters]) async {
//    _authorization();
    var httpClient = new HttpClient();
    var uri = new Uri.https(endpoint, path, queryParameters);
    var request = await httpClient.postUrl(uri);
    headers.forEach((name, value) {
      request.headers.set(name, value);
    });
    request.add(utf8.encode(json.encode(queryParameters)));

    var response = await request.close();
    var res=await response.transform(utf8.decoder).join();
//    print(queryParameters);
//    print(response.statusCode);
//    print(res);
    var body = json.decode(res);
    switch (response.statusCode) {
      case 200:
        return body;
        break;
      case 422:
      case 401:
      case 400:
        print(body);
        throw ("Error Code:401\n" + "Error Message :\n" + body['message']);
        break;
      case 500:
        print(body);
        throw ("Error Code:500\n" + "Error Message :\n" + body['message']);
        break;
    }
  }
}
