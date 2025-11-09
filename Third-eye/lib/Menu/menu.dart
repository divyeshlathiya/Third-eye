import 'package:flutter/material.dart';
import 'package:thirdeye/Menu/about.dart';
import 'package:thirdeye/Menu/certificate.dart';
import 'package:thirdeye/Menu/edit_profile.dart';
import 'package:thirdeye/Menu/past_score.dart';
import 'package:thirdeye/Menu/terms_condition.dart';
import 'package:thirdeye/repositories/profile_repositories.dart';
import 'package:thirdeye/login_screen.dart';
import 'package:thirdeye/services/auth_manager.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  String? firstName;
  String? profilePicUrl;
  final _profileRepository = ProfileRepository();
  bool _profileUpdated = false; // ✅ to track profile changes

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final profile = await _profileRepository.fetchProfile();
    final name = profile?["first_name"];
    final pic = profile?["profile_pic"];

    setState(() {
      firstName = name ?? "User";
      profilePicUrl = pic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _profileUpdated); // ✅ send update flag when closing
        return false; // prevent double pop
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Menu',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, _profileUpdated),
          ),
        ),
        body: Column(
          children: [
            // User Profile Section
            InkWell(
              onTap: () async {
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                );

                if (updated == true) {
                  await Future.delayed(const Duration(milliseconds: 300));
                  await _loadUserData();
                  setState(() {
                    _profileUpdated = true; // ✅ mark as updated
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Row(
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
                    // Name and Edit label
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          firstName ?? "User",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(
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
                    _buildMenuItem(Icons.dashboard, "Dashboard", () {
                      Navigator.pop(context, _profileUpdated);
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
                    _buildMenuItem(Icons.description, "Terms & Conditions", () {
                      _navigateTo(context, const TermsScreen());
                    }),
                    const SizedBox(height: 20),
                    _buildMenuItem(Icons.info, "About Us", () {
                      _navigateTo(context, const AboutScreen());
                    }),
                    const SizedBox(height: 20),

                    // Logout Button
                    ListTile(
                      leading:
                      const Icon(Icons.logout, color: Color(0xFF4B1FA1)),
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
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}

void _navigateTo(BuildContext context, Widget screen) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}

void _logout(BuildContext context) async {
  final authMang = AuthManager();
  authMang.logout();

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
  );
}
