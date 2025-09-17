import 'package:flutter/material.dart';
import 'package:thirdeye/Menu/about.dart';
import 'package:thirdeye/Menu/certificate.dart';
import 'package:thirdeye/Menu/edit_profile.dart';
import 'package:thirdeye/Menu/faq.dart';
import 'package:thirdeye/Menu/past_score.dart';
import 'package:thirdeye/Menu/terms_condition.dart';
import 'package:thirdeye/repositories/auth_repositories.dart';
import 'package:thirdeye/repositories/google_auth_repository.dart';
import 'package:thirdeye/screen/dashboard/dashboard.dart';
import 'package:thirdeye/login_screen.dart';
import 'package:thirdeye/utils/storage_helper.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  String? firstName;
  String? profilePicUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final name = await StorageHelper.getToken('first_name');
    final pic = await StorageHelper.getToken('profile_pic'); // ✅ fetch pic
    setState(() {
      firstName = name ?? "User";
      profilePicUrl = pic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Menu',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // User Profile Section
          InkWell(
            onTap: () {
              // Navigate to Edit Profile screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Profile Picture
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: ClipOval(
                      child: profilePicUrl != null && profilePicUrl!.isNotEmpty
                          ? Image.network(
                              profilePicUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                Icons.person,
                                size: 30,
                                color: Color(0xFF4B1FA1),
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              size: 30,
                              color: Color(0xFF4B1FA1),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Name and Email
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        firstName ?? "User",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    // Add this trailing property
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          // Menu Items
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  _buildMenuItem(Icons.dashboard, "DashBoard", () {
                    _navigateTo(context, const DashboardScreen());
                  }),
                  const SizedBox(height: 20),
                  _buildMenuItem(Icons.history, "Past Scores", () {
                    _navigateTo(context, const PastScoresScreen());
                  }),
                  const SizedBox(height: 20),
                  _buildMenuItem(Icons.verified, "Certificate", () {
                    _navigateTo(context, const CertificateScreen());
                  }),
                  const SizedBox(height: 20),
                  // _buildMenuItem(Icons.description, "Terms & Conditions", () {
                  //   _navigateTo(context, const TermsScreen());
                  // }),
                  _buildMenuItem(Icons.description, "Terms & Conditions", () {
                    _navigateTo(context, const TermsScreen());
                  }),
                  const SizedBox(height: 20),
                  _buildMenuItem(Icons.info, "About Us", () {
                    _navigateTo(context, const AboutScreen());
                  }),
                  const SizedBox(height: 20),
                  _buildMenuItem(Icons.help, "FAQs", () {
                    _navigateTo(context, const FAQsScreen());
                  }),
                  // const SizedBox(height: 20),
                  // _buildMenuItem(Icons.lock_reset, "Reset Password", () {
                  //   _navigateTo(context, const ResetPasswordScreen());
                  // }),
                  const SizedBox(height: 20),
                  // Logout Button
                  ListTile(
                    leading: const Icon(Icons.logout, color: Color(0xFF4B1FA1)),
                    title: const Text(
                      "Logout",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      _logout(context);
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF4B1FA1)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        // Add this trailing property
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}

void _navigateTo(BuildContext context, Widget screen) {
  Navigator.pop(context);
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}

void _logout(BuildContext context) async {
  AuthRepository repo = AuthRepository();
  repo.logout();

  GoogleAuthRepository googleRepo = GoogleAuthRepository();
  await googleRepo.signOut();

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
    (Route<dynamic> route) => false,
  );
}
