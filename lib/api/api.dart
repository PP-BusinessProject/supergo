import 'package:dart_mappable/dart_mappable.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart' hide Field;

part 'api.g.dart';
part 'api.mapper.dart';

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
