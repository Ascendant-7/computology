import 'package:computology/core/widgets/app_bottom_navbar.dart';
import 'package:computology/features/auth/presentation/forgot_password_screen.dart';
import 'package:computology/features/auth/presentation/login_screen.dart';
import 'package:computology/features/auth/presentation/register_screen.dart';
import 'package:computology/features/cart/presentation/cart_screen.dart';
import 'package:computology/core/product/product.dart';
import 'package:computology/features/catalog/presentation/product_detail_screen.dart';
import 'package:computology/features/catalog/presentation/search_placeholder_screen.dart';
import 'package:computology/features/checkout/presentation/checkout_screen.dart';
import 'package:computology/features/catalog/presentation/favorites_screen.dart';
import 'package:computology/features/pc_builder/presentation/pc_builder_screen.dart';
import 'package:computology/features/dashboard/admin_dashboard_screen.dart';
import 'package:computology/features/profile/presentation/edit_profile_screen.dart';
import 'package:computology/features/profile/presentation/profile_screen.dart';
import 'package:go_router/go_router.dart';

import 'package:computology/core/utils/app_routes.dart';
import 'package:computology/features/catalog/presentation/home_screen.dart';
import 'package:computology/features/auth/logic/auth_provider.dart';

GoRouter createGoRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    redirect: (context, state) {
      final bool isLoggedIn = authProvider.isLoggedIn;
      final bool isGoingToLogin =
          state.uri.path == AppRoutes.login ||
          state.uri.path == AppRoutes.register;

      if (!isLoggedIn && !isGoingToLogin) return AppRoutes.login;
      if (isLoggedIn && isGoingToLogin) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, _) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (_, _) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.checkout,
        builder: (_, _) => const CheckoutScreen(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (_, _) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.productDetail,
        builder: (_, state) =>
            ProductDetailScreen(product: state.extra as Product),
      ),
      GoRoute(
        path: AppRoutes.favorites,
        builder: (_, _) => const FavoritesScreen(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (_, _) => AdminDashboardScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navshell) {
          return AppBottomNavBar(navshell: navshell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (_, _) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.search,
                builder: (_, _) => const SearchPlaceholderScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.pcBuilder,
                builder: (_, _) => const PCBuilderScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.cart,
                builder: (_, _) => const CartScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (_, _) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
