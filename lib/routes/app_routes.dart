import 'package:go_router/go_router.dart';
import 'package:moodsic/features/auth/pages/login.dart';
import 'package:moodsic/features/home/pages/admin_home_page.dart';
import 'package:moodsic/features/home/pages/user_home_page.dart';
import 'package:moodsic/features/loading/pages/loading_page.dart';
import 'package:moodsic/features/main_navigation/nav_bar_admin.dart';
import 'package:moodsic/features/main_navigation/nav_bar_user.dart';
import 'package:moodsic/features/survey/pages/connect_spotify_page.dart';
import 'package:moodsic/features/survey/pages/genre_selection_page.dart';
import 'package:moodsic/features/users/pages/user_detail_page.dart';
import 'package:moodsic/routes/route_names.dart';
import 'package:moodsic/shared/states/auth_provider.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.loading,
  refreshListenable: CAuthProvider.instance,
  redirect: (context, state) {
    final provider = CAuthProvider.instance;

    final isLoading = !provider.isInitialized || provider.isLoading;
    final isLoggedIn = provider.user != null;
    final isAtLogin = state.uri.path == RouteNames.login;
    final isAtLoading = state.uri.path == RouteNames.loading;

    if (isLoading) return RouteNames.loading;
    if (!isLoggedIn) return isAtLogin ? null : RouteNames.login;

    // Nếu là admin → chuyển về adminHome
    if (provider.role == 'admin') {
      return state.uri.path == RouteNames.adminHome
          ? null
          : RouteNames.adminHome;
    }

    // Nếu là user
    if (provider.role == 'user') {
      if (!provider.hasProfiles) {
        if (!provider.hasConnectedSpotify) {
          return state.uri.path == RouteNames.connectSpotify
              ? null
              : RouteNames.connectSpotify;
        } else {
          // Nếu đã connect spotify → sang chọn thể loại nhạc
          return state.uri.path == RouteNames.genreSelection
              ? null
              : RouteNames.genreSelection;
        }
      } else {
        return state.uri.path == RouteNames.userHome
            ? null
            : RouteNames.userHome;
      }
    }

    // Mặc định: về loading
    return RouteNames.loading;
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
    GoRoute(
      path: RouteNames.connectSpotify,
      builder: (_, __) => const ConnectSpotifyPage(),
    ),
    GoRoute(
      path: RouteNames.genreSelection,
      builder: (_, __) => const GenreSelectionPage(),
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
