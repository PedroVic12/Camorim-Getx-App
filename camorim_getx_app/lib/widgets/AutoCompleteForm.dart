import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AutoCompleteForm extends StatefulWidget {
  const AutoCompleteForm({super.key});

  @override
  State<AutoCompleteForm> createState() => _AutoCompleteFormState();
}

class _AutoCompleteFormState extends State<AutoCompleteForm> {
  final List<String> _options = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Elderberry',
    'Fig',
    'Grapefruit',
    'Honeydew'
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable.empty();
                }
                return _options.where((String option) {
                  return option.contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String selection) {
                print('You selected: $selection');
              },
            ),
          ),
        ],
      ),
    );
  }
}
