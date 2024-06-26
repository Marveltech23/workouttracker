import 'package:hive/hive.dart';
import 'package:workout_tracker/date_time/date_time.dart';
import 'package:workout_tracker/models/exercises.dart';
import 'package:workout_tracker/models/workout.dart';

class HiveDatabase {
  //refrence the hive box
  final _myBox = Hive.box('workout_database1');

  //check if there is already data stored, if not,record the start date
  bool previousDataExists() {
    if (_myBox.isEmpty) {
      _myBox.put('START_DATE', todaysDateYYYYMMDD());
      return false;
    } else {
      print('Previous data does exist');
      return true;
    }
  }

  //return start data as yymmdd
  String getStartDate() {
    return _myBox.get('START_DATE');
  }

// Write data

  void saveToDatabase(List<Workout> workouts) {
    //convert object into lists of strings so that i can save into hive

    final workoutList = convertObjectToWorkOutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    //check if execises has been done

    // if (exerciseCompleted(workouts)) {
    //   _myBox.put('COMPLETION_STATUS_', + todaysDateYYYYMMDD(), 1);
    //   _myBox.put("", + todaysDateYYYYMMDD(), 1);
    // }else {
    //   _myBox.put('COMPLETION_STATUS_', + todaysDateYYYYMMDD(), 0);
    // }

    if (exerciseCompleted(workouts)) {
      _myBox.put('COMPLETION_STATUS_${todaysDateYYYYMMDD()}', 1);
    } else {
      _myBox.put('COMPLETION_STATUS_${todaysDateYYYYMMDD()}', 0);
    }
//save  into hive

    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("EXERCISES", exerciseList);
  }

//read data and return a list of workouts
  List<Workout> readFromDatabase() {
    List<Workout> mySavedWorkOuts = [];

    List<String>? workoutNames = _myBox.get("WORKOUTS");
    List<List<List<dynamic>>>? exerciseDetails = _myBox.get("EXERCISE");

    // Check if the necessary data is not null
    if (workoutNames != null && exerciseDetails != null) {
      // create workout objects
      for (int i = 0; i < workoutNames.length; i++) {
        // each workout can have multiple exercises
        List<Exercise> exercisesInEachWorkout = [];

        if (exerciseDetails.length > i && exerciseDetails[i] != null) {
          for (int j = 0; j < exerciseDetails[i]!.length; j++) {
            // add each exercise into a list
            if (exerciseDetails[i]![j] != null &&
                exerciseDetails[i]![j]!.length >= 5) {
              exercisesInEachWorkout.add(
                Exercise(
                  name: exerciseDetails[i][j][0],
                  weight: exerciseDetails[i][j][1],
                  reps: exerciseDetails[i][j][2],
                  sets: exerciseDetails[i][j][3],
                  isCompleted: exerciseDetails[i][j][4] == "true",
                ),
              );
            }
          }
        }

        Workout workout =
            Workout(name: workoutNames[i], exercises: exercisesInEachWorkout);

        mySavedWorkOuts.add(workout);
      }
    }

    return mySavedWorkOuts;
  }

//check if any exercise have been done

  bool exerciseCompleted(List<Workout> workouts) {
    // go thru each workout

    for (var workOut in workouts) {
      // go thru each exercise in a workout

      for (var exercise in workOut.exercises) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

  int getCompletionStatus(String yyyymmdd) {
    int completionStatus = _myBox.get("COMPLETION_STATUS_" + yyyymmdd) ?? 0;
    return completionStatus;
  }

//converts  the exercises in a workout Object into a  list of strings
}

//convert workout objects into  a list
List<String> convertObjectToWorkOutList(List<Workout> workouts) {
  List<String> workoutList = [];

  for (int i = 0; i < workouts.length; i++) {
    workoutList.add(workouts[i].name);
  }

  return workoutList;
}

//convert the exercises in a workout object into a list string

List<String> convertObjectToWorkOutExercise(List<Workout> workouts) {
  List<String> workoutList = [];

  for (int i = 0; i < workouts.length; i++) {
    workoutList.add(workouts[i].name);
  }

  return workoutList;

//    for(int i = 0; i <workouts.length; i++ ) {
//       List<Exercise> exercisesInWorkOut = workouts[i].exercises;
//          List<List<String>> individualWorkout = [
//          ];
//  }
}

List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [];

  // Go through each workout
  for (int i = 0; i < workouts.length; i++) {
    List<Exercise> exercisesInWorkout = workouts[i].exercises;

    List<List<String>> individualWorkout = [];

    for (int j = 0; j < exercisesInWorkout.length; j++) {
      List<String> individualExercise = [
        exercisesInWorkout[j].name,
        exercisesInWorkout[j].weight,
        exercisesInWorkout[j].reps,
        exercisesInWorkout[j].sets,
        exercisesInWorkout[j].isCompleted.toString(),
      ];

      individualWorkout.add(individualExercise);
    }

    exerciseList.add(individualWorkout);
  }

  return exerciseList;
}

// List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
//   List<List<List<String>>> exerciseList = [];

//   //go through each worlout
//   for (int i = 0; i < workouts.length; i++) {
//     List<Exercise> exercisesInWorkOut = workouts[i].exercises;

//     List<String> individualWorkout = [
//       //upper body
//     ];
//     for (int j = 0; j < exercisesInWorkOut.length; j++) {
//       List<String> individualExercise = [
//         //[biceps, 10kg, 1oreps, 3sets]
//       ];

//       individualExercise.addAll([
//         exercisesInWorkOut[j].name,
//         exercisesInWorkOut[j].weight,
//         exercisesInWorkOut[j].reps,
//         exercisesInWorkOut[j].sets,
//         exercisesInWorkOut[j].isCompleted.toString(),
//       ]);
//       individualWorkout.add(individualExercise);
//     }
//      exerciseList.add(individualWorkout);
//   }

//   return exerciseList;
// }
