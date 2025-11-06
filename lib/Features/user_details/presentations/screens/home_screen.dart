import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ini_labs_assignment/Features/user_details/presentations/screens/repository_list_screen.dart';
import 'package:ini_labs_assignment/Features/user_details/presentations/state_holders/repository_controller.dart';
import 'package:ini_labs_assignment/Features/user_details/presentations/state_holders/theme_controller.dart';
import 'package:ini_labs_assignment/Features/user_details/presentations/state_holders/user_controller.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart' as custom;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserController userController = Get.find<UserController>();
  final RepositoryController repoController = Get.find<RepositoryController>();
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  void initState() {
    super.initState();
    _fetchRepositories();
  }

  void _fetchRepositories() {
    if (userController.user != null) {
      repoController.fetchRepositories(userController.user!.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Repositories'),
        actions: [
          GetBuilder<ThemeController>(
            builder: (controller) => IconButton(
              icon: Icon(
                controller.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: controller.toggleTheme,
            ),
          ),
        ],
      ),
      body: GetBuilder<UserController>(
        builder: (controller) {
          final user = controller.user;
          if (user == null) {
            return const Center(child: Text('No user data'));
          }

          return RefreshIndicator(
            onRefresh: () async => _fetchRepositories(),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildUserProfile(user)),
                SliverToBoxAdapter(child: _buildRepositoryHeader()),
                GetBuilder<RepositoryController>(
                  builder: (controller) {
                    if (controller.isLoading) {
                      return const SliverFillRemaining(
                        child: LoadingWidget(
                          message: 'Loading repositories...',
                        ),
                      );
                    }

                    if (controller.errorMessage.isNotEmpty) {
                      return SliverFillRemaining(
                        child: custom.ErrorWidget(
                          message: controller.errorMessage,
                          onRetry: _fetchRepositories,
                        ),
                      );
                    }

                    if (controller.repositories.isEmpty) {
                      return const SliverFillRemaining(
                        child: Center(child: Text('No repositories found')),
                      );
                    }

                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserProfile(user) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50.r,
            backgroundImage: CachedNetworkImageProvider(user.avatarUrl),
          ),
          SizedBox(height: 16.h),
          Text(
            user.name ?? user.login,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 4.h),
          Text('@${user.login}', style: Theme.of(context).textTheme.bodyMedium),
          if (user.bio != null) ...[
            SizedBox(height: 12.h),
            Text(
              user.bio!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
          SizedBox(height: 16.h),
          Wrap(
            spacing: 16.w,
            runSpacing: 8.h,
            alignment: WrapAlignment.center,
            children: [
              if (user.company != null)
                _buildInfoChip(Icons.business, user.company!),
              if (user.location != null)
                _buildInfoChip(Icons.location_on, user.location!),
              if (user.blog != null && user.blog!.isNotEmpty)
                _buildInfoChip(Icons.link, user.blog!),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatColumn('Repos', user.publicRepos.toString()),
              _buildStatColumn('Followers', user.followers.toString()),
              _buildStatColumn('Following', user.following.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: Theme.of(context).primaryColor),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.sp,
                color: Theme.of(context).primaryColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.headlineMedium),
        SizedBox(height: 4.h),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildRepositoryHeader() {
    return GetBuilder<RepositoryController>(
      builder: (controller) {
        if (controller.repositories.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: ElevatedButton.icon(
            onPressed: () => Get.to(() => const RepositoryListScreen()),
            icon: const Icon(Icons.folder),
            label: Text(
              'View ${controller.repositories.length} Repositories',
              style: TextStyle(fontSize: 16.sp),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              minimumSize: Size(double.infinity, 50.h),
            ),
          ),
        );
      },
    );
  }
}