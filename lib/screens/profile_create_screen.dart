import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'main_navigation_screen.dart';

/// Profile creation screen for first-time setup
class ProfileCreateScreen extends StatefulWidget {
  const ProfileCreateScreen({super.key});

  @override
  State<ProfileCreateScreen> createState() => _ProfileCreateScreenState();
}

class _ProfileCreateScreenState extends State<ProfileCreateScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  
  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

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
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 64),

                        // App Logo/Icon
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.primaryBlack, width: 1.5),
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

                        const SizedBox(height: 40),

                        // Section Title
                        const Text(
                          'Your Profile',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primaryBlack,
                            height: 1.1,
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Name Field
                        const Text(
                          'NAME',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.neutralGrey,
                            letterSpacing: 1.8,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _nameController,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primaryBlack,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Enter Name',
                            hintStyle: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.neutralGrey,
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppTheme.primaryBlack, width: 1),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppTheme.primaryBlack, width: 1),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppTheme.primaryBlack, width: 1),
                            ),
                            contentPadding: EdgeInsets.only(bottom: 12),
                          ),
                        ),

                        const SizedBox(height: 56),

                        // Mobile Number Field
                        const Text(
                          'MOBILE NUMBER',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.neutralGrey,
                            letterSpacing: 1.8,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _mobileController,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primaryBlack,
                          ),
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            hintText: '+91 00000 00000',
                            hintStyle: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.neutralGrey,
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppTheme.primaryBlack, width: 1),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppTheme.primaryBlack, width: 1),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppTheme.primaryBlack, width: 1),
                            ),
                            contentPadding: EdgeInsets.only(bottom: 12),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Privacy Notice
                        const Text(
                          'MANDATORY FOR ALERTS.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.neutralGrey,
                            letterSpacing: 1.0,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'YOUR PHONE NUMBER IS EXPOSED ONLY WHEN AN SOS ALERT IS ACTIVE. PRIVACY BY DESIGN.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.neutralGrey,
                            letterSpacing: 1.0,
                            height: 1.6,
                          ),
                        ),

                        const Spacer(),

                        // Save & Proceed Button
                        Container(
                          width: double.infinity,
                          height: 72,
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryBlack,
                            borderRadius: BorderRadius.zero,
                          ),
                          child: InkWell(
                            onTap: () {
                              if (_nameController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter your name'),
                                    backgroundColor: AppTheme.errorColor,
                                  ),
                                );
                                return;
                              }

                              if (_mobileController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter your mobile number'),
                                    backgroundColor: AppTheme.errorColor,
                                  ),
                                );
                                return;
                              }

                              // TODO: Save profile data
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
                              );
                            },
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Center(
                                    child: Text(
                                      'SAVE & PROCEED',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: AppTheme.pureWhite,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 4.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 72,
                                  color: AppTheme.neutralGrey,
                                ),
                                const SizedBox(
                                  width: 72,
                                  height: 72,
                                  child: Center(
                                    child: Icon(
                                      Icons.east,
                                      color: AppTheme.pureWhite,
                                      size: 22,
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
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 3.3,
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
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 3.3,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),
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