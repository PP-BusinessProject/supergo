import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:resilify/resilify_websocket.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../api/api.dart' show API;
import '../../generated/env.g.dart';

part 'api.g.dart';

/// The provider of the [Dio] client.
@Riverpod(keepAlive: true)
Dio dio(Ref ref) => throw UnimplementedError();

/// The provider of the [API].
@Riverpod(keepAlive: true)
API api(Ref ref) => throw UnimplementedError();

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
