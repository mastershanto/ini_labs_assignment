import 'package:ini_labs_assignment/Features/user_details/data/datasource/github_remote_datasource.dart';
import 'package:ini_labs_assignment/Features/user_details/data/model/github_user.dart';
import 'package:ini_labs_assignment/Features/user_details/data/model/repository.dart';


class GithubRepository {
  final GithubRemoteDataSource _remoteDataSource;

  GithubRepository(this._remoteDataSource);

  Future<GithubUser> getUser(String username) async {
    final userData = await _remoteDataSource.getUser(username);
    return GithubUser.fromJson(userData);
  }

  Future<List<Repository>> getUserRepositories(String username) async {
    final reposData = await _remoteDataSource.getUserRepositories(username);
    return reposData.map((repo) => Repository.fromJson(repo)).toList();
  }
}