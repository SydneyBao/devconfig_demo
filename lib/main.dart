import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Combined Flutter Proxy Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _responseText = 'Press a button to fetch data via proxy.';
  bool _isLoading = false;

  Future<void> _makeRequest(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? body,
  }) async {
    setState(() {
      _isLoading = true;
      _responseText = 'Making $method request to $path...';
    });

    try {
      final Uri uri = Uri.parse(path);
      http.Response response;

      if (method == 'POST') {
        response = await http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        );
      } else {
        response = await http.get(uri);
      }

      if (response.statusCode == 200) {
        String formattedBody;
        try {
          final decoded = json.decode(response.body);
          formattedBody = const JsonEncoder.withIndent('  ').convert(decoded);
        } catch (e) {
          formattedBody = response.body;
        }
        setState(() {
          _responseText =
              'Response from $path (Status: ${response.statusCode}):\n$formattedBody';
        });
      } else {
        print('Response status code: ${response.statusCode}');
        setState(() {
          _responseText =
              'Failed to load data from $path: ${response.statusCode}\n${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _responseText = 'Error during request to $path: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Proxy Test')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.only(bottom: 20.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                constraints: const BoxConstraints(
                  minHeight: 120,
                  maxHeight: 300,
                ),
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Text(_responseText, textAlign: TextAlign.left),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () => _makeRequest('/api/users/123'),
                        child: const Text(
                          'Fetch /api/users/123 without rewrite.',
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () => _makeRequest(
                                '/api/submit',
                                method: 'POST',
                                body: {'name': 'Flutter User', 'value': 42},
                              ),
                        child: const Text('POST /api/submit'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () => _makeRequest('/users/456/profile/summary'),
                        child: const Text(
                          'Fetch /users/456/profile/summary. Replacing with remainder.',
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () => _makeRequest('/dart/hello'),
                        child: const Text('Fetch /dart/hello with rewrite.'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () => _makeRequest('/users/1'),
                        child: const Text('Fetch /users/1 without replace.'),
                      ),
                      const SizedBox(height: 10),
                      // ElevatedButton(
                      //   onPressed: _isLoading
                      //       ? null
                      //       : () =>
                      //             _makeRequest('/api/jsonplaceholder/posts/5'),
                      //   child: const Text(
                      //     'Fetch /api/jsonplaceholder/posts/5 (Regex Proxy)',
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
