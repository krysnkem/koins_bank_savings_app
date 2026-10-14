import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../widgets/profile_avatar_header.dart';
import '../widgets/profile_info_section.dart';
import '../widgets/profile_logout_button.dart';

/// Screen displaying the user profile details and logout option.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: const Padding(
        padding: EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          children: [
            ProfileAvatarHeader(),
            ProfileInfoSection(),
            Spacer(),
            ProfileLogoutButton(),
            SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
