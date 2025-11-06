import 'package:ini_labs_assignment/Features/user_details/data/model/github_user.dart';

import '../../data/repositories/github_repository.dart';

class GetUserUseCase {
  final GithubRepository _repository;

  GetUserUseCase(this._repository);

  Future<GithubUser> execute(String username) async {
    return await _repository.getUser(username);
  }
}