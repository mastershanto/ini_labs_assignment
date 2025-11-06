import 'package:ini_labs_assignment/Features/user_details/data/model/github_user.dart';


abstract class GithubRepositoryInterface {
  Future<GithubUser> getUser(String username);
  Future<List<dynamic>> getUserRepositories(String username);
}