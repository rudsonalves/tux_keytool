import 'dart:async';

import 'package:flutter/material.dart';

class SpinBoxField extends StatefulWidget {
  final int value;
  final String labelText;
  final TextStyle? style;
  final String? hintText;
  final TextEditingController controller;
  final int flex;
  final int minValue;
  final int maxValue;
  final int increment;
  final InputDecoration? decoration;
  final void Function(int)? onChanged;

  const SpinBoxField({
    super.key,
    this.value = 0,
    required this.labelText,
    this.style,
    this.hintText,
    required this.controller,
    this.flex = 1,
    this.minValue = 0,
    this.maxValue = 10,
    this.increment = 1,
    this.decoration,
    this.onChanged,
  });

  @override
  State<SpinBoxField> createState() => _SpinBoxFieldState();
}

class _SpinBoxFieldState extends State<SpinBoxField> {
  late int value;
  Timer? _incrementTimer;
  Timer? _decrementTimer;
  bool _isLongPressActive = false;

  @override
  void initState() {
    super.initState();

    value = widget.value;
    widget.controller.text = value.toString();
  }

  void _increment() {
    if (value < widget.maxValue) {
      value += widget.increment;
      widget.controller.text = value.toString();
      if (widget.onChanged != null) {
        widget.onChanged!(value);
      }
    }
  }

  void _decrement() {
    if (value > widget.minValue) {
      value -= widget.increment;
      widget.controller.text = value.toString();
      if (widget.onChanged != null) {
        widget.onChanged!(value);
      }
    }
  }

  void _longIncrement() {
    _incrementTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        if (value < widget.maxValue) {
          _increment();
        } else {
          _incrementTimer?.cancel();
        }
      },
    );
  }

  void _longDecrement() {
    _decrementTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        if (value > widget.minValue) {
          _decrement();
        } else {
          _decrementTimer?.cancel();
        }
      },
    );
  }

  void _stopIncrement() => _incrementTimer?.cancel();

  void _stopDecrement() => _decrementTimer?.cancel();

  void _onLongPressIncrement() {
    _isLongPressActive = true;
    _longIncrement();
  }

  void _onLongPressDecrement() {
    _isLongPressActive = true;
    _longDecrement();
  }

  void _onLongPressEndIncrement(LongPressEndDetails details) {
    _isLongPressActive = false;
    _stopIncrement();
  }

  void _onLogPressEndDecrement(LongPressEndDetails details) {
    _isLongPressActive = false;
    _stopDecrement();
  }

  void _onTapIncrement() {
    if (!_isLongPressActive) {
      _increment();
    }
  }

  void _onTapDecrement() {
    if (!_isLongPressActive) {
      _decrement();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 60,
            child: Ink(
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: GestureDetector(
                onLongPress: _onLongPressDecrement,
                onLongPressEnd: _onLogPressEndDecrement,
                child: InkWell(
                  onTap: _onTapDecrement,
                  customBorder: const CircleBorder(),
                  child: const SizedBox(
                    width: 48,
                    height: 48,
                    child: Icon(Icons.arrow_back_ios, size: 24),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: TextField(
              controller: widget.controller,
              readOnly: true,
              textAlign: TextAlign.center,
              style: widget.style,
              decoration: widget.decoration,
            ),
          ),
          SizedBox(
            width: 60,
            child: Ink(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: GestureDetector(
                onLongPress: _onLongPressIncrement,
                onLongPressEnd: _onLongPressEndIncrement,
                child: InkWell(
                  onTap: _onTapIncrement,
                  customBorder: const CircleBorder(),
                  child: const SizedBox(
                    width: 48,
                    height: 48,
                    child: Icon(Icons.arrow_forward_ios, size: 24),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
