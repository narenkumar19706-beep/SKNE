import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

/// READY state home screen with location and hold-to-send.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String locationLabel = "Fetching location...";

  late final AnimationController _pulseCtrl;

  bool isHolding = false;
  double holdProgress = 0.0; // 0 -> 1
  Timer? _holdTimer;
  static const Duration holdDuration = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _loadLocation();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _holdTimer?.cancel();
    super.dispose();
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

    return "$area, $city";
  }

  void _onHoldStart() {
    if (isHolding) return;

    setState(() {
      isHolding = true;
      holdProgress = 0.0;
    });

    final start = DateTime.now();

    _holdTimer = Timer.periodic(const Duration(milliseconds: 30), (t) {
      final elapsed = DateTime.now().difference(start);
      final p = elapsed.inMilliseconds / holdDuration.inMilliseconds;

      if (!mounted) return;

      if (p >= 1.0) {
        t.cancel();
        _triggerSOS();
      } else {
        setState(() {
          holdProgress = p.clamp(0.0, 1.0);
        });
      }
    });
  }

  void _onHoldEnd() {
    _holdTimer?.cancel();

    if (!mounted) return;
    setState(() {
      isHolding = false;
      holdProgress = 0.0;
    });
  }

  Future<void> _triggerSOS() async {
    if (!mounted) return;

    setState(() {
      isHolding = false;
      holdProgress = 1.0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("SOS Alert Sent"),
        duration: Duration(seconds: 2),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;
    setState(() {
      holdProgress = 0.0;
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
            final double progressRingSize = 212 * scale;

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
                        // TOP CONTENT
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32).copyWith(top: 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Icon box
                              Container(
                                width: 48,
                                height: 48,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 1),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.pets,
                                    size: 24,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
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
                                  const SizedBox(width: 6),
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
                        // CENTER
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onLongPressStart: (_) => _onHoldStart(),
                                  onLongPressEnd: (_) => _onHoldEnd(),
                                  onLongPressCancel: _onHoldEnd,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      _PulseGlow(
                                        controller: _pulseCtrl,
                                        baseColor: const Color(0xFFCC0000),
                                        size: buttonSize,
                                      ),
                                      _SosGlossyReadyButton(
                                        size: buttonSize,
                                        holdProgress: holdProgress,
                                        isHolding: isHolding,
                                        progressRingSize: progressRingSize,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  "Press and hold for 3s to send alert",
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
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

class _PulseGlow extends StatelessWidget {
  final AnimationController controller;
  final Color baseColor;
  final double size;

  const _PulseGlow({
    required this.controller,
    required this.baseColor,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = controller.value;
        final spread = (t <= 0.7) ? (t / 0.7) * 25.0 : 25.0;
        final opacity = (t <= 0.7) ? 0.40 * (1 - (t / 0.7)) : 0.0;

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: baseColor.withOpacity(opacity),
                blurRadius: 0,
                spreadRadius: spread,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SosGlossyReadyButton extends StatelessWidget {
  final double size;
  final double holdProgress;
  final bool isHolding;
  final double progressRingSize;

  const _SosGlossyReadyButton({
    required this.size,
    required this.holdProgress,
    required this.isHolding,
    required this.progressRingSize,
  });

  @override
  Widget build(BuildContext context) {
    final scale = size / 192;
    final borderWidth = 8 * scale;
    final highlightTop = 18 * scale;
    final highlightLeft = 28 * scale;
    final highlightWidth = 135 * scale;
    final highlightHeight = 75 * scale;
    final textSize = 36 * scale;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              center: Alignment(-0.3, -0.3),
              radius: 0.9,
              colors: [
                Color(0xFFFF4D4D),
                Color(0xFFB30000),
              ],
            ),
            border: Border.all(color: const Color(0xFFCC0000), width: borderWidth),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 10),
                blurRadius: 30,
                color: const Color(0xFFB30000).withOpacity(0.40),
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
                        Colors.white.withOpacity(0.30),
                        Colors.white.withOpacity(0.00),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  "READY",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: textSize,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isHolding)
          SizedBox(
            width: progressRingSize,
            height: progressRingSize,
            child: CircularProgressIndicator(
              value: holdProgress.clamp(0.0, 1.0),
              strokeWidth: 6 * scale,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white.withOpacity(0.85),
              ),
            ),
          ),
      ],
    );
  }
}
