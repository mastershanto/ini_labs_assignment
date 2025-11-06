import 'package:get/get.dart';
import 'package:ini_labs_assignment/Features/user_details/data/model/github_user.dart';
import '../../domain/usecases/get_user_usecase.dart';

class UserController extends GetxController {
  final GetUserUseCase _getUserUseCase;

  UserController(this._getUserUseCase);

  GithubUser? user;
  bool isLoading = false;
  String errorMessage = '';
  String username = '';

  Future<void> fetchUser(String username) async {
    try {
      isLoading = true;
      errorMessage = '';
      this.username = username;
      update();

      final fetchedUser = await _getUserUseCase.execute(username);
      user = fetchedUser;
    } catch (e) {
      errorMessage = e.toString();
      user = null;
    } finally {
      isLoading = false;
      update();
    }
  }

  void clearUser() {
    user = null;
    username = '';
    errorMessage = '';
    update();
  }
}