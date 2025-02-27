import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  final String exerciseName;
  final String weight;
  final String reps;
  final String sets;
  final bool isCompleted;
  void Function(bool?)? onCheckBoxChanged;
  ExerciseTile({
    super.key,
    required this.exerciseName,
    required this.weight,
    required this.reps,
    required this.sets,
    required this.isCompleted,
    required this.onCheckBoxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16), color: Colors.green),
          child: ListTile(
            title: Text(exerciseName),
            subtitle: Row(
              children: [
                Chip(label: Text('${weight}Kg')),
                Chip(label: Text('$reps reps')),
                Chip(label: Text('$sets reps')),
              ],
            ),
            trailing: Checkbox(
              value: isCompleted,
              onChanged: (value) => onCheckBoxChanged!(value),
            ),
          )),
    );
  }
}
