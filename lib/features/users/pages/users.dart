import 'package:flutter/material.dart';
import 'package:moodsic/features/users/models/users_viewmodel.dart';
import 'package:moodsic/features/users/widget/user_tile.dart' show UserTile;

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final UsersViewModel _viewModel = UsersViewModel();

  @override
  void initState() {
    super.initState();
    print('UsersPage: Initializing and fetching users');
    _viewModel.fetchUsers(); // Giữ nguyên method call như code cũ
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            TextField(
              controller: _viewModel.searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search by display name or email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffixIcon:
                    _viewModel.searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _viewModel.searchController.clear();
                          },
                        )
                        : null,
              ),
            ),
            const SizedBox(height: 10),

            // Provider filter dropdown
            StreamBuilder<List<dynamic>>(
              stream: _viewModel.usersStream,
              builder: (context, snapshot) {
                final availableProviders = _viewModel.getAvailableProviders();

                return DropdownButton<String>(
                  value:
                      availableProviders.contains(_viewModel.selectedProvider)
                          ? _viewModel.selectedProvider
                          : 'All',
                  hint: const Text('Filter by provider'),
                  isExpanded: true,
                  items:
                      availableProviders
                          .map(
                            (provider) => DropdownMenuItem(
                              value: provider,
                              child: Text(provider),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      print('UsersPage: Provider filter changed to $value');
                      _viewModel.updateProviderFilter(value);
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 10),

            // Refresh button
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    print('UsersPage: Refreshing data');
                    _viewModel.refresh();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
                const Spacer(),
                StreamBuilder<List<dynamic>>(
                  stream: _viewModel.usersStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        '${snapshot.data!.length} users found',
                        style: Theme.of(context).textTheme.bodySmall,
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Users list
            Expanded(
              child: StreamBuilder<List<dynamic>>(
                stream: _viewModel.usersStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      !snapshot.hasData) {
                    print('UsersPage: StreamBuilder in initial waiting state');
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    print('UsersPage: StreamBuilder error: ${snapshot.error}');
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text('Error: ${snapshot.error}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _viewModel.refresh(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    print('UsersPage: No users found');
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text('No users found'),
                          SizedBox(height: 8),
                          Text(
                            'Try adjusting your search or filter criteria',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  final users = snapshot.data!;
                  print('UsersPage: Displaying ${users.length} users');

                  return RefreshIndicator(
                    onRefresh: () => _viewModel.refresh(),
                    child: ListView.builder(
                      itemCount: users.length + (_viewModel.isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        // Show loading indicator at the end
                        if (index == users.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final user = users[index];
                        return UserTile(
                          user: user,
                          onTap: () {
                            print('UsersPage: Navigating to user ${user.uid}');
                            _viewModel.navigateToUserDetail(context, user.uid);
                          },
                          onDelete: () {
                            print('UsersPage: Deleting user ${user.uid}');
                            _viewModel.deleteUser(context, user.uid);
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            // Pagination controls
            Container(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // ElevatedButton.icon(
                  //   onPressed:
                  //       _viewModel.currentPage > 1 && !_viewModel.isLoading
                  //           ? () {
                  //             print(
                  //               'UsersPage: Loading previous page ${_viewModel.currentPage - 1}',
                  //             );
                  //             _viewModel.loadPreviousPage();
                  //           }
                  //           : null,
                  //   icon: const Icon(Icons.chevron_left),
                  //   label: const Text('Previous'),
                  // ),

                  // Column(
                  //   children: [
                  //     Text(
                  //       'Page ${_viewModel.currentPage}',
                  //       style: Theme.of(context).textTheme.titleMedium,
                  //     ),
                  //     if (_viewModel.isLoading)
                  //       const Text(
                  //         'Loading...',
                  //         style: TextStyle(color: Colors.grey, fontSize: 12),
                  //       ),
                  //   ],
                  // ),
                  ElevatedButton.icon(
                    onPressed:
                        _viewModel.hasMore && !_viewModel.isLoading
                            ? () {
                              print(
                                'UsersPage: Loading next page ${_viewModel.currentPage + 1}',
                              );
                              _viewModel.loadNextPage();
                            }
                            : null,
                    icon: const Icon(Icons.chevron_right),
                    label: const Text('more'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    print('UsersPage: Disposing');
    _viewModel.dispose();
    super.dispose();
  }
}
