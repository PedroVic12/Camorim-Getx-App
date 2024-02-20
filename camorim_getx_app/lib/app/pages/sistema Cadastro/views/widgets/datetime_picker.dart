import 'package:flutter/material.dart';

class DateTimeIntervalPickerWidget extends StatefulWidget {
  final Function(DateTime start, DateTime end) onIntervalSelected;

  const DateTimeIntervalPickerWidget(
      {Key? key, required this.onIntervalSelected})
      : super(key: key);

  @override
  State<DateTimeIntervalPickerWidget> createState() =>
      _DateTimeIntervalPickerWidgetState();
}

class _DateTimeIntervalPickerWidgetState
    extends State<DateTimeIntervalPickerWidget> {
  Future<void> _selectDateTimeInterval() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      final TimeOfDay? startTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: 12, minute: 0), // Início do intervalo
      );

      final TimeOfDay? endTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: 20, minute: 0), // Final do intervalo
      );

      if (startTime != null && endTime != null) {
        DateTime startDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          startTime.hour,
          startTime.minute,
        );

        DateTime endDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          endTime.hour,
          endTime.minute,
        );

        widget.onIntervalSelected(startDateTime, endDateTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextButton(
        onPressed: _selectDateTimeInterval,
        child: const Text(
          'Selecionar Intervalo de Horário',
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
