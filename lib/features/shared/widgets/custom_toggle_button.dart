import 'package:flutter/material.dart';

class CustomToggleSwitch extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  final double width;
  final double height;
  final Color activeColor;
  final Color inactiveColor;

  const CustomToggleSwitch({
    super.key,
    this.initialValue = false,
    this.onChanged,
    this.width = 60,
    this.height = 32,
    this.activeColor = Colors.purple,
    this.inactiveColor = Colors.grey,
  });

  @override
  State<CustomToggleSwitch> createState() => _CustomToggleSwitchState();
}

class _CustomToggleSwitchState extends State<CustomToggleSwitch> {
  late bool value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  void toggle() {
    setState(() {
      value = !value;
    });

    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: widget.width,
        height: widget.height,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: value ? widget.activeColor : widget.inactiveColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: widget.height - 8,
            height: widget.height - 8,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
