import 'package:go_router/go_router.dart';
import 'package:moodsic/core/services/auth_provider.dart';
import 'package:moodsic/features/auth/pages/login.dart';
import 'package:moodsic/features/auth/pages/register.dart';
import 'package:moodsic/features/main_navigation/nav_bar_admin.dart';
import 'package:moodsic/features/main_navigation/nav_bar_user.dart';
import 'package:moodsic/features/users/pages/user_detail_page.dart';
import 'package:moodsic/routes/route_names.dart';

final GoRouter router = GoRouter(
  initialLocation: RouteNames.login,
  debugLogDiagnostics: true,
  refreshListenable: CAuthProvider.instance,
  redirect: (context, state) {
    final authProvider = CAuthProvider.instance;
    final user = authProvider.user;
    final role = authProvider.role;
    final isLoading = authProvider.isLoading;

    print('[Router] user: $user, role: $role, isLoading: $isLoading');

    final location = state.uri.path;

    // Nếu đang tải, chờ
    if (isLoading) return null;

    // Nếu không có người dùng, chuyển đến đăng ký
    if (user == null) {
      return location == RouteNames.register ? null : RouteNames.register;
    }

    // Nếu đã đăng nhập và ở trang đăng nhập/đăng ký, chuyển hướng theo vai trò
    if (location == RouteNames.login || location == RouteNames.register) {
      return role == 'admin' ? RouteNames.adminHome : RouteNames.userHome;
    }

    // Nếu không phải admin mà cố vào adminHome, chuyển đến userHome
    if (location == RouteNames.adminHome && role != 'admin') {
      return RouteNames.userHome;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: RouteNames.userHome,
      builder: (context, state) => const UserNavigationPage(),
    ),
    GoRoute(
      path: RouteNames.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: RouteNames.register,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: RouteNames.adminHome,
      builder: (context, state) => const AdminNavigationPage(),
    ),
    GoRoute(
      path: RouteNames.userDetail,
      builder: (context, state) {
        final uid = state.pathParameters['uid']!;
        return UserDetailPage(uid: uid);
      },
    ),
  ],
);
