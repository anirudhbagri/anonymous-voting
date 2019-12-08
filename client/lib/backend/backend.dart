import 'package:http/http.dart' as http;

class Backend {
  static Future<http.Response> ping(String server) {
    var url = 'http://' + server + '/ping';
    print(url);
    return http.get(url);
  }

  static Future<http.Response> getVotes(String server) {
    var url = 'http://' + server + '/votes';
    return http.get(url);
  }

  static Future<http.Response> updateYes(String server) {
    var url = 'http://' + server + '/updateyes';
    return http.get(url);
  }

  static Future<http.Response> updateNo(String server) {
    var url = 'http://' + server + '/updateno';
    return http.get(url);
  }

  static Future<http.Response> resetVotes(String server) {
    var url = 'http://' + server + '/reset';
    return http.get(url);
  }
}
