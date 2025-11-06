
import 'package:get/get.dart';
import 'package:ini_labs_assignment/Features/user_details/data/datasource/github_remote_datasource.dart';
import 'package:ini_labs_assignment/Features/user_details/data/repositories/github_repository.dart';
import 'package:ini_labs_assignment/Features/user_details/domain/usecases/get_user_repository_usecase.dart';
import 'package:ini_labs_assignment/Features/user_details/domain/usecases/get_user_usecase.dart';
import 'package:ini_labs_assignment/Features/user_details/presentations/state_holders/repository_controller.dart';
import 'package:ini_labs_assignment/Features/user_details/presentations/state_holders/theme_controller.dart';
import 'package:ini_labs_assignment/Features/user_details/presentations/state_holders/user_controller.dart';

import 'core/network/dio_client.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    // Core
    Get.lazyPut(() => DioClient(), fenix: true);

    // Data Sources
    Get.lazyPut<GithubRemoteDataSource>(
      () => GithubRemoteDataSourceImpl(Get.find()),
      fenix: true,
    );

    // Repositories
    Get.lazyPut(() => GithubRepository(Get.find()), fenix: true);

    // Use Cases
    Get.lazyPut(() => GetUserUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetUserRepositoriesUseCase(Get.find()), fenix: true);

    // Controllers
    Get.put(ThemeController());
    Get.put(UserController(Get.find()));
    
    Get.put(RepositoryController(Get.find()));
  }
}