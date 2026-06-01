import 'dart:convert';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:dio/dio.dart';
import 'package:resilify/resilify_websocket.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart' hide Field;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../generated/env.g.dart';

part 'api.g.dart';
part 'api.mapper.dart';

/// The provider of the [Dio] client.
@Riverpod(keepAlive: true)
Dio dio(Ref ref) => throw UnimplementedError();

/// The provider of the [API].
@Riverpod(keepAlive: true)
API api(Ref ref) => throw UnimplementedError();

@RestApi(parser: Parser.DartMappable)
abstract class API {
  factory API(Dio dio, {String? baseUrl}) = _API;

  @GET('/tasks')
  Future<List<Task>> getTasks();
}

@MappableClass()
class Task with TaskMappable {
  const Task({this.id, this.name, this.avatar, this.createdAt});

  final String? id;
  final String? name;
  final String? avatar;
  final String? createdAt;
}

void ws() {
  final WebSocketResultHandler<Map<String, Object?>> ws =
      WebSocketResultHandler<Map<String, Object?>>(
        channelFactory: () =>
            WebSocketChannel.connect(Uri.parse(Config.wsUrl)),
        parser: (Object? raw) =>
            jsonDecode(raw! as String) as Map<String, Object?>,
      );

  ws.stream.listen((Result<Map<String, Object?>> result) {
    result.when(
      success: (Map<String, Object?> msg) => print('event: $msg'),
      error: (Failure f) => print('ws error: ${f.message}'),
    );
  });
  ws.send(jsonEncode(<String, String>{'subscribe': 'ticker'}));
}
