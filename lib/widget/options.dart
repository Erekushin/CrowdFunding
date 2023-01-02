import 'package:flutter/material.dart';

// ignore: must_be_immutable
class OptionsHorizontal extends StatefulWidget {
  OptionsHorizontal(
      {Key? key,
      required this.valueList,
      required this.selected,
      required this.func})
      : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  final valueList;
  String selected;
  Function func;
  @override
  State<OptionsHorizontal> createState() => _OptionsHorizontalState();
}

class _OptionsHorizontalState extends State<OptionsHorizontal> {
  @override
  Widget build(BuildContext context) {
    String a = widget.selected;
    return Wrap(
      children: widget.valueList.map<Widget>((value) {
        final selected = a == value;
        final color = selected ? Colors.green : Colors.grey.shade400;
        return SizedBox(
          width: 90,
          height: 50,
          child: InkWell(
            onTap: () {
              widget.selected = value;
              widget.func(value);
              setState(() {});
            },
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: 15,
                  height: 15,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: color),
                ),
                Text(value)
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
