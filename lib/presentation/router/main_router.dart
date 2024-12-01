import '../screen/index.dart';
import 'package:go_router/go_router.dart';

final mainRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginScreen(), 
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(), 
    ),
  ],
);
