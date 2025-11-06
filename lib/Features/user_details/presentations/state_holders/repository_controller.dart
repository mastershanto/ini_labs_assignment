import 'package:get/get.dart';
import '../../data/models/repository.dart';
import '../../domain/usecases/get_user_repositories_usecase.dart';

enum ViewType { list, grid }

enum SortType { name, date, stars, forks }

class RepositoryController extends GetxController {
  final GetUserRepositoriesUseCase _getUserRepositoriesUseCase;

  RepositoryController(this._getUserRepositoriesUseCase);

  List<Repository> repositories = <Repository>[];
  List<Repository> filteredRepositories = <Repository>[];
  bool isLoading = false;
  String errorMessage = '';
  ViewType viewType = ViewType.list;
  SortType sortType = SortType.date;
  String searchQuery = '';
  bool isAscending = false;

  Future<void> fetchRepositories(String username) async {
    try {
      isLoading = true;
      errorMessage = '';
      update();

      final repos = await _getUserRepositoriesUseCase.execute(username);
      repositories = repos;
      applyFilters();
    } catch (e) {
      errorMessage = e.toString();
      repositories.clear();
      filteredRepositories.clear();
    } finally {
      isLoading = false;
      update();
    }
  }

  void toggleViewType() {
    viewType = viewType == ViewType.list ? ViewType.grid : ViewType.list;
    update();
  }

  void changeSortType(SortType type) {
    if (sortType == type) {
      isAscending = !isAscending;
    } else {
      sortType = type;
      isAscending = false;
    }
    applyFilters();
  }

  void searchRepositories(String query) {
    searchQuery = query;
    applyFilters();
  }

  void applyFilters() {
    List<Repository> filtered = List.from(repositories);

    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((repo) {
        return repo.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            (repo.description?.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ) ??
                false);
      }).toList();
    }

    switch (sortType) {
      case SortType.name:
        filtered.sort((a, b) => a?.name.compareTo(b.name));
        break;
      case SortType.date:
        filtered.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
      case SortType.stars:
        filtered.sort((a, b) => b.stargazersCount.compareTo(a.stargazersCount));
        break;
      case SortType.forks:
        filtered.sort((a, b) => b.forksCount.compareTo(a.forksCount));
        break;
    }

    if (isAscending) {
      filtered = filtered.reversed.toList();
    }

    filteredRepositories = filtered;
    update();
  }

  void clearRepositories() {
    repositories.clear();
    filteredRepositories.clear();
    errorMessage = '';
    searchQuery = '';
    update();
  }
}