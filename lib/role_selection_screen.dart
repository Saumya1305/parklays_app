import 'package:flutter/material.dart';
import 'package:parklays/admin_login.dart';
import 'package:parklays/phone_number_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({Key? key}) : super(key: key);

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 🌿 Background Gradient (Same as Phone Number screen)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF6F8F3), // light pastel cream
              Color(0xFFE7F3C7), // soft yellow-green
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🖋 Modern black title with subtle shadow
                  const Text(
                    "Select Your Role",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          blurRadius: 8,
                          color: Colors.black26,
                          offset: Offset(1, 2),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 60),

                  // 🌱 User Button
                  _AnimatedRoleButton(
                    title: "User",
                    gradientColors: const [
                      Color(0xFFD7EE46), // Light lime-green gradient
                      Color(0xFFB9E937),
                    ],
                    shadowColor: const Color(0xFFB9E937),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PhoneNumberScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 25),

                  // 💼 Admin Button
                  _AnimatedRoleButton(
                    title: "Admin",
                    gradientColors: const [
                      Color(0xFFB2DFDB),
                      Color(0xFF4DB6AC),
                    ],
                    shadowColor: const Color(0xFF80CBC4),
                    onPressed: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminLoginScreen(),
                        ),
                      );


                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 🌈 Custom Animated Role Button
class _AnimatedRoleButton extends StatefulWidget {
  final String title;
  final List<Color> gradientColors;
  final Color shadowColor;
  final VoidCallback onPressed;

  const _AnimatedRoleButton({
    required this.title,
    required this.gradientColors,
    required this.shadowColor,
    required this.onPressed,
  });

  @override
  State<_AnimatedRoleButton> createState() => _AnimatedRoleButtonState();
}

class _AnimatedRoleButtonState extends State<_AnimatedRoleButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _glowController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _glowController.reverse();
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onPressed();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 60),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: widget.shadowColor.withOpacity(
                    _isHovered ? 0.6 : (_isPressed ? 0.3 : 0.4)),
                blurRadius: _isHovered ? 20 : 10,
                spreadRadius: _isHovered ? 2 : 0,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          transform: Matrix4.identity()
            ..scale(_isPressed ? 0.97 : 1.0, _isPressed ? 0.97 : 1.0),
          child: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 1.2,
              shadows: [
                Shadow(
                  blurRadius: 10,
                  color: Colors.white24,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
