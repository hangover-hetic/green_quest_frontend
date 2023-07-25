import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import '../style/colors.dart';
import '../utils/date.dart';

class DateInput extends StatelessWidget {
  const DateInput({required this.date, required this.onChanged, super.key});

  final DateTime date;
  final Function(DateTime) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Date: ${formatDateTimeComplete(date)}',
              style: const TextStyle(fontSize: 17, color: green)),
          IconButton(
              onPressed: () {
                DatePicker.showDatePicker(context,
                    minTime: DateTime.now(),
                    maxTime: DateTime.now().add(const Duration(days: 365)),
                    onConfirm: onChanged,
                    currentTime: DateTime.now());
              },
              icon: const Icon(Icons.calendar_today)),
        ],
      ),
    );
  }
}
