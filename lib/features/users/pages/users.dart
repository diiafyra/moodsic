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
    _viewModel.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thanh tìm kiếm
            TextField(
              controller: _viewModel.searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search by display name or email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                print('UsersPage: Search query changed to $value');
                _viewModel.updateSearchQuery(value);
              },
            ),
            const SizedBox(height: 10),
            // Bộ lọc provider
            DropdownButton<String>(
              value: _viewModel.selectedProvider,
              hint: const Text('Filter by provider'),
              isExpanded: true,
              items:
                  ['All', 'Google', 'Email', 'Other']
                      .map(
                        (provider) => DropdownMenuItem(
                          value: provider,
                          child: Text(provider),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                print('UsersPage: Provider filter changed to $value');
                _viewModel.updateProviderFilter(value!);
              },
            ),
            const SizedBox(height: 20),
            // Danh sách users
            Expanded(
              child: StreamBuilder<List<dynamic>>(
                stream: _viewModel.usersStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print('UsersPage: StreamBuilder in waiting state');
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    print('UsersPage: StreamBuilder error: ${snapshot.error}');
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    print('UsersPage: No users found');
                    return const Center(child: Text('No users found'));
                  }
                  final users = snapshot.data!;
                  print('UsersPage: Loaded ${users.length} users');
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
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
                  );
                },
              ),
            ),
            // Nút phân trang
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed:
                      _viewModel.currentPage > 1
                          ? () {
                            print(
                              'UsersPage: Fetching previous page ${_viewModel.currentPage - 1}',
                            );
                            _viewModel.fetchUsers(isPrevious: true);
                          }
                          : null,
                  child: const Text('Previous'),
                ),
                Text('Page ${_viewModel.currentPage}'),
                ElevatedButton(
                  onPressed:
                      _viewModel.hasMore
                          ? () {
                            print(
                              'UsersPage: Fetching next page ${_viewModel.currentPage + 1}',
                            );
                            _viewModel.fetchUsers(isNext: true);
                          }
                          : null,
                  child: const Text('Next'),
                ),
              ],
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
