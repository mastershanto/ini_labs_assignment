import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final Map<String, dynamic> dummyUser = const {
    'login': 'john_doe',
    'name': 'John Doe',
    'avatarUrl': 'https://via.placeholder.com/100', // Placeholder image URL
    'bio': 'A passionate developer who loves coding and open source.',
    'company': 'Tech Corp',
    'location': 'San Francisco, CA',
    'blog': 'https://johndoe.dev',
    'publicRepos': 42,
    'followers': 123,
    'following': 456,
  };

  final List<String> dummyRepositories = const [
    'flutter-app',
    'dart-library',
    'web-project',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Repositories'),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildUserProfile(context, dummyUser)),
            SliverToBoxAdapter(child: _buildRepositoryHeader(dummyRepositories)),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context, Map<String, dynamic> user) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: 50.r,
            backgroundImage: CachedNetworkImageProvider(user['avatarUrl']),
          ),
          SizedBox(height: 16.h),
          // Name and username
          Text(
            user['name'] ?? user['login'],
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 4.h),
          Text('@${user['login']}', style: Theme.of(context).textTheme.bodyMedium),
          // Bio if available
          if (user['bio'] != null) ...[
            SizedBox(height: 12.h),
            Text(
              user['bio'],
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
          SizedBox(height: 16.h),
          // Chips for company, location, blog
          Wrap(
            spacing: 16.w,
            runSpacing: 8.h,
            alignment: WrapAlignment.center,
            children: [
              if (user['company'] != null) _buildInfoChip(context, Icons.business, user['company']),
              if (user['location'] != null) _buildInfoChip(context, Icons.location_on, user['location']),
              if (user['blog'] != null && user['blog'].isNotEmpty) _buildInfoChip(context, Icons.link, user['blog']),
            ],
          ),
          SizedBox(height: 16.h),
          // Stats: Repos, Followers, Following
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatColumn(context, 'Repos', user['publicRepos'].toString()),
              _buildStatColumn(context, 'Followers', user['followers'].toString()),
              _buildStatColumn(context, 'Following', user['following'].toString()),
            ],
          ),
        ],
      ),
    );
  }

  // Helper to build info chips (e.g., for company, location)
  Widget _buildInfoChip(BuildContext context, IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
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

  // Helper to build stat columns (e.g., number of repos)
  Widget _buildStatColumn(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.headlineMedium),
        SizedBox(height: 4.h),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  // Builds the header/button to view repositories
  Widget _buildRepositoryHeader(List<String> repositories) {
    if (repositories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: ElevatedButton.icon(
        onPressed: () {
          // Navigation to repository list page. In original, used Get.to()
          // Here, placeholder: Navigator.push(context, MaterialPageRoute(builder: (_) => RepositoryListPage()));
        },
        icon: const Icon(Icons.folder),
        label: Text(
          'View ${repositories.length} Repositories',
          style: TextStyle(fontSize: 16.sp),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          minimumSize: Size(double.infinity, 50.h),
        ),
      ),
    );
  }
}