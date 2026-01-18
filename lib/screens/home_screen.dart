import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../core/providers/location_provider.dart';

/// Home screen with location display and SOS button
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Location is now handled by LocationStateNotifier
  }

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(locationStateProvider);

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
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.primaryBlack, width: 1.5),
                          ),
                          child: const Icon(
                            Icons.pets,
                            size: 24,
                            color: AppTheme.primaryBlack,
                          ),
                        ),

                        const SizedBox(height: 32),

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

                        const SizedBox(height: 16),

                        // Location
                        locationState.when(
                          loading: () => _LocationRow(
                            icon: Icons.location_on,
                            text: 'Detecting location...',
                            textColor: AppTheme.neutralGrey,
                          ),
                          error: (error, stack) => Row(
                            children: [
                              const Icon(
                                Icons.location_off,
                                color: AppTheme.neutralGrey,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'Location unavailable',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.neutralGrey,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  final locationNotifier = ref.read(locationStateProvider.notifier);
                                  await locationNotifier.requestLocationPermission();
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: AppTheme.primaryBlack,
                                  textStyle: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                                child: const Text('ENABLE'),
                              ),
                            ],
                          ),
                          data: (district) {
                            if (district == null) {
                              return Row(
                                children: [
                                  const Icon(
                                    Icons.location_off,
                                    color: AppTheme.neutralGrey,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    child: Text(
                                      'Location permission required',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: AppTheme.neutralGrey,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      final locationNotifier = ref.read(locationStateProvider.notifier);
                                      await locationNotifier.requestLocationPermission();
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppTheme.primaryBlack,
                                      textStyle: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                                    child: const Text('ALLOW'),
                                  ),
                                ],
                              );
                            }

                            return Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: AppTheme.neutralGrey,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    district,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.neutralGrey,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.refresh,
                                    size: 18,
                                    color: AppTheme.neutralGrey,
                                  ),
                                  onPressed: () {
                                    ref.read(locationStateProvider.notifier).refreshLocation();
                                  },
                                ),
                              ],
                            );
                          },
                        ),

                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // SOS Button
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Material(
                                    color: Colors.transparent,
                                    shape: const CircleBorder(),
                                    child: InkWell(
                                      customBorder: const CircleBorder(),
                                      onTap: () {
                                        // TODO: Handle SOS activation
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('SOS activated!'),
                                            backgroundColor: AppTheme.accentRed,
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 220,
                                        height: 220,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: const RadialGradient(
                                            colors: [
                                              Color(0xFFFF0000),
                                              Color(0xFFCC0000),
                                            ],
                                            center: Alignment(-0.2, -0.3),
                                            radius: 0.9,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.4),
                                              blurRadius: 20,
                                            ),
                                          ],
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'SOS',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 40,
                                              fontWeight: FontWeight.w800,
                                              color: AppTheme.pureWhite,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: -4,
                                    bottom: -4,
                                    child: Container(
                                      width: 48,
                                      height: 48,
                                      decoration: const BoxDecoration(
                                        color: AppTheme.primaryBlack,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.lock,
                                          size: 20,
                                          color: AppTheme.pureWhite,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 32),

                              const Text(
                                'Locked for safety',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primaryBlack,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Slide to activate',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.neutralGrey,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Primary CTA
                        Container(
                          width: double.infinity,
                          height: 80,
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryBlack,
                            borderRadius: BorderRadius.zero,
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Center(
                                  child: Text(
                                    'SLIDE TO ACTIVATE',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: AppTheme.pureWhite,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 2.7,
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
                                height: 80,
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

                        const SizedBox(height: 24),
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

class _LocationRow extends StatelessWidget {
  const _LocationRow({
    required this.icon,
    required this.text,
    required this.textColor,
  });

  final IconData icon;
  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppTheme.neutralGrey,
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }
}