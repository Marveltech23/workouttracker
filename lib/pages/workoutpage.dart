import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/components/exercise_title.dart';
import 'package:workout_tracker/data/workout_data.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;

  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  void onCheckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkOutData>(context, listen: false)
        .checkoffExercise(workoutName, exerciseName);
  }

  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setController = TextEditingController();

  void createNewExercise() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add a new exercise'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //exercise name
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'New Exercise name',
                  ),
                  controller: exerciseNameController,
                ),
                // weight
                TextField(
                  controller: weightController,
                  decoration: const InputDecoration(
                    labelText: 'Weight(kg)',
                  ),
                ),
                // reps
                TextField(
                  controller: repsController,
                  decoration: const InputDecoration(
                    labelText: 'Reps',
                  ),
                ),
                //set
                TextField(
                  controller: setController,
                  decoration: const InputDecoration(
                    labelText: 'Set',
                  ),
                ),
              ],
            ),
            actions: [
              //save button
              MaterialButton(
                onPressed: save,
                child: const Text('save'),
              ),
              MaterialButton(
                onPressed: cancel,
                child: const Text('cancel'),
              ),

              //cancle  button
            ],
          );
        });
  }

  void save() {
    // get exercise name from text controller
    String newExercise = exerciseNameController.text;
    String weight = weightController.text;
    String reps = repsController.text;
    String sets = setController.text;

    // add exercise to workoutData List
    Provider.of<WorkOutData>(context, listen: false)
        .addExercise(widget.workoutName, newExercise, weight, reps, sets);

    Navigator.pop(context);
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setController.clear();
  }

  void cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkOutData>(
      builder: (context, value, child) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: createNewExercise,
            child: const Icon(Icons.add),
          ),
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: Text(widget.workoutName),
            centerTitle: true,
          ),
          body: ListView.builder(
              itemCount: value.numberofExercisesInWork(widget.workoutName),
              itemBuilder: (context, index) {
                return ExerciseTile(
                    exerciseName: value
                        .getRelevantwork(widget.workoutName)
                        .exercises[index]
                        .name,
                    weight: value
                        .getRelevantwork(widget.workoutName)
                        .exercises[index]
                        .weight,
                    reps: value
                        .getRelevantwork(widget.workoutName)
                        .exercises[index]
                        .reps,
                    sets: value
                        .getRelevantwork(widget.workoutName)
                        .exercises[index]
                        .sets,
                    isCompleted: value
                        .getRelevantwork(widget.workoutName)
                        .exercises[index]
                        .isCompleted,
                    onCheckBoxChanged: (val) => onCheckBoxChanged(
                        widget.workoutName,
                        value
                            .getRelevantwork(widget.workoutName)
                            .exercises[index]
                            .name));
              }),
        );
      },
    );
  }
}

//  Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     color: Colors.amber,
//                     decoration:
//                         BoxDecoration(borderRadius: BorderRadius.circular(16)),
//                     child: ListTile(
//                       title: Text(value
//                           .getRelevantwork(widget.workoutName)
//                           .exercises[index]
//                           .name),
//                       subtitle: Row(
//                         children: [
//                           Chip(
//                               label: Text(
//                                   '${value.getRelevantwork(widget.workoutName).exercises[index].weight}Kg')),
//                           Chip(
//                               label: Text(
//                                   '${value.getRelevantwork(widget.workoutName).exercises[index].reps}reps')),
//                           Chip(
//                               label: Text(
//                                   '${value.getRelevantwork(widget.workoutName).exercises[index].sets}reps'))
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
