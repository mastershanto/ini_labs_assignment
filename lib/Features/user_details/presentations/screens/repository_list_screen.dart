import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ini_labs_assignment/Features/user_details/data/model/repository.dart';
import 'package:ini_labs_assignment/Features/user_details/presentations/screens/repository_details_screen.dart';
import 'package:ini_labs_assignment/Features/user_details/presentations/state_holders/repository_controller.dart';
import 'package:ini_labs_assignment/core/theme/app_colors.dart';
import 'package:intl/intl.dart';

class RepositoryListScreen extends StatefulWidget {
  const RepositoryListScreen({super.key});

  @override
  State<RepositoryListScreen> createState() => _RepositoryListScreenState();
}

class _RepositoryListScreenState extends State<RepositoryListScreen> {
  final RepositoryController controller = Get.find<RepositoryController>();
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sort By', style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: 16.h),
            _buildSortOption('Name', SortType.name, Icons.sort_by_alpha),
            _buildSortOption(
              'Date Updated',
              SortType.date,
              Icons.calendar_today,
            ),
            _buildSortOption('Stars', SortType.stars, Icons.star),
            _buildSortOption('Forks', SortType.forks, Icons.call_split),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String title, SortType type, IconData icon) {
    return GetBuilder<RepositoryController>(
      builder: (controller) => ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: controller.sortType == type
            ? Icon(
                controller.isAscending
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
                color: Theme.of(context).primaryColor,
              )
            : null,
        selected: controller.sortType == type,
        onTap: () {
          controller.changeSortType(type);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repositories'),
        actions: [
          GetBuilder<RepositoryController>(
            builder: (controller) => IconButton(
              icon: Icon(
                controller.viewType == ViewType.list
                    ? Icons.grid_view
                    : Icons.list,
              ),
              onPressed: controller.toggleViewType,
            ),
          ),
          IconButton(icon: const Icon(Icons.sort), onPressed: _showSortOptions),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: GetBuilder<RepositoryController>(
              builder: (controller) => TextField(
                controller: searchController,
                onChanged: controller.searchRepositories,
                decoration: InputDecoration(
                  hintText: 'Search repositories...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: controller.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            controller.searchRepositories('');
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),
          Expanded(
            child: GetBuilder<RepositoryController>(
              builder: (controller) {
                if (controller.filteredRepositories.isEmpty) {
                  return const Center(child: Text('No repositories found'));
                }

                return controller.viewType == ViewType.list
                    ? _buildListView()
                    : _buildGridView();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: controller.filteredRepositories.length,
      itemBuilder: (context, index) {
        final repo = controller.filteredRepositories[index];
        return _buildRepositoryCard(repo);
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.85,
      ),
      itemCount: controller.filteredRepositories.length,
      itemBuilder: (context, index) {
        final repo = controller.filteredRepositories[index];
        return _buildRepositoryGridCard(repo);
      },
    );
  }

  Widget _buildRepositoryCard(Repository repo) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: () => Get.to(() => RepositoryDetailScreen(repository: repo)),
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.folder,
                    color: Theme.of(context).primaryColor,
                    size: 24.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      repo.name,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (repo.private)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Private',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.warning,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              if (repo.description != null) ...[
                SizedBox(height: 8.h),
                Text(
                  repo.description!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              SizedBox(height: 12.h),
              Wrap(
                spacing: 16.w,
                runSpacing: 8.h,
                children: [
                  _buildIconText(
                    Icons.star,
                    repo.stargazersCount.toString(),
                    AppColors.starColor,
                  ),
                  _buildIconText(
                    Icons.call_split,
                    repo.forksCount.toString(),
                    AppColors.forkColor,
                  ),
                  if (repo.language != null) _buildLanguageTag(repo.language!),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                'Updated: ${DateFormat('MMM d, yyyy').format(repo.updatedAt)}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRepositoryGridCard(Repository repo) {
    return Card(
      child: InkWell(
        onTap: () => Get.to(() => RepositoryDetailScreen(repository: repo)),
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.folder,
                color: Theme.of(context).primaryColor,
                size: 32.sp,
              ),
              SizedBox(height: 8.h),
              Text(
                repo.name,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontSize: 14.sp),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (repo.description != null) ...[
                SizedBox(height: 4.h),
                Text(
                  repo.description!,
                  style: TextStyle(fontSize: 11.sp),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIconText(
                    Icons.star,
                    repo.stargazersCount.toString(),
                    AppColors.starColor,
                  ),
                  _buildIconText(
                    Icons.call_split,
                    repo.forksCount.toString(),
                    AppColors.forkColor,
                  ),
                ],
              ),
              if (repo.language != null) ...[
                SizedBox(height: 8.h),
                _buildLanguageTag(repo.language!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16.sp, color: color),
        SizedBox(width: 4.w),
        Text(text, style: TextStyle(fontSize: 12.sp)),
      ],
    );
  }

  Widget _buildLanguageTag(String language) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        language,
        style: TextStyle(
          fontSize: 10.sp,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
