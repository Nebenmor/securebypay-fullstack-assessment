import 'package:go_router/go_router.dart';
import '../features/auth/sign_in_screen.dart';
import '../features/auth/sign_up_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import 'api/api_client.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final loggedIn = ApiClient.instance.hasToken;
    final location = state.matchedLocation;
    final isAuthPage = location == '/login' || location == '/signup';

    if (!loggedIn && !isAuthPage) return '/login';
    if (loggedIn && isAuthPage) return '/dashboard';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const SignInScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),
    GoRoute(path: '/dashboard', builder: (context, state) => const DashboardScreen()),
  ],
);