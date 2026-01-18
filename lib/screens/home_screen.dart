import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

enum SosState { locked, unlocked, active }

/// Home screen with location display and SOS button
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SosState state = SosState.locked;

  String locationLabel = "Fetching location...";

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    try {
      final ok = await _ensurePermission();
      if (!ok) {
        if (!mounted) return;
        setState(() => locationLabel = "Location disabled");
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final label = await _getAreaCityText(pos.latitude, pos.longitude);

      if (!mounted) return;
      setState(() => locationLabel = label);
    } catch (_) {
      if (!mounted) return;
      setState(() => locationLabel = "Unknown location");
    }
  }

  Future<bool> _ensurePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) return false;
    if (permission == LocationPermission.deniedForever) return false;

    return true;
  }

  Future<String> _getAreaCityText(double lat, double lng) async {
    final placemarks = await placemarkFromCoordinates(lat, lng);
    if (placemarks.isEmpty) return "Unknown location";

    final p = placemarks.first;

    final area = (p.subLocality != null && p.subLocality!.trim().isNotEmpty)
        ? p.subLocality!.trim()
        : ((p.locality != null && p.locality!.trim().isNotEmpty)
            ? p.locality!.trim()
            : null);

    final city = (p.locality != null && p.locality!.trim().isNotEmpty)
        ? p.locality!.trim()
        : ((p.administrativeArea != null && p.administrativeArea!.trim().isNotEmpty)
            ? p.administrativeArea!.trim()
            : "");

    if (area == null && city.isEmpty) return "Unknown location";
    if (area == null) return city;
    if (city.isEmpty) return area;

    // Example: "Indiranagar, Bangalore"
    return "$area, $city";
  }

  void _unlock() {
    setState(() {
      state = SosState.unlocked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double maxWidth = math.min(420, constraints.maxWidth);
            final double availableWidth = maxWidth - 64;
            const double baseButtonSize = 192;
            final double buttonSize = math.min(baseButtonSize, availableWidth);
            final double scale = buttonSize / baseButtonSize;
            final double badgeSize = 56 * scale;
            final double badgeOffset = -8 * scale;
            final double badgeBorder = 4 * scale;
            final double badgeIconSize = 24 * scale;

            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: maxWidth,
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        // HEADER (px-8 pt-16)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32).copyWith(top: 32),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Icon Box (w-12 h-12 border border-black)
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 1),
                                ),
                                child: const Center(
                                  child: Icon(Icons.pets, size: 24, color: Colors.black),
                                ),
                              ),
                              const SizedBox(width: 48, height: 48),
                            ],
                          ),
                        ),

                        // TITLE (px-8 mt-8)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32).copyWith(top: 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "Rapid",
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                    fontSize: 36,
                                    fontWeight: FontWeight.w800,
                                    height: 1.1,
                                    color: Colors.black,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Response Team",
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                    fontSize: 36,
                                    fontWeight: FontWeight.w800,
                                    height: 1.1,
                                    color: Colors.grey.shade400,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 18, color: Colors.grey.shade600),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      locationLabel,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: "Inter",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // CENTER (flex-grow)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // SOS + lock badge
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    _SosGlossyButton(size: buttonSize),
                                    Positioned(
                                      right: badgeOffset,
                                      bottom: badgeOffset,
                                      child: Container(
                                        width: badgeSize,
                                        height: badgeSize,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: badgeBorder,
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            state == SosState.locked ? Icons.lock : Icons.lock_open,
                                            color: Colors.white,
                                            size: badgeIconSize,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  state == SosState.locked ? "Locked for safety" : "Ready",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: "Inter",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  state == SosState.locked
                                      ? "Slide to activate"
                                      : "Hold SOS for 3 seconds",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // BOTTOM (mt-auto)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32).copyWith(bottom: 16),
                          child: Column(
                            children: [
                              if (state == SosState.locked)
                                SlideToActivateBar(onCompleted: _unlock)
                              else
                                const _UnlockedBar(),
                              const SizedBox(height: 24),
                            ],
                          ),
                        )
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

class SlideToActivateBar extends StatefulWidget {
  final VoidCallback onCompleted;

  const SlideToActivateBar({super.key, required this.onCompleted});

  @override
  State<SlideToActivateBar> createState() => _SlideToActivateBarState();
}

class _SlideToActivateBarState extends State<SlideToActivateBar> {
  double knobX = 0;
  bool completed = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        const height = 64.0;
        const knobSize = 64.0;
        final maxX = width - knobSize;

        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (completed) return;
            setState(() {
              knobX = (knobX + details.delta.dx).clamp(0, maxX);
            });
          },
          onHorizontalDragEnd: (_) {
            if (completed) return;

            if (knobX >= maxX * 0.8) {
              setState(() {
                completed = true;
                knobX = maxX;
              });
              Future.delayed(const Duration(milliseconds: 150), () {
                widget.onCompleted();
              });
            } else {
              setState(() => knobX = 0);
            }
          },
          child: Container(
            height: height,
            color: Colors.black,
            child: Stack(
              children: [
                const Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "SLIDE TO ACTIVATE",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 3.2,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: knobSize,
                  top: 0,
                  bottom: 0,
                  child: Container(width: 1, color: Colors.white24),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  left: knobX,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: knobSize,
                    height: knobSize,
                    alignment: Alignment.center,
                    color: Colors.black,
                    child: const Icon(Icons.arrow_forward, color: Colors.white, size: 24),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _UnlockedBar extends StatelessWidget {
  const _UnlockedBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: const Center(
        child: Text(
          "UNLOCKED",
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 3.2,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class _SosGlossyButton extends StatelessWidget {
  const _SosGlossyButton({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final scale = size / 192;
    final borderWidth = 8 * scale;
    final highlightTop = 18 * scale;
    final highlightLeft = 28 * scale;
    final highlightWidth = 135 * scale;
    final highlightHeight = 75 * scale;
    final textSize = 60 * scale;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          center: Alignment(-0.3, -0.3), // ~35% 35%
          radius: 0.9,
          colors: [
            Color(0xFFFF4D4D),
            Color(0xFFB30000),
          ],
        ),
        border: Border.all(color: const Color(0xFFCC0000), width: borderWidth),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 20,
            color: Color(0xFFB30000),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: highlightTop,
            left: highlightLeft,
            child: Container(
              width: highlightWidth,
              height: highlightHeight,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.30),
                    Colors.white.withValues(alpha: 0.00),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              "SOS",
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: textSize,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
