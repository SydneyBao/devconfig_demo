//dart run server.dart

import 'dart:io';
import 'dart:convert';

void main() async {
  final port = 8080;
  final host = '127.0.0.1';

  final server = await HttpServer.bind(host, port);
  print('Dart backend server listening on http://$host:$port');

  await for (HttpRequest request in server) {
    try {
      if (request.uri.path == '/dart' || request.uri.path == '/dart/') {
        request.response.headers.contentType = ContentType.text;
        request.response.write('Slashes are not necessary!');
      } else if (request.uri.path == '/dart/hello') {
        request.response.headers.contentType = ContentType.text;
        request.response.write('Hello from Dart Backend!');
      } else if (request.uri.path == '/dart/data') {
        request.response.headers.contentType = ContentType.json;
        final jsonData = {
          'message': 'This is some data from the backend!',
          'items': [
            {'id': 1, 'name': 'Item A'},
            {'id': 2, 'name': 'Item B'},
            {'id': 3, 'name': 'Item C'},
          ],
          'timestamp': DateTime.now().toIso8601String(),
        };
        request.response.write(jsonEncode(jsonData));
      } else if (request.uri.path == '/dart/echo-body') {
        print(request.uri);
        String body = await utf8.decodeStream(
          request,
        ); // Read the entire body as a string

        print('Received request body:');
        print(body); // Print the raw body to the console

        // You can also try to parse it if it's JSON
        try {
          final parsedBody = jsonDecode(body);
          print('Parsed JSON body:');
          print(jsonEncode(parsedBody)); // Print prettified JSON
          // You could also send it back as a response:
          request.response.headers.contentType = ContentType.json;
          request.response.write(jsonEncode({'receivedBody': parsedBody}));
        } catch (e) {
          print('Body is not valid JSON. Sending raw body back.');
          request.response.headers.contentType = ContentType.text;
          request.response.write('Received your body: $body');
        }
        // --- END NEW ROUTE ---
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
