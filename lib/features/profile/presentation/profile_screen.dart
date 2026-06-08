import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:computology/features/auth/logic/auth_provider.dart';
import 'package:computology/features/profile/logic/profile_provider.dart';
import 'package:computology/core/theme/theme_provider.dart';
import 'package:computology/core/utils/app_constants.dart';
import 'package:computology/core/utils/app_routes.dart';
import 'package:computology/core/widgets/profile_menu_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>().profile;
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.pagePadding),
        child: Column(
          children: [
            CircleAvatar(
              radius: 44,
              backgroundImage: NetworkImage(profile.photoUrl),
            ),
            const SizedBox(height: 12),
            Text(
              profile.fullName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(profile.email, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  ProfileMenuItem(
                    icon: Icons.edit,
                    label: 'Edit Profile',
                    onTap: () {
                      context.push(AppRoutes.editProfile);
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.history,
                    label: 'Order History',
                    onTap: () {},
                  ),
                  ProfileMenuItem(
                    icon: Icons.settings,
                    label: 'Settings',
                    onTap: () {},
                  ),
                  ProfileMenuItem(
                    icon: Icons.logout,
                    label: 'Logout',
                    onTap: () async {
                      await context.read<AuthProvider>().logout();
                      if (!context.mounted) return;
                      context.go(AppRoutes.login);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
