import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'home_screen.dart';
import 'alerts_screen.dart';
import 'profile_screen.dart';

/// Main navigation screen with bottom navigation bar
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const AlertsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: AppTheme.neutralGrey.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  _NavItem(
                    label: 'HOME',
                    isSelected: _currentIndex == 0,
                    activeIcon: Icons.home,
                    inactiveIcon: Icons.home_outlined,
                    onTap: () {
                      setState(() {
                        _currentIndex = 0;
                      });
                    },
                  ),
                  _NavItem(
                    label: 'ALERTS',
                    isSelected: _currentIndex == 1,
                    activeIcon: Icons.notifications,
                    inactiveIcon: Icons.notifications_none,
                    onTap: () {
                      setState(() {
                        _currentIndex = 1;
                      });
                    },
                  ),
                  _NavItem(
                    label: 'PROFILE',
                    isSelected: _currentIndex == 2,
                    activeIcon: Icons.person,
                    inactiveIcon: Icons.person_outline,
                    onTap: () {
                      setState(() {
                        _currentIndex = 2;
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'SECURE ACCESS',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: AppTheme.neutralGrey,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 3.0,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: AppTheme.neutralGrey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'PRIVACY ENSURED',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: AppTheme.neutralGrey,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 3.0,
                    ),
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

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.isSelected,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppTheme.primaryBlack : AppTheme.neutralGrey;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppTheme.primaryBlack : AppTheme.neutralGrey,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}