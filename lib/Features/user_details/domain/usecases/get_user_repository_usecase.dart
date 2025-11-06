import 'package:ini_labs_assignment/Features/user_details/data/model/repository.dart';

import '../../data/repositories/github_repository.dart';

class GetUserRepositoriesUseCase {
  final GithubRepository _repository;

  GetUserRepositoriesUseCase(this._repository);

  Future<List<Repository>> execute(String username) async {
    return await _repository.getUserRepositories(username);
  }
}