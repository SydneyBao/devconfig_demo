import 'dart:io';
import 'dart:convert';

void main() async {
  final port = 8080;
  final host = '127.0.0.1';

  final server = await HttpServer.bind(host, port);
  print('Dart backend server listening on http://$host:$port');

  await for (HttpRequest request in server) {
    try {
      // Corrected: Check for '/' instead of '' for the root path
      if (request.uri.path == '/') {
        request.response.headers.contentType = ContentType.text;
        request.response.write('Slashes are not necessary!');
      } else if (request.uri.path == '/dart/hello') {
        request.response.headers.contentType = ContentType.text;
        request.response.write('Hello from Dart Backend!');
      } else if (request.uri.path == '/data') {
        request.response.headers.contentType = ContentType.json;
        final jsonData = {
          'message': 'This is some data from the backend!',
          'items': [
            {'id': 1, 'name': 'Item A'},
            {'id': 3, 'name': 'Item C'},
          ],
          'timestamp': DateTime.now().toIso8601String(),
        };
        request.response.write(jsonEncode(jsonData));
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
