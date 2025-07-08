import 'dart:io';
import 'dart:convert';

void main() async {
  final port = 8080;
  final host = '127.0.0.1';

  final server = await HttpServer.bind(host, port);
  print('Dart backend server listening on http://$host:$port');

  await for (HttpRequest request in server) {
    try {
      if (request.uri.path == '/hello') {
        request.response.headers.contentType = ContentType.text;
        request.response.write('Response from ${request.uri.path}: Hello!');
      } else if (request.uri.path == '/users/summary' ||
          request.uri.path == '/users/infoname/summary' ||
          request.uri.path == '/people/users/info') {
        request.response.write('Response from ${request.uri.path}!');
      } else {
        request.response.statusCode = HttpStatus.notFound;
        request.response.headers.contentType = ContentType.text;
        request.response.write('404 Not Found');
      }
    } catch (e) {
      print('Error handling request: $e');
      request.response.statusCode = HttpStatus.internalServerError;
      request.response.headers.contentType = ContentType.text;
      request.response.write('Internal Server Error');
    } finally {
      await request.response.close();
    }
  }
}
