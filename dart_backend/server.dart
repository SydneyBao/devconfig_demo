import 'dart:io';
import 'dart:convert';

void main() async {
  final port = 8080;
  final host = '127.0.0.1';

  final server = await HttpServer.bind(host, port);
  print('Dart backend server listening on http://$host:$port');

  await for (HttpRequest request in server) {
    try {
      if (request.uri.path == '/') {
        request.response.headers.contentType = ContentType.text;
        request.response.write('Rewrite: true works!');
      } else if (request.uri.path == '/data') {
        request.response.headers.contentType = ContentType.json;
        final jsonData = {
          'message':
              'This is some data from http://$host:$port${request.uri.path}',
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
