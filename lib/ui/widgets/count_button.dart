import 'package:flutter/material.dart';

class CountButton extends StatelessWidget {
  Widget? child;
  void Function()? onTap;
  CountButton({super.key, this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(29),
              color: Color.fromRGBO(0, 104, 55, 1)),
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
