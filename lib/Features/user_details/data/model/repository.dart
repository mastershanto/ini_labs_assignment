class Repository {
  final int id;
  final String name;
  final String fullName;
  final String? description;
  final bool private;
  final String htmlUrl;
  final int stargazersCount;
  final int watchersCount;
  final int forksCount;
  final int openIssuesCount;
  final String? language;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? pushedAt;
  final int size;
  final String? defaultBranch;
  final bool archived;
  final bool disabled;
  final String? license;
  final List<String> topics;
  final String? homepage;

  Repository({
    required this.id,
    required this.name,
    required this.fullName,
    this.description,
    required this.private,
    required this.htmlUrl,
    required this.stargazersCount,
    required this.watchersCount,
    required this.forksCount,
    required this.openIssuesCount,
    this.language,
    required this.createdAt,
    required this.updatedAt,
    this.pushedAt,
    required this.size,
    this.defaultBranch,
    required this.archived,
    required this.disabled,
    this.license,
    this.topics = const [],
    this.homepage,
  });

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      fullName: json['full_name'] ?? '',
      description: json['description'],
      private: json['private'] ?? false,
      htmlUrl: json['html_url'] ?? '',
      stargazersCount: json['stargazers_count'] ?? 0,
      watchersCount: json['watchers_count'] ?? 0,
      forksCount: json['forks_count'] ?? 0,
      openIssuesCount: json['open_issues_count'] ?? 0,
      language: json['language'],
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
      pushedAt: json['pushed_at'] != null
          ? DateTime.parse(json['pushed_at'])
          : null,
      size: json['size'] ?? 0,
      defaultBranch: json['default_branch'],
      archived: json['archived'] ?? false,
      disabled: json['disabled'] ?? false,
      license: json['license']?['name'],
      topics: json['topics'] != null ? List<String>.from(json['topics']) : [],
      homepage: json['homepage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'full_name': fullName,
      'description': description,
      'private': private,
      'html_url': htmlUrl,
      'stargazers_count': stargazersCount,
      'watchers_count': watchersCount,
      'forks_count': forksCount,
      'open_issues_count': openIssuesCount,
      'language': language,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'pushed_at': pushedAt?.toIso8601String(),
      'size': size,
      'default_branch': defaultBranch,
      'archived': archived,
      'disabled': disabled,
      'topics': topics,
      'homepage': homepage,
    };
  }

  Repository copyWith({
    int? id,
    String? name,
    String? fullName,
    String? description,
    bool? private,
    String? htmlUrl,
    int? stargazersCount,
    int? watchersCount,
    int? forksCount,
    int? openIssuesCount,
    String? language,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? pushedAt,
    int? size,
    String? defaultBranch,
    bool? archived,
    bool? disabled,
    String? license,
    List<String>? topics,
    String? homepage,
  }) {
    return Repository(
      id: id ?? this.id,
      name: name ?? this.name,
      fullName: fullName ?? this.fullName,
      description: description ?? this.description,
      private: private ?? this.private,
      htmlUrl: htmlUrl ?? this.htmlUrl,
      stargazersCount: stargazersCount ?? this.stargazersCount,
      watchersCount: watchersCount ?? this.watchersCount,
      forksCount: forksCount ?? this.forksCount,
      openIssuesCount: openIssuesCount ?? this.openIssuesCount,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      pushedAt: pushedAt ?? this.pushedAt,
      size: size ?? this.size,
      defaultBranch: defaultBranch ?? this.defaultBranch,
      archived: archived ?? this.archived,
      disabled: disabled ?? this.disabled,
      license: license ?? this.license,
      topics: topics ?? this.topics,
      homepage: homepage ?? this.homepage,
    );
  }
}