import 'package:flutter/material.dart';

Widget buildDropDownField(
    String labelText, String? value, List<String> optionList,
    {ValueChanged? onChanged}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 35.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        DropDownWidget(
          optionList: optionList,
          initialValue: value,
          onChanged: (value) {
            onChanged?.call(value);
          },
        )
      ],
    ),
  );
}

class DropDownWidget<T> extends StatefulWidget {
  String? initialValue = '';
  final ValueChanged<T?>? onChanged;
  final List<String> optionList;
  DropDownWidget(
      {Key? key, this.initialValue, this.onChanged, required this.optionList})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DropDownWidget();
}

class _DropDownWidget extends State<DropDownWidget> {
  // Option 1
  String _selectedOption = '';

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.initialValue!.isEmpty
        ? widget.optionList[0]
        : widget.initialValue!;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      isExpanded: true,
      hint: Text(widget.optionList[0]), // Not necessary for Option 1
      value: _selectedOption,
      onChanged: (newValue) {
        setState(() {
          _selectedOption = newValue.toString();
        });
        widget.onChanged?.call(newValue);
      },
      items: widget.optionList.map((selected) {
        return DropdownMenuItem(
          child: Text(selected),
          value: selected,
        );
      }).toList(),
    );
  }
}
