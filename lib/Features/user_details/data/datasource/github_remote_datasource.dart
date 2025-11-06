import 'package:dio/dio.dart';
import 'package:ini_labs_assignment/core/network/dio_client.dart';
import 'package:ini_labs_assignment/core/network/exception.dart';

abstract class GithubRemoteDataSource {
  Future<Map<String, dynamic>> getUser(String username);
  Future<List<dynamic>> getUserRepositories(String username);
}

class GithubRemoteDataSourceImpl implements GithubRemoteDataSource {
  final DioClient _dioClient;

  GithubRemoteDataSourceImpl(this._dioClient);

  @override
  Future<Map<String, dynamic>> getUser(String username) async {
    try {
      final response = await _dioClient.get('/users/$username');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ApiException(message: 'User not found', statusCode: 404);
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout. Please try again.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      }
      throw ApiException(
        message: e.message ?? 'Something went wrong',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  @override
  Future<List<dynamic>> getUserRepositories(String username) async {
    try {
      final response = await _dioClient.get(
        '/users/$username/repos',
        queryParameters: {'per_page': 100, 'sort': 'updated'},
      );

      if (response.data is List) {
        return response.data as List<dynamic>;
      }
      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ApiException(message: 'User not found', statusCode: 404);
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout. Please try again.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      }
      throw ApiException(
        message: e.message ?? 'Something went wrong',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }
}