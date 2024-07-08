import 'package:flutter/material.dart';

class CircularCounter extends StatefulWidget {
  final int number;

  CircularCounter({required this.number});

  @override
  _CircularCounterState createState() => _CircularCounterState();
}

class _CircularCounterState extends State<CircularCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Transform.scale(
              scale: _animation.value,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      border: Border.all(
                        color: Colors.white, // Màu của viền
                        width: 5, // Độ dày của viền
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${widget.number}',
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white, // Màu của số
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  const Text(
                    'Tổng số truyện',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
