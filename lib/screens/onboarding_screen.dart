import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_constants.dart';
import 'profile_create_screen.dart';

/// Onboarding/Welcome screen
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 80),

                        // App Logo/Icon
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.primaryBlack, width: 2),
                          ),
                          child: const Icon(
                            Icons.pets,
                            size: 32,
                            color: AppTheme.primaryBlack,
                          ),
                        ),

                        const SizedBox(height: 48),

                        // App Title
                        const Text(
                          'Rapid',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primaryBlack,
                            height: 1.1,
                          ),
                        ),

                        const Text(
                          'Response Team',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.neutralGrey,
                            height: 1.1,
                          ),
                        ),

                        const SizedBox(height: 56),

                        // Description
                        const Text(
                          'Grant location access to see alerts in your district and ensure help reaches you quickly.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primaryBlack,
                            height: 1.4,
                            letterSpacing: -0.24,
                          ),
                        ),

                        const Spacer(),

                        // Get Started Button
                        Container(
                          width: double.infinity,
                          height: 80,
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryBlack,
                            borderRadius: BorderRadius.zero,
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ProfileCreateScreen()),
                              );
                            },
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Center(
                                    child: Text(
                                      'GET STARTED',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: AppTheme.pureWhite,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 3.6,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 80,
                                  color: AppTheme.pureWhite,
                                ),
                                const SizedBox(
                                  width: 80,
                                  child: Center(
                                    child: Icon(
                                      Icons.east,
                                      color: AppTheme.pureWhite,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Footer
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'SECURE ACCESS',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: AppTheme.neutralGrey,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 3.6,
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
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 3.6,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 64),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}