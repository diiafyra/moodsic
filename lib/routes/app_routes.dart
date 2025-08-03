import 'package:go_router/go_router.dart';
import 'package:moodsic/features/auth/pages/login.dart';
import 'package:moodsic/features/home/pages/admin_home_page.dart';
import 'package:moodsic/features/home/pages/user_home_page.dart';
import 'package:moodsic/features/loading/pages/loading_page.dart';
import 'package:moodsic/features/main_navigation/nav_bar_admin.dart';
import 'package:moodsic/features/main_navigation/nav_bar_user.dart';
import 'package:moodsic/routes/route_names.dart';
import 'package:moodsic/shared/states/auth_provider.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.loading,
  refreshListenable: CAuthProvider.instance,
  redirect: (context, state) {
    final provider = CAuthProvider.instance;

    if (!provider.isInitialized || provider.isLoading) {
      return RouteNames.loading;
    }

    if (provider.user == null) return RouteNames.login;

    if (provider.role == 'admin') return RouteNames.adminHome;
    return RouteNames.userHome;
  },
  routes: [
    GoRoute(path: RouteNames.loading, builder: (_, __) => const LoadingPage()),
    GoRoute(path: RouteNames.login, builder: (_, __) => const LoginPage()),
    GoRoute(
      path: RouteNames.adminHome,
      builder: (_, __) => const AdminNavigationPage(),
    ),
    GoRoute(
      path: RouteNames.userHome,
      builder: (_, __) => const UserNavigationPage(),
    ),
  ],
);
